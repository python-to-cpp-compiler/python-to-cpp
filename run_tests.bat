ECHO  running test 1
.\project.exe .\inputs_test\t1.py results\t1.c
gcc .\results\t1.c -o .\results\t1.o
.\results\t1.o



echo "running test 2"
.\project inputs_test\t2.py results\t2.c
gcc results\t2.c -o results\t2.o
.\results\t2.o

echo "running test 3"
.\project inputs_test\t3.py results\t3.c
gcc results\t3.c -o results\t3.o
.\results\t3.o

echo "running test 4"
.\project inputs_test\t4.py results\t4.c
gcc results\t4.c -o results\t4.o
.\results\t4.o

echo "running test 5"
.\project inputs_test\t5.py results\t5.c
gcc results\t5.c -o results\t5.o
.\results\t5.o
