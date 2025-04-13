# calculadora-riscv
## Integrantes
- Caio Draco Araújo Albuquerque Galvão - ########
- Rafael Perez Carmanhani - ########
- Raí Fernando Dal Prá - ########
- Pedro Henrique Barbosa Oliveira - 15483776

## Introdução
O programa consiste em uma implementação de uma calculadora sequencial de inteiros em Assembly RISC-V. Esse projeto faz parte do trabalho da matéria Organização e Arquitetura de Computadores. 

## Como usar o programa
Para rodar o código em Assembly RISC-V, é necessário utilizar o simulador [RARS](https://andrewt0301.github.io/hse-acos-course/software/rars.html). Com o simulador baixado, basta executar no terminal ``java -jar ./rars1_5.java ./calculadora.asm`` que o código será executado na mesma janela.

Para as entradas do usuário, ele deve digitar apenas um número ou uma operação por linha. A primeira entrada deve consistir de um número inicial. Para o resto do programa, deve ser digitado uma das operações implementadas e um número, caso seja necessário. Após a operação, o resultado será imprimido no terminal. 

## Operações
- Adicão (+): adiciona o resultado prévio com o valor da entrada
- Subtração (-): subtrai do resultado prévio o valor da entrada
- Multiplicação (*): multiplica o resultado prévio pelo o valor da entrada
- Divisão (/): divide o resultado prévio pelo o valor da entrada
- Undo (u): desfaz a ultima operação realizada
- Finalizar (f): finaliza a execução do programa

## Implementação
### Lista Encadeada
Na implementação da calculadora, foi utilizada a estrutura de dados Lista Encadeada. Isso foi necessário para poder guardar os resultados prévios, possibilitando, assim, o uso da função "undo". O primeiro valor da execução ou o resultado de uma operação aritimética é guardado na cabeça da lista, permitindo, então, que o início dessa lista sempre tenha o resultado mais recente, podendo ser usado como o primeiro operando quando adequado. Quando a operação "undo" é realizada, o valor que está no início da lista é retirado dela, tornando o próximo elemento (o resultado anterior ao atual) a nova cabeça da lista.

Para que isso fosse implementado em Assembly, foi criado na área .data um espaço de uma word em que guarda o endereço para a cabeça da lista (p_cabeca_lista). Inicialmente, o valor que está armazenado é 0, representando assim o um "ponteiro NULL". Na criação dos nós da lista, é alocado 9 bytes na Heap, sendo que os 4 primeiros bytes representam um ponteiro para o próximo nó da lista, os próximos 4 representam o dado guardado no nó, e, por fim, o último byte é para guardar o símbolo da operação realizada (uso estético na saída da função undo). Assim, quando um valor é adicionado na lista, um novo nó é criado, guardando na região do próximo nó o valor que está em p_cabeca_lista. Por fim, o endereço desse novo nó é guardado em p_cabeca_lista, tornando-o a nova cabeça da lista. Na remoção, é visitado o nó em que p_cabeca_lista aponta para obter o endereço do próximo elemento da lista, sobrescrevendo esse valor em p_cabeca_lista.

### Funções
Uma parte essencial para a calculadora é a implementação de funções em Assembly. Essas funções são utilizadas para realizar as operações da calculadora, operações realizadas pela lista e a execução do código principal. Para isso, são utilizadas as instruções "jal" e "jr", em que, respectivamente, faz o jump para um label e guarda o valor do PC atual no registrador ra, e faz o jump para o valor guardado no registrador especificado. Assim, usando essas insttruções, é possível implementar algo similar as funções de uma linguagem de alto nível, permitindo uma legibilidade maior do código. Para os casos em que uma função faz uma chamada de outra função, é necessário guardar os os valores dos registradores usados na stack, com o intuito de poder recuperar os valores desses registradores posteriormente.

## Exemplos de execução: TODO
