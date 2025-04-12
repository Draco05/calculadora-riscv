#-- Primeiro trabalho prático de Organização e Arquitetura de Computadores
#-- Calculadora sequêncial
#-- 
#-- O código a seguir é a implementação de uma calculadora sequêncial.
#-- Ela possui as seguintes operações:
#--
#-- 	+ <num>: soma o número armazenadado com <num>
#-- 	- <num>: subtrai o número armazenadado com <num>
#-- 	* <num>: multiplica o número armazenadado com <num>
#-- 	/ <num>: divide o número armazenadado por <num>
#-- 	u: desfaz a última operação
#--     f: finaliza a execução da calculadora
#--
#-- Na primeira operação, a entrada consiste de <num> <operacao> <num>.
#-- Cada elemento da entrada deve estar em uma nova linha.

	.data
	.align 0
quebra: .asciz "\n"
operacao: .space 3
	.align 2
p_cabeca_lista: .word
	.text
	.align 2
	.globl main
main:
	la s0, p_cabeca_lista
	jal ra, iniciar_calculadora
	
	li a7, 10
	ecall

#-- Função iniciar_calculadora
# Lê a primeira entrada da calculadora
iniciar_calculadora:
	# Lê um inteiro
	li a7, 5
	ecall 
	
	# Empilha o valor de ra
	addi sp, sp, -4 # reserva 4 bytes no stack
	sw ra, 0(sp) # salva o ra atual no stack
	
	jal ra, add_inicio_lista  # adiciona o valor lido (está em a0) na lista
	
	# Desempilha ra
	lw ra, 0(sp) # recupera o ra da stack
	addi sp, sp, 4 # libera os 4 bytes da stack
	
	# Continua em escolher_operacao

#-- Função escolher_operacao
# Lê um caracetere da operação da entrada e escolhe a função correspondente
# Funciona como um switch/case
# Caso a operação escolhida não existe, ele imprime uma mensagem
escolher_operacao:
	# Lê cabeça da lista e salva em t1
	# Empilha o valor de ra
	addi sp, sp, -4 # reserva 4 bytes no stack
	sw ra, 0(sp) # salva o ra atual no stack
	
	jal ra, valor_cabeca_lista
	add t1, a0, zero
	
	# Desempilha ra
	lw ra, 0(sp) # recupera o ra da stack
	addi sp, sp, 4 # libera os 4 bytes da stack
	
	# Lê caractere da operacao
	la a0, operacao
	li a1, 3 # \n codigo \n
	li a7, 8
	ecall
	lb a0, 0(a0)
	
	# Salva valor da cabeça em a1 (parâmetro das operações)
	add a1, t1, zero
	
	# Escolhe operação
	li t0, '+'
	beq a0, t0, soma
	
	jr ra
	
#-- Função soma
# Lê um inteiro para a operação e faz a soma com a cabeça da lista_encadeada,
# adicionando o valor na pilha
# Parâmetros:
#	a1 - valor da cabeça da lista encadeada
soma:
	# Lê um inteiro
	li a7, 5
	ecall
	
	# Faz a operação de soma com a cabeça da lista encadeada e salva em a2
	add a2, a0, a1 # número lido + cabeça lista
	li a3, '+'
	j finalizar_operacao_atual

#-- Função finalizar_operacao_atual
# Salva o resultado na lista encadeada e imprime o resultado da operação
# Parâmetros:
#	a0 - valor lido da operação atual
#	a1 - valor realizado a operação sobre
#	a2 - resultado da operação
#	a3 - caractere da operacao
finalizar_operacao_atual:
	# Empilha o valor de ra, a0, a1, a2, a3
	addi sp, sp, -20 # reserva 8 bytes no stack
	sw ra, 0(sp) # salva o ra atual no stack
	sw a0, 4(sp) # salva a0 no stack
	sw a1, 8(sp) # salva a1 no stack
	sw a2, 12(sp) # salva a2 no stack
	sw a3, 16(sp) # salva a3 no stack
	
	add a0, a2, zero
	jal ra, add_inicio_lista  # adiciona o em a0 na lista
	
	# Desempilha ra, a0, a1, a2, a3
	lw ra, 0(sp) # recupera o ra da stack
	lw a0, 4(sp) # recupera a0 da stack
	lw a1, 8(sp) # recupera a1 da stack
	lw a2, 12(sp) # recupera a2 da stack
	lw a3, 16(sp) # recupera a3 da stack

	addi sp, sp, 20 # libera os 20 bytes da stack
	
	add t0, a0, zero
	
	# Imprime \n
	li a0, '\n'
	li a7, 11
	ecall
	
	# Imprime: <valor da cabeça (a1)><operacao(a3)><operando(a0)>=<resultado (a2)>
	# Imprime valor da cabeça
	add a0, a1, zero
	li a7, 1
	ecall
	
	# Imprime caracetere da operacao
	add a0, a3, zero
	li a7, 11
	ecall
	
	# Imprime operando
	add a0, t0, zero
	li a7, 1
	ecall
	
	# Imprime '='
	li a0, '='
	li a7, 11
	ecall
	
	# Imprime resultado
	add a0, a2, zero
	li a7, 1
	ecall
	
	# Imprime \n
	li a0, '\n'
	li a7, 11
	ecall
	
	# Volta para a escolha da operação
	j escolher_operacao


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

# retorna em a0 o valor que está na cabeça da lista
valor_cabeca_lista:
	mv a0, zero # inicia o valor do dado como 0
	la t0, p_cabeca_lista # t0 = endereço do ponteiro para cabeça da lista
	lw t0, 0(t0) # t0 = endereço da cabeça da lista
	beq zero, t0, fim_valor_cabeca_lista # cabeca da lista é NULL 
	lw a0, 4(t0) # a0 = dado guardado na cabeça
fim_valor_cabeca_lista:
	jr ra
