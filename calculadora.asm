	.data
	.align 0
quebra: .asciz "\n"
	.align 2
p_cabeca_lista: .word
	.text
	.align 2
	.globl main
main:
	la s0, p_cabeca_lista
	lw zero, 0(s0) # inicia a cabeça da lista como NULL
	li s1, 5 # contador
loop_criar:
	mv a0, s1
	mul a0, a0, a0 # guardar contador ao quadrado
	jal ra, add_inicio_lista
	addi s1, s1, -1
	bgt s1, zero, loop_criar
	
	li s1, 5
loop_imprimir:
	jal ra, imprime_cabeca_lista
	jal ra, remove_cabeca_lista
	addi s1, s1, -1
	bgt s1, zero, loop_imprimir
	
	li a7, 10
	ecall

# parametro a0: dado guardado	
# retorna o endereço do nó alocado em a0
aloca_no:
	mv t0, a0
	li a7, 9 # alocar dinamicamente
	li a0, 8 # 2 words: uma de ponteiro outra de dado 
	ecall
	sw zero, 0(a0) # ponteiro para proximo nó é NULL
	sw t0, 4(a0) # armazena o dado no nó
	jr ra

# cria um novo nó e o coloca no inicio da lista
# parametro a0: dado guardado na lista
add_inicio_lista:
	addi sp, sp, -4 # reserva 4 bytes no stack
	sw ra, 0(sp) # salva o ra atual no stack
	jal ra, aloca_no  # aloca o nó -> a0 = endereço do novo nó criado
	mv t0, a0 # salva o endereço em t0
	lw ra, 0(sp) # recupera o ra da stack
	addi sp, sp, 4 # libera os 4 bytes da stack
	
	la t1, p_cabeca_lista
	lw t2, 0(t1) # ponteiro para a cabeça da lista
	sw t2, 0(t0) # novo nó aponta para a cabeça da lista
	sw t0, 0(t1) # novo nó vira nova cabeça da lista
	
	jr ra

# imprime a cabeça da lista
imprime_cabeca_lista:
	li a7, 1 # servico de imprimir inteiro
	la a0, p_cabeca_lista # a0 = endereço do ponteiro da cabeça da lista
	lw a0, 0(a0) # a0 = endereço da cabeça da lista
	beq zero, a0, fim_imprime_cabeca_lista # caso a cabeça seja NULL
	lw a0, 4(a0) # a0 = dado na cabeça da lista
	ecall
	li a7, 4 # servico de imprimir string
	la a0, quebra # quebra a linha
	ecall
fim_imprime_cabeca_lista:
	jr ra

remove_cabeca_lista:
	la t0, p_cabeca_lista
	lw t1, 0(t0) # endereço da cabeça da lista
	beq zero, t1, fim_remove_cabeca_lista # caso endereço seja NULL
	lw t1, 0(t1) # proximo nó
	sw t1, 0(t0) # proximo nó vira a nova cabeça
fim_remove_cabeca_lista:
	jr ra
