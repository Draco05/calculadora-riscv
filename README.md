1. Introdução
1.1. Integrantes
Caio Draco Araújo Albuquerque Galvão - ########
Rafael Perez Carmanhani - 15485420
Raí Fernando Dal Prá - ########
Pedro Henrique Barbosa Oliveira - 15483776

1.2. Introdução
O programa consiste em uma implementação de uma calculadora sequencial de inteiros em Assembly RISC-V. Esse projeto faz parte do trabalho da matéria Organização e Arquitetura de Computadores.

1.3. Como usar o programa
Para rodar o código em Assembly RISC-V, é necessário utilizar o simulador RARS. Com o simulador baixado, basta executar no terminal java -jar ./rars1_5.java ./calculadora.asm que o código será executado na mesma janela.

Para as entradas do usuário, ele deve digitar apenas um número ou uma operação por linha. A primeira entrada deve consistir de um número inicial. Para o resto do programa, deve ser digitado uma das operações implementadas e um número, caso seja necessário. Após a operação, o resultado será imprimido no terminal.

1.4. Operações
Adicão (+): adiciona o resultado prévio com o valor da entrada
Subtração (-): subtrai do resultado prévio o valor da entrada
Multiplicação (*): multiplica o resultado prévio pelo valor da entrada
Divisão (/): divide o resultado prévio pelo valor da entrada
Undo (u): desfaz a última operação realizada
Finalizar (f): finaliza a execução do programa

1.5. Implementação
1.5.1. Lista Encadeada
Na implementação da calculadora, foi utilizada a estrutura de dados Lista Encadeada. Isso foi necessário para poder guardar os resultados prévios, possibilitando, assim, o uso da função "undo". O primeiro valor da execução ou o resultado de uma operação aritmética é guardado na cabeça da lista, permitindo, então, que o início dessa lista sempre tenha o resultado mais recente, podendo ser usado como o primeiro operando quando adequado. Quando a operação "undo" é realizada, o valor que está no início da lista é retirado dela, tornando o próximo elemento (o resultado anterior ao atual) a nova cabeça da lista, possibilitando o uso da operação "undo" mais de uma vez.

Para que isso fosse implementado em Assembly, foi criado na área .data um espaço de uma word em que guarda o endereço para a cabeça da lista (p_cabeca_lista). Inicialmente, o valor que está armazenado é 0, representando assim o um "ponteiro NULL". Na criação dos nós da lista, é alocado 9 bytes na Heap, sendo que os 4 primeiros bytes representam um ponteiro para o próximo nó da lista, os próximos 4 representam o dado guardado no nó, e, por fim, o último byte é para guardar o símbolo da operação realizada (uso estético na saída da função undo). Assim, quando um valor é adicionado na lista, um novo nó é criado, guardando na região do próximo nó o valor que está em p_cabeca_lista. Por fim, o endereço desse novo nó é guardado em p_cabeca_lista, tornando-o a nova cabeça da lista. Na remoção, é visitado o nó em que p_cabeca_lista aponta para obter o endereço do próximo elemento da lista, sobrescrevendo esse valor em p_cabeca_lista.

1.5.2. Funções
Uma parte essencial para a calculadora é a implementação de funções em Assembly. Essas funções são utilizadas para realizar as operações da calculadora, operações realizadas pela lista e a execução do código principal. Para isso, são utilizadas as instruções "jal" e "jr", em que, respectivamente, faz o jump para um label e guarda o valor do PC atual no registrador ra, e faz o jump para o valor guardado no registrador especificado. Assim, usando essas instruções, é possível implementar algo similar às funções de uma linguagem de alto nível, permitindo uma legibilidade maior do código. Para os casos em que uma função faz uma chamada de outra função, é necessário guardar os os valores dos registradores usados na stack, com o intuito de poder recuperar os valores desses registradores posteriormente.

2. Funcionamento do Código
2.1. Visão Geral
O código implementa uma calculadora que suporta as seguintes operações:

Adição (+): Soma o valor atual (na cabeça da lista) com o novo valor informado.

Subtração (-): Subtrai o novo valor informado do valor atual.

Multiplicação (*): Multiplica o valor atual pelo novo valor.

Divisão (/): Divide o valor atual pelo novo valor, com tratamento especial para divisão por zero.

Undo (u): Reverte a última operação realizada.

Finalizar (f): Finaliza a execução do programa.

2.2. Organização do Código
O código está estruturado em duas partes principais:

2.2.1. Funções da Calculadora
Entrada de Dados:
A função iniciar_calculadora é responsável por ler o primeiro valor da calculadora e armazená-lo como a primeira entrada na lista encadeada.

