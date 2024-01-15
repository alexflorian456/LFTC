#!/bin/bash

flex mlp2asm.l
bison -d mlp2asm.y
gcc -g mlp2asm.tab.c lex.yy.c -o mlp2asm
