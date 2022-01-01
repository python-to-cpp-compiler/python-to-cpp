#!/bin/sh

echo "running test 1"
echo "RUNNING: inputs_test/t1.py results/t1.c"
./project inputs_test/t1.py results/t1.c
echo "Done"
echo "running test 1 tree code state"
echo "Outputs:"
gcc results/t1.c -o results/t1.o
./results/t1.o
echo "Done"

echo "running test 2"
echo "RUNNING: inputs_test/t2.py results/t2.c"
./project inputs_test/t2.py results/t2.c
echo "Done"
echo "running test 2 tree code state"
echo "Outputs:"
gcc results/t2.c -o results/t2.o
./results/t2.o
echo "Done"

echo "running test 3"
echo "RUNNING: inputs_test/t3.py results/t3.c"
./project inputs_test/t3.py results/t3.c
echo "Done"
echo "running test 3 tree code state"
echo "Outputs:"
gcc results/t3.c -o results/t3.o
./results/t3.o
echo "Done"

echo "running test 4"
echo "RUNNING: inputs_test/t4.py results/t4.c"
./project inputs_test/t4.py results/t4.c
echo "Done"
echo "running test 4 tree code state"
echo "Outputs:"
gcc results/t4.c -o results/t4.o
./results/t4.o
echo "Done"

echo "running test 5"
echo "RUNNING: inputs_test/t5.py results/t5.c"
./project inputs_test/t5.py results/t5.c
echo "Done"
echo "running test 5 tree code state"
echo "Outputs:"
gcc results/t5.c -o results/t5.o
./results/t5.o
echo "Done"