Escolha de Operação:
A função escolher_operacao capta o caractere que representa a operação desejada pelo usuário e, através de um mecanismo semelhante ao switch/case, direciona o fluxo para a função específica que executará a operação (como soma, subtração, multiplicação, divisão, undo ou finalizar).

2.2.2. Implementação da Lista Encadeada
A lista encadeada é a base para o armazenamento dos resultados intermediários e é essencial para possibilitar a funcionalidade de undo. Cada novo resultado, seja ele o valor inicial ou o resultado de uma operação, é armazenado em um novo nó que se torna a nova "cabeça" da lista. Essa abordagem permite que a reversão (undo) seja realizada de forma eficiente (complexidade O(1)).

Estrutura de Cada Nó

4 bytes: Reservados para o ponteiro que aponta para o próximo nó na lista. Se não houver um próximo nó, esse campo contém o valor 0 (NULL).

4 bytes: Destinados a armazenar o valor inteiro resultante da operação.

1 byte: Utilizado para guardar o símbolo da operação (por exemplo, '+', '-', '*', '/') realizado naquele nó; esse campo serve basicamente para fins estéticos e para melhor compreensão ao utilizar a função undo.

Funcionamento da Manipulação da Lista Encadeada

Inserção (add_inicio_lista):
Quando um novo resultado é calculado, a função add_inicio_lista é chamada. Esta função realiza os seguintes passos:

Aloca dinamicamente um novo nó (através da função aloca_no), utilizando 9 bytes na heap e inicializando os seus campos.

Faz com que o campo "próximo" do novo nó aponte para a antiga cabeça da lista (o resultado anterior).

Atualiza o ponteiro global p_cabeca_lista para que ele aponte para o novo nó, tornando-o a nova cabeça da lista.

Remoção (remove_cabeca_lista):
Quando a operação undo é executada, o programa remove o nó que se encontra na cabeça da lista. O processo consiste em:

Ler o ponteiro para a cabeça da lista.

Atualizar o ponteiro global p_cabeca_lista para apontar para o próximo nó, que se torna a nova cabeça da lista.

Consulta (valor_cabeca_lista):
Para obter o resultado atual da calculadora, a função valor_cabeca_lista retorna o valor e o símbolo da operação armazenados no nó de cabeça da lista. Se a lista estiver vazia, é retornado o valor 0 e um símbolo nulo.

2.3. Detalhamento das Funções
2.3.1. Função iniciar_calculadora
Lê o primeiro número (usando a syscall para leitura de inteiro) e empilha o valor de retorno de forma a preservar o registrador ra (return address).

Chama a função add_inicio_lista para adicionar o valor inicial à lista encadeada.

Após armazenar o dado, o fluxo se direciona para a função escolher_operacao.

2.3.2. Função escolher_operacao
Armazena o valor atual (cabeça da lista) em um registrador temporário (por exemplo, t1) após chamada da função valor_cabeca_lista.

Lê o caractere da operação, compara com os códigos dos caracteres para cada operação aritmética e realiza um jump condicional para a função correspondente (ex.: soma, subtração, etc.).

Se uma operação inválida for digitada, imprime uma mensagem de erro e retorna para a escolha da operação.

2.3.3. Operações Aritméticas
Cada operação (soma, subtração, multiplicação e divisão) segue um padrão semelhante:

Leitura do operando:
São utilizados os registradores para ler o próximo valor da entrada (syscall de leitura de inteiro).

Realização da operação:
O valor da cabeça da lista (resultado anterior) é combinado com o novo valor conforme a operação (por exemplo, add para soma ou sub para subtração).

Armazenamento do novo resultado:
Após o cálculo, o novo valor é empilhado na lista encadeada com o símbolo da operação correspondente, utilizando a função add_inicio_lista.

Tratamento especial na divisão:
Se o valor digitado for zero, o programa imprime uma mensagem de erro e reitera a leitura do valor.

2.3.4. Função undo
Objetivo: Reverter a última operação realizada.

Funcionamento:

Primeiramente, lê os valores da cabeça da lista (resultado atual e o símbolo da operação realizada).

Caso a lista esteja vazia (representada por um ponteiro nulo), imprime uma mensagem informando que não há operações para reverter.

Se houver um elemento, imprime uma mensagem informativa com o símbolo da operação, o valor da operação a ser revertida e o resultado anterior.

Em seguida, a função remove_cabeca_lista é chamada para remover o nó da cabeça, fazendo com que o próximo nó se torne a nova cabeça da lista.

2.3.5. Função finalizar
Imprime uma mensagem de término e retorna o controle ao sistema, encerrando a execução do programa (através da syscall de término).

2.3.6. Funções de Manipulação de Lista Encadeada
aloca_no:
Aloca dinamicamente um nó na heap com 9 bytes e inicializa seus campos (ponteiro para o próximo nó, o valor e o símbolo).

