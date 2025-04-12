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
r_atual: .asciz "Resultado atual: "
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
	
	li t0, '-'
	beq a0, t0, subtracao
	
	li t0, '*'
	beq a0, t0, multiplicacao
	
	li t0, '/'
	beq a0, t0, divisao
	
	li t0, 'u'
	beq a0, t0, undo
	
	li t0, 'f'
	beq a0, t0, finalizar
	
	jr ra
	
#-- Função soma
# Lê um inteiro para a operação e faz a soma com a cabeça da lista_encadeada,
# adicionando o valor na lista encadeada
# Parâmetros:
#	a1 - valor da cabeça da lista encadeada
soma:
	# Lê um inteiro
	li a7, 5
	ecall
	
	# Faz a operação de soma com a cabeça da lista encadeada e salva em a2
	add a2, a1, a0 # cabeça lista + número lido
	li a3, '+'
	j finalizar_operacao_atual
	
#-- Função subtracao
# Lê um inteiro para a operação e faz a subtração com a cabeça da lista_encadeada,
# adicionando o valor na lista encadeada
# Parâmetros:
#	a1 - valor da cabeça da lista encadeada
subtracao:
	# Lê um inteiro
	li a7, 5
	ecall
	
	# Faz a operação de subtracao com a cabeça da lista encadeada e salva em a2
	sub a2, a1, a0 # cabeça lista - número lido
	li a3, '-'
	j finalizar_operacao_atual
	
#-- Função multiplicacao
# Lê um inteiro para a operação e faz a multiplicacao com a cabeça da lista_encadeada,
# adicionando o valor na lista encadeada
# Parâmetros:
#	a1 - valor da cabeça da lista encadeada
multiplicacao:
	# Lê um inteiro
	li a7, 5
	ecall
	
	# Faz a operação de multiplicacao com a cabeça da lista encadeada e salva em a2
	mul a2, a1, a0 # cabeça lista * número lido
	li a3, '*'
	j finalizar_operacao_atual
	
#-- Função divisao
# Lê um inteiro para a operação e faz a divisao com a cabeça da lista_encadeada,
# adicionando o valor na lista encadeada
# Parâmetros:
#	a1 - valor da cabeça da lista encadeada
divisao:
	# Lê um inteiro
	li a7, 5
	ecall
	
	# Faz a operação de divisao com a cabeça da lista encadeada e salva em a2
	div a2, a1, a0 # cabeça lista / número lido
	li a3, '/'
	j finalizar_operacao_atual

#-- Função undo
# Desfaz a última operação, imprimindo o resultado atual
undo:
	# Remove o ultimo resultado da lista
	# Empilha o valor de ra
	addi sp, sp, -4 # reserva 4 bytes no stack
	sw ra, 0(sp) # salva o ra atual no stack
	
	jal ra, remove_cabeca_lista
	
	# Desempilha ra
	lw ra, 0(sp) # recupera o ra da stack
	addi sp, sp, 4 # libera os 4 bytes da stack
	
	# Imprime "Resultado atual: "
	la a0, r_atual
	li a7, 4
	ecall
	
	# Imprime resultado atual (cabeça da lista)
	# Empilha o valor de ra
	addi sp, sp, -4 # reserva 4 bytes no stack
	sw ra, 0(sp) # salva o ra atual no stack
	
	jal ra, valor_cabeca_lista
	
	# Desempilha ra
	lw ra, 0(sp) # recupera o ra da stack
	addi sp, sp, 4 # libera os 4 bytes da stack
	
	li a7, 1
	ecall
	
	# Imprime '\n'
	li a0, '\n'
	li a7, 11
	ecall
	
	# Volta para a escolha da operação
	j escolher_operacao
			
#-- Função finalizar
# Encerra a execução da calculadora
finalizar:
	jr ra


#-- Função finalizar_operacao_atual
# Salva o resultado na lista encadeada e imprime o resultado da operação
# Parâmetros:
#	a0 - valor lido da operação atual
#	a1 - valor realizado a operação sobre
#	a2 - resultado da operação
#	a3 - caractere da operacao
finalizar_operacao_atual:
	# Empilha o valor de ra, a0, a1, a2, a3
	addi sp, sp, -20 # reserva 20 bytes no stack
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
	bgt t0, zero, print_operando 
	li a7, 11
	li a0, '('
	ecall
print_operando:
	add a0, t0, zero
	li a7, 1
	ecall
	bgt t0, zero, fim_print_operando
	li a7, 11
	li a0, ')'
	ecall
fim_print_operando:
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

# Funções realacionadas a lista encadeada

# Aloca um espaço para um nó
# Parametro a0: dado guardado	
# Retorno a0: o endereço do nó alocado
aloca_no:
	mv t0, a0 # salva o dado em t0
	li a7, 9 # alocar dinamicamente
	li a0, 8 # 2 words: uma de ponteiro outra de dado 
	ecall
	sw zero, 0(a0) # ponteiro para proximo nó é NULL
	sw t0, 4(a0) # armazena o dado no nó
	jr ra

# Adiciona um valor ao inicio da lista
# Parametro a0: dado guardado na lista
add_inicio_lista:
	addi sp, sp, -4 # reserva 4 bytes no stack
	sw ra, 0(sp) # salva o ra atual no stack
	jal ra, aloca_no  # aloca o nó -> a0 = endereço do novo nó criado
	mv t0, a0 # salva o endereço em t0
	lw ra, 0(sp) # recupera o ra da stack
	addi sp, sp, 4 # libera os 4 bytes da stack
	
	la t1, p_cabeca_lista # t1 = endereço do ponteiro para a cabeça da lista
	lw t2, 0(t1) # t2 = endereço da cabeça da lista
	sw t2, 0(t0) # novo nó aponta para a cabeça da lista
	sw t0, 0(t1) # novo nó vira nova cabeça da lista
	
	jr ra

# Remove o nó que está na cabeça da lista
remove_cabeca_lista:
	la t0, p_cabeca_lista # t0 = endereço do ponteiro para a cabeça da lista
	lw t1, 0(t0) # t1 = endereço da cabeça da lista
	beq zero, t1, fim_remove_cabeca_lista # caso endereço seja NULL
	lw t1, 0(t1) # proximo nó
	sw t1, 0(t0) # proximo nó vira a nova cabeça
fim_remove_cabeca_lista:
	jr ra


# Retorna a0: valor guardado na cabeça da lista 
valor_cabeca_lista:
	mv a0, zero # inicia o valor do dado como 0 (caso não tenha dado na lista)
	la t0, p_cabeca_lista # t0 = endereço do ponteiro para cabeça da lista
	lw t0, 0(t0) # t0 = endereço da cabeça da lista
	beq zero, t0, fim_valor_cabeca_lista # cabeca da lista é NULL 
	lw a0, 4(t0) # a0 = dado guardado na cabeça
fim_valor_cabeca_lista:
	jr ra
