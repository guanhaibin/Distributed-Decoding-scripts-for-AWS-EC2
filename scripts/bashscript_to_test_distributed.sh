#!/bin/bash


max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 10 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 2 2 >> output_for_distributed10.txt
done

max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 11 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 2 2 >> output_for_distributed11.txt
done


max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 12 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 2 2 >> output_for_distributed12.txt
done


max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 13 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 2 2 >> output_for_distributed13.txt
done



max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 14 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 2 2 >> output_for_distributed14.txt
done


max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 15 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 3 2 >> output_for_distributed15.txt
done

max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 16 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 3 2 >> output_for_distributed16.txt
done

max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 17 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 3 2 >> output_for_distributed17.txt
done


max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 18 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 4 2 2 >> output_for_distributed18.txt
done

max=10
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 19 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 4 2 2 >> output_for_distributed19.txt
done

max=5
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 20 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 4 2 >> output_for_distributed20.txt
done

max=6
for (( i=2; i <= $max; ++i ))
do
    mpirun -np 20 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 2 3 >> output_for_distributed20.txt
done

# max=5
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 21 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 4 2 >> output_for_distributed21.txt
# done
#
# max=6
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 21 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 2 3 >> output_for_distributed21.txt
# done
#
# max=5
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 22 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 4 2 >> output_for_distributed22.txt
# done
#
# max=6
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 22 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 2 3 >> output_for_distributed22.txt
# done
#
# max=5
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 23 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 4 2 >> output_for_distributed23.txt
# done
#
# max=6
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 23 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 2 3 >> output_for_distributed23.txt
# done
#
# max=5
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 24 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 4 2 >> output_for_distributed24.txt
# done
#
# max=6
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 24 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 2 3 >> output_for_distributed24.txt
# done
#
# max=5
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 25 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 2 4 2 >> output_for_distributed25.txt
# done
#
# max=6
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 25 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 2 3 >> output_for_distributed25.txt
# done
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 26 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 4 2 3 >> output_for_distributed26.txt
# done
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 27 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 4 3 2 >> output_for_distributed27.txt
# done
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 28 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 4 3 2 >> output_for_distributed28.txt
# done
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 29 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 4 3 2 >> output_for_distributed29.txt
# done
#
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 30 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 3 3 >> output_for_distributed30.txt
# done
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 31 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 3 3 >> output_for_distributed31.txt
# done
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 32 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 3 3 >> output_for_distributed32.txt
# done
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 33 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 3 3 3 >> output_for_distributed33.txt
# done
#
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 34 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 4 2 4 >> output_for_distributed34.txt
# done
#
# max=10
# for (( i=2; i <= $max; ++i ))
# do
#     mpirun -np 35 -hostfile hostsfile python3 silent_distributed_square_3d_coded_mult.py 4 2 4 >> output_for_distributed35.txt
# done
