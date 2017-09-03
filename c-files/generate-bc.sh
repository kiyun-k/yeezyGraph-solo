#!/bin/sh

for f in *.c
do fname=${f%%.*};
if [ "$fname" != "tests" ]; then
  clang -c -emit-llvm ${f} -o ../${fname}.bc
fi
done;
