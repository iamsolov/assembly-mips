# ==========================================================
# Laboratório 2 - Exercício 2
# Sequência de Fibonacci usando Função em Assembly MIPS
#
# Dandi Mateus Aguiar Reis              RA: 10444938
# Leandro Solovjovas dos Santos         RA: 10438426
# Pedro Henrique Marques Ferreira       RA: 10723681
# ==========================================================

.data

msg_prompt:  .asciiz "Digite a quantidade de termos da sequencia de Fibonacci: "
msg_erro:    .asciiz "Entrada invalida! O numero deve ser maior que zero.\n\n"
msg_virgula: .asciiz ", "

.text
.globl main

###########################################################
# Programa Principal
###########################################################

main:

loop_leitura:

    # Solicita a quantidade de termos
    li $v0, 4
    la $a0, msg_prompt
    syscall

    # Le a quantidade de termos
    li $v0, 5
    syscall
    move $s0, $v0

    # Valida a entrada.
    # Se for menor ou igual a zero, solicita novamente.
    blez $s0, entrada_invalida

    # Passa a quantidade de termos para a funcao
    move $a0, $s0

    # Chama a funcao Fibonacci
    jal fibonacci

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
# Funcao: fibonacci
#
# Entrada:
#   $a0 = quantidade de termos
#
# Gera a sequencia:
#   0, 1, 1, 2, 3, 5, ...
###########################################################

fibonacci:

    # $t2 = quantidade de termos restantes
    move $t2, $a0

    # $t0 = F0
    li $t0, 0

    # $t1 = F1
    li $t1, 1

    # Imprime o primeiro termo
    li $v0, 1
    move $a0, $t0
    syscall

    # Um termo ja foi impresso
    subi $t2, $t2, 1


loop_fibonacci:

    # Verifica se todos os termos foram impressos
    blez $t2, fim_fibonacci

    # Imprime a virgula entre os termos
    li $v0, 4
    la $a0, msg_virgula
    syscall

    # Imprime o termo atual
    li $v0, 1
    move $a0, $t1
    syscall

    # Calcula o proximo termo
    # F(n) = F(n-1) + F(n-2)
    add $t3, $t0, $t1

    # Atualiza os termos
    move $t0, $t1
    move $t1, $t3

    # Decrementa a quantidade restante
    subi $t2, $t2, 1

    # Repete o processo
    j loop_fibonacci


fim_fibonacci:

    # Retorna para o programa principal
    jr $ra