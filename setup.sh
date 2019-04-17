#!/bin/bash
echo "===================================================="
echo "AWS EC2 Cluster Setup Script"
echo "Create a cluster on AWS EC2 and set up the environment for MPI"
echo "Make your life easier"
echo "Haibin Guan"
echo "===================================================="
#Global Variables
NUM_NODES=20
PEM_FILE=*.pem
LOCAL_PEM=keypair/$PEM_FILE
PASS=111
USER=haibin
SCRIPT_FOLDER=scripts/*
USER_ACCESS=ubuntu #based on the AMI you picked
SSH_ATTEMPTS=5
SLEEPTIME=3

echo " remove the previous information of instances under the /instance_info"
rm instance_info/*

echo "===================================================="
echo "Creating $NUM_NODES AWS EC2 instances for our cluster"

aws ec2 run-instances --image-id ami-0f65671a86f061fcd --security-group-ids sg-0fe3b8b441cf5254d \
--count $NUM_NODES --instance-type m4.large --key-name iot-cluster --subnet-id subnet-bfc8fbd7 \
--associate-public-ip-address --query 'Instances[*].InstanceId' \
>> instance_info/id_instances.json
echo "DONE and Saved instances info on instance_info/id_instances.json"

echo "list the instances ID"
id_instances=( $(jq -r '.[]' instance_info/id_instances.json) )

id_inst_params=""
for each in "${id_instances[@]}"
do
id_inst_params="$id_inst_params $each"
done

echo "===================================================="
echo "Make sure the status of all of the instances are RUNNING"
running_nodes=0
while [[ $running_nodes != $NUM_NODES ]]; do

aws ec2 describe-instance-status --instance-ids $id_inst_params \
--query "InstanceStatuses[*].InstanceState.Name" \
> instance_info/status_instances.json

status_instances=( $(jq -r '.[]' instance_info/status_instances.json) )

if [[ ${#status_instances[@]} = 0 ]]; then
  sleep $SLEEPTIME
  continue
  fi

  running_nodes=0
  for status in "${status_instances[@]}"; do
  if [[ status != "running" ]]; then
  running_nodes=$((running_nodes+1))
  fi
  done
  sleep $SLEEPTIME
  done
  echo "DONE, All Running!"

  echo "===================================================="
  echo "Getting the Public and Private IPs"
  echo "Saved IPs on instance_info/public_ip_list.json and instance_info/ip_private_list.json"
  aws ec2 describe-instances --instance-ids $id_inst_params \
  --query 'Reservations[0].Instances[*].PublicIpAddress' \
  >> instance_info/public_ip_list.json

  aws ec2 describe-instances --instance-ids $id_inst_params \
  --query 'Reservations[0].Instances[*].PrivateIpAddress' \
  >> instance_info/ip_private_list.json
  echo "===================================================="

  ## list ip instances
  public_ip_list=( $(jq -r '.[]' instance_info/public_ip_list.json) )
  ip_private_list=( $(jq -r '.[]' instance_info/ip_private_list.json) )

  ## setting MASTER
  MASTER=${public_ip_list[0]}
  MASTER_PRIVATE_IP=${ip_private_list[0]}
  echo "===================================================="
  echo "Checking SSH connections on instances"
  for pub_ip in "${public_ip_list[@]}"
  do
  ssh -oStrictHostKeyChecking=no -oConnectionAttempts=$SSH_ATTEMPTS -i $LOCAL_PEM $USER_ACCESS@$pub_ip "exit;"
  echo "$pub_ip is READY!"
  done
  echo "NODES ARE READY TO BE SET UP!"


  echo "===================================================="
  echo "Configure the MASTER::$MASTER NODE"
  scp -i $LOCAL_PEM $SCRIPT_FOLDER $USER_ACCESS@$MASTER:~/

  echo "Send the AMAZON PEM to the MASTER::$MASTER node "
  scp -i $LOCAL_PEM $LOCAL_PEM $USER_ACCESS@$MASTER:~/

  ##config MASTER [cp al posto di cat]
  master_conf="sudo useradd -s /bin/bash -m -d /home/$USER -g root $USER; \
  echo -e \"$PASS\n$PASS\n\" | sudo passwd $USER;\
  chmod 700 ~/.ssh;\
  chmod 600 ~/.ssh/authorized_keys;\
  sudo apt-get update;\
  sudo apt-get install -y python3-dev python3-pip mpich; \
  pip3 install mpi4py numpy;\
  source sourcefile;"
  ssh -oStrictHostKeyChecking=no -i $LOCAL_PEM $USER_ACCESS@$MASTER "$master_conf"
  echo "DONE"

  echo "DONE WITH Configuring the MASTER::$MASTER "
  echo "===================================================="

  echo "===================================================="
  echo "Configurethe SLAVES NODES                           "
  for (( i=1; i<$NUM_NODES; i++ ))
  do
  curr_slave_public_ip=${public_ip_list[$i]}
  scp -i $LOCAL_PEM $SCRIPT_FOLDER $USER_ACCESS@$curr_slave_public_ip:~/
  scp -i $LOCAL_PEM $LOCAL_PEM $USER_ACCESS@$curr_slave_public_ip:~/

  slave_conf="sudo useradd -s /bin/bash -m -d /home/$USER -g root $USER;\
  echo -e \"$PASS\n$PASS\n\" | sudo passwd $USER;\
  chmod 700 ~/.ssh;\
  chmod 600 ~/.ssh/authorized_keys;\
  sudo apt-get update; \
  sudo apt-get install -y python3-dev python3-pip mpich;\
  pip3 install mpi4py numpy;\
  source sourcefile;"

  ssh -oStrictHostKeyChecking=no -i $LOCAL_PEM $USER_ACCESS@$curr_slave_public_ip "$slave_conf"
  done
  echo "DONE WITH Configuring the SLAVES "
  echo "===================================================="


  echo "===================================================="
  echo "Create hostsfile ..."
  rm hostsfile
  for private_ip in "${ip_private_list[@]}"
  do
  echo "$private_ip" >> hostsfile
  done
  echo "Hostsfile has been created!"
  echo "===================================================="

  echo "===================================================="
  echo "Send the hostsfile and add the private IPs in /etc/hosts for all nodes"
  set_hosts="printf \"\n#AWS Build Cluster Script -- ip private nodes\n\" | sudo tee -a /etc/hosts; "
  set_hosts=$set_hosts"printf \"${ip_private_list[0]}   MASTER\n\" | sudo tee -a /etc/hosts; "
  for (( i=1; i<$NUM_NODES; i++ ))
  do
  set_hosts=$set_hosts"printf \"${ip_private_list[$i]}   NODE_$i\n\" | sudo tee -a /etc/hosts; "
  done
  for node in "${public_ip_list[@]}"
  do
  scp -i $LOCAL_PEM hostsfile $USER_ACCESS@$node:~/
  ssh -i $LOCAL_PEM $USER_ACCESS@$node "$set_hosts"
  done

  echo "===================================================="
  echo "===================================================="
  echo "Generate the key file and send the id_rsa.pub to the rest of nodes "
  echo "cat id_rsa.pub >> ~/.ssh/authorized_keys "
  for (( i=0; i<$NUM_NODES; i++ ))
  do
  curr_send_public_ip=${public_ip_list[$i]}
  key_conf="ssh-keygen -t rsa -N \"\" -f ~/.ssh/id_rsa;\
  chmod 600 ~/.ssh/id_rsa.pub;\
  chmod 600 ~/.ssh/id_rsa;\
  sudo bash -c 'cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys';"

  ssh -oStrictHostKeyChecking=no -i $LOCAL_PEM $USER_ACCESS@$curr_send_public_ip "$key_conf"

  for (( j=0; j<$NUM_NODES; j++ ))
  do
  if [[ $j != $i ]]; then
  curr_recv_public_ip=${public_ip_list[$j]}
  echo "$curr_send_public_ip send id_ras $curr_recv_public_ip"

  send_rsa="sudo scp -oStrictHostKeyChecking=no -i $PEM_FILE ~/.ssh/id_rsa.pub $USER_ACCESS@$curr_recv_public_ip:"
  ssh -i $LOCAL_PEM $USER_ACCESS@$curr_send_public_ip "$send_rsa"

  pem_conf="sudo bash -c 'cat id_rsa.pub >> ~/.ssh/authorized_keys';"
  ssh -i $LOCAL_PEM $USER_ACCESS@$curr_recv_public_ip "$pem_conf"
  fi
  done
  done
  echo "DONE"
  echo "===================================================="

  echo "===================================================="
  echo "Trying to ssh connect without keys                  "
  for (( i=0; i<$NUM_NODES; i++ ))
    do
  curr_send_public_ip=${public_ip_list[$i]}
  for (( j=0; j<$NUM_NODES; j++ ))
    do
  if [[ $j != $i ]]; then
  curr_recv_private_ip=${ip_private_list[$j]}
  echo "$curr_send_public_ip ssh connect $curr_recv_private_ip without key"
  ssh_conf="ssh -oStrictHostKeyChecking=no $curr_recv_private_ip "exit";"
  ssh -t -i $LOCAL_PEM $USER_ACCESS@$curr_send_public_ip "$ssh_conf"
  fi
  done
  done
  echo "Done With SSH connection without keys               "
  echo "===================================================="

  echo "===================================================="
  echo "Congradulations!!! The AWS Cluster for MPI is READY!"
  echo "On each instance there is a user with :"
  echo "USERNAME:$USER - PASSWORD:$PASS"
  echo -e "MASTER \tPRIVATE_IP=$MASTER_PRIVATE_IP \tPUBLIC_IP=$MASTER"
  for (( i=1; i<$NUM_NODES; i++ ))
  do
  curr_private_slave_ip=${ip_private_list[$i]}
  curr_public_slave_ip=${public_ip_list[$i]}
  echo -e "SLAVE $i\tPRIVATE_IP=$curr_private_slave_ip \tPUBLIC_IP=$curr_public_slave_ip"
  done
