section .text
	default rel
	extern scanf
	extern printf
	global main

main:

	push rbp
	mov rdi, fmt_scanf
	mov rsi, a
	call scanf wrt ..plt ; scanf("%d", a)
	pop rbp

	push rbp
	mov rdi, fmt_printf
	mov rsi, [a]
	call printf wrt ..plt ; printf("nr introdus: %d\n", *a)
	pop rbp

	mov rax, 60
	mov rdi, 0
	syscall ; exit(0)

section .bss
	a resb 4 ; int * a

section .data
	fmt_scanf: db "%d", 0
	fmt_printf: db "nr introdus: %d", 10, 0
	