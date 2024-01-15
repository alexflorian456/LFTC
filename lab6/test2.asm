section .text
default rel
extern scanf
extern printf
global main

main:

mov rax, 3
mov rdx, 3
mul rdx
mov [t0], rax

mov rax, [t0]
mov rbx, 2
div rbx
mov [t1], rax

mov rax, 2
sub rax, [t1]
mov [t2], rax

mov rax, [t2]
add rax, 4
mov [t3], rax

mov rax, [t3]
mov [a], rax

push rbp
mov rdi, format_printf
mov rsi, [a]
call printf wrt ..plt
pop rbp

mov rax, 60
mov rdi, 0
syscall

section .bss
a resb 8
t0 resb 8
t1 resb 8
t2 resb 8
t3 resb 8

section .data
format_scanf: db "%d", 0
format_printf: db "%d", 10, 0

