#!/bin/sh

./project inputs_test/t1.py results/t1.c
gcc -o results/t1.o results/t1.c
./results/t1.o
