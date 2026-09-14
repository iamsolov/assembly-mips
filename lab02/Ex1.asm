# ==========================================================
# Laboratório 2 - Exercício 1
# Fatorial usando Função em Assembly MIPS
#
# Dandi Mateus Aguiar Reis              RA: 10444938
# Leandro Solovjovas dos Santos         RA: 10438426
# Pedro Henrique Marques Ferreira       RA: 10723681
# ==========================================================

.data

msg_prompt: .asciiz "Digite um numero inteiro positivo: "
msg_erro:   .asciiz "Entrada invalida! O numero deve ser maior que zero.\n\n"
msg_result: .asciiz "O fatorial e: "

.text
.globl main

###########################################################
# Programa Principal
###########################################################

main:

loop_leitura:

    # Solicita um numero ao usuario
    li $v0, 4
    la $a0, msg_prompt
    syscall

    # Le o numero inteiro
    li $v0, 5
    syscall
    move $t0, $v0

    # Valida a entrada.
    # Se o numero for menor ou igual a zero, solicita uma nova entrada.
    blez $t0, entrada_invalida

    # Passa o numero para a funcao fatorial utilizando o registrador $a0.
    move $a0, $t0

    # Chama a funcao fatorial
    jal fatorial

    # Salva o resultado retornado em $v0
    move $t1, $v0

    # Imprime a mensagem do resultado
    li $v0, 4
    la $a0, msg_result
    syscall

    # Imprime o resultado do fatorial
    li $v0, 1
    move $a0, $t1
    syscall

    # Encerra o programa
    li $v0, 10
    syscall


###########################################################
# Tratamento de entrada invalida
###########################################################

entrada_invalida:

    # Exibe mensagem de erro
    li $v0, 4
    la $a0, msg_erro
    syscall

    # Solicita novamente a entrada
    j loop_leitura


###########################################################
# Funcao: fatorial
#
# Entrada:
#   $a0 = numero para calcular o fatorial
#
# Saida:
#   $v0 = resultado do fatorial
###########################################################

fatorial:

    # Inicializa o resultado com 1
    li $v0, 1

    # Copia o numero para o contador
    move $t2, $a0

loop_fatorial:

    # Verifica se o contador chegou a zero
    blez $t2, fim_fatorial

    # Multiplica o resultado pelo contador
    mul $v0, $v0, $t2

    # Decrementa o contador
    subi $t2, $t2, 1

    # Repete o processo
    j loop_fatorial

fim_fatorial:

    # Retorna para o programa principal
    jr $ra
