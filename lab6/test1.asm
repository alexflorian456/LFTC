section .text
default rel
extern scanf
extern printf
global main

main:

push rbp
mov rdi, format_scanf
mov rsi, a
call scanf wrt ..plt
pop rbp

push rbp
mov rdi, format_scanf
mov rsi, b
call scanf wrt ..plt
pop rbp

mov rax, [b]
mul qword [a]
mov [t0], rax

mov rax, [a]
add rax, [t0]
mov [t1], rax

mov rax, [t1]
mov [a], rax

mov rax, [a]
div qword [b]
mov [t2], rax

mov rax, [t2]
sub rax, 1
mov [t3], rax

mov rax, [t3]
mov [b], rax

push rbp
mov rdi, format_printf
mov rsi, [a]
call printf wrt ..plt
pop rbp

push rbp
mov rdi, format_printf
mov rsi, [b]
call printf wrt ..plt
pop rbp

mov rax, 60
mov rdi, 0
syscall

section .bss
a resb 8
b resb 8
t0 resb 8
t1 resb 8
t2 resb 8
t3 resb 8

section .data
format_scanf: db "%d", 0
format_printf: db "%d", 10, 0

