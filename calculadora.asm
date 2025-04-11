	.data
	.align 0
quebra: .asciz "\n"
	.align 2
ponteiro: .word
	.text
	.align 2
	.globl main
main:
	la s0, ponteiro
	li s1, 5 # contador
loop_criar:
	mv a0, s1
	mul a0, a0, a0 # guardar contador ao quadrado
	jal ra, aloca_no
	sw a0, 0(s0)
	mv s0, a0
	addi s1, s1, -1
	bgt s1, zero, loop_criar
	sw zero, 0(s0) # ponteiro para NULL
	la s0, ponteiro
	lw s0, 0(s0)
loop_imprimir:
	li a7, 1
	lw a0, 4(s0)
	lw s0, 0(s0)
	ecall
	
	li a7, 4
	la a0, quebra
	ecall
	
	bne s0, zero, loop_imprimir
	
	li a7, 10
	ecall

# parametro a0: dado guardado	
# retorna o endereço do nó alocado em a0
aloca_no:
	mv t0, a0
	li a7, 9 # alocar dinamicamente
	li a0, 8 # 2 words: uma de ponteiro outra de dado 
	ecall
	sw t0, 4(a0)
	jr ra