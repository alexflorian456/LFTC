#!/bin/bash

base=$(basename $1 .mlp)

./mlp2asm $base.asm < $1 &&
echo $base.asm &&
nasm $base.asm -f elf64 &&
echo $base.o &&
gcc -g $base.o -o $base &&
echo $base
