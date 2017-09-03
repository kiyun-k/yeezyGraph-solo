#!/bin/bash

clang -emit-llvm -o linkedlist.bc -c c-files/linkedlist.c
clang -emit-llvm -o node.bc -c c-files/node.c
clang -emit-llvm -o graph.bc -c c-files/graph.c
clang -emit-llvm -o queue.bc -c c-files/queue.c
clang -emit-llvm -o map.bc -c c-files/map.c
clang -emit-llvm -o pqueue.bc -c c-files/pqueue.c

./yeezygraph.native <$1> a.ll
llvm-link linkedlist.bc node.bc graph.bc queue.bc map.bc pqueue.bc a.ll -S > run.ll
clang run.ll
./a.out
rm a.ll
rm run.ll
rm ./a.out