add_inicio_lista:
Insere um novo nó no início da lista. O novo nó aponta para a antiga cabeça e depois seu endereço é atualizado como a nova cabeça da lista.

remove_cabeca_lista:
Remove o nó que está na cabeça da lista, atualizando o ponteiro para que a próxima posição se torne a nova cabeça.

valor_cabeca_lista:
Retorna o valor e o símbolo da operação armazenados na cabeça da lista. Caso a lista esteja vazia, retorna 0 e valor nulo para o símbolo.

3. Decisões de Projeto
3.1. Uso da Lista Encadeada

Memória e Heap:
A alocação dinâmica (usando syscall com 9 bytes) foi implementada para gerenciar os nós da lista. O gerenciamento explícito da memória garante que o armazenamento dos resultados seja feito de forma controlada.

3.2. Modularização com Funções
Chamada e Retorno:
A modularização em funções (por exemplo, soma, subtracao, multiplicacao, divisao, undo e funções auxiliares para a lista encadeada) melhora a legibilidade e facilita a manutenção do código.

Uso de Registradores e da Stack:
Cada chamada de função preserva os valores dos registradores utilizando a stack, garantindo que os registradores utilizados não sejam sobrescritos entre chamadas. Essa abordagem reforça práticas de chamada de procedimento em arquiteturas de baixo nível.

3.3. Tratamento de Erros
Divisão por Zero:
Foi implementada uma verificação para evitar a divisão por zero. Ao identificar o valor zero, o programa exibe uma mensagem de erro e solicita novamente uma entrada válida.

Operação Inválida:
Caso o usuário digite uma operação que não esteja definida, o programa emite uma mensagem de erro e retorna para a etapa de escolha de operação, evitando encerramento abrupto.

4. Prints de Tela 
soma
![image](https://github.com/user-attachments/assets/2c7dc901-5444-4013-a5a4-294fb32ee313)

subtração

multiplicação

divisão

undo

divisão por zero

finalização do programa

5. Dificuldades Encontradas
Durante o desenvolvimento deste projeto foram identificadas diversas dificuldades, dentre elas:

Gerenciamento de Memória:
Trabalhar com alocação dinâmica em Assembly utilizando a syscall para a heap exigiu atenção especial para definir corretamente o número de bytes a serem alocados (no caso, 9 bytes para cada nó) e garantir que os dados fossem armazenados e lidos nas posições corretas.

Uso da Stack e Conservação de Registradores:
A implementação das chamadas de funções (com instruções jal e jr) demandou um cuidado extra para armazenar e recuperar os valores dos registradores, principalmente o ra. Uma gestão inadequada da stack poderia facilmente ocasionar falhas e comportamentos inesperados.

Manipulação de Lista Encadeada:
A implementação da estrutura de lista encadeada em Assembly não é trivial, pois envolve gerenciamento direto de ponteiros. A inserção e remoção de nós requer a correta atualização dos ponteiros, o que exigiu testes rigorosos e análise detalhada dos acessos à memória.

Tratamento de Entradas e Erros:
A leitura e validação das operações e operandos, especialmente no tratamento de divisões por zero e operações inválidas, implicaram na implementação de lógicas condicionais cuidadosas para garantir que o programa não interrompesse sua execução abruptamente.

Manipulação da Pilha:
Uma das principais dificuldades encontradas foi o gerenciamento correto da pilha (stack) durante as chamadas de função.

Preservação de Contexto: Cada chamada de função exigia o armazenamento cuidadoso do registrador ra (return address) e outros registradores importantes na pilha para garantir o retorno correto ao ponto de chamada.

Balanceamento Push/Pop: Foi necessário garantir que toda operação de push (armazenamento na pilha) fosse correspondida por um pop (recuperação da pilha) exatamente equivalente, caso contrário ocorriam desvios inesperados no fluxo do programa.

Alinhamento de Memória: A pilha em RISC-V precisa manter alinhamento de 4 bytes, o que exigiu atenção especial ao reservar espaço para valores menores que uma word (como o byte do símbolo da operação).

Profundidade de Chamadas: Em operações complexas com múltiplas chamadas aninhadas, o controle do estado da pilha tornou-se particularmente desafiador, exigindo um acompanhamento rigoroso dos valores armazenados.
#### Iniciar Calculadora

trecho do código da função

Essa função inicializa a calculadora. O primeiro inteiro é lido, 4 bytes são reservados na stack, o valor é emplihado, recebe o símbolo "0" (primeiro imput) e é adicionado na lista pela função add_inicio_lista. Depois disso, o ra é desempilhado e os 4 bytes da stack são liberados. O código avança para a função escolher_opcao.

## Exemplos de execução: TODO
