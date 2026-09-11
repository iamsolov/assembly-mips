# ==========================================================
# Laboratório 1 - Exercício 1
# Calculadora em Assembly MIPS
#
# Dandi Mateus Aguiar Reis              RA: 10444938
# Leandro Solovjovas dos Santos         RA: 10438426
# Pedro Henrique Marques Ferreira       RA: 10723681
# ==========================================================

.data

menu: .asciiz "\n======= MENU =======\n1. Soma\n2. Subtracao\n3. Multiplicacao\n4. Divisao\n5. Sair\nEscolha uma opcao: "

msg1: .asciiz "\nDigite o primeiro numero: "
msg2: .asciiz "Digite o segundo numero: "

msgRes: .asciiz "\nResultado: "

msgQuo: .asciiz "\nQuociente: "
msgResto: .asciiz "\nResto: "

erroMenu: .asciiz "\nOpcao invalida!\n"
erroDiv: .asciiz "\nErro! Divisao por zero nao permitida.\n"

novaLinha: .asciiz "\n"

.text
.globl main

###########################################################
# Programa Principal
###########################################################

main:

###########################################################
# Loop principal do menu
###########################################################

menuLoop:

    # Exibe o menu
    li $v0, 4
    la $a0, menu
    syscall

    # Lê a opção escolhida
    li $v0, 5
    syscall
    move $t0, $v0

    # Seleciona a operação
    beq $t0, 1, soma
    beq $t0, 2, subtracao
    beq $t0, 3, multiplicacao
    beq $t0, 4, divisao
    beq $t0, 5, sair

    # Caso a opção seja inválida
    li $v0, 4
    la $a0, erroMenu
    syscall

    j menuLoop

###########################################################
# Rotina para leitura dos dois operandos
###########################################################

lerNumeros:

    # Primeiro número
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 5
    syscall
    move $s0, $v0

    # Segundo número
    li $v0, 4
    la $a0, msg2
    syscall

    li $v0, 5
    syscall
    move $s1, $v0

    jr $ra

###########################################################
# Soma
###########################################################

soma:

    jal lerNumeros

    add $t1, $s0, $s1

    li $v0, 4
    la $a0, msgRes
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

    j menuLoop

###########################################################
# Subtração
###########################################################

subtracao:

    jal lerNumeros

    sub $t1, $s0, $s1

    li $v0, 4
    la $a0, msgRes
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

    j menuLoop

###########################################################
# Multiplicação
###########################################################

multiplicacao:

    jal lerNumeros

    mult $s0, $s1
    mflo $t1

    li $v0, 4
    la $a0, msgRes
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

    j menuLoop

###########################################################
# Divisão
###########################################################

divisao:

    jal lerNumeros

    # Verifica divisão por zero
    beq $s1, $zero, erroDivisao

    div $s0, $s1

    mflo $t2        # Quociente
    mfhi $t3        # Resto

    # Imprime o quociente
    li $v0, 4
    la $a0, msgQuo
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    # Imprime o resto
    li $v0, 4
    la $a0, msgResto
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

    j menuLoop

###########################################################
# Tratamento de erro: divisão por zero
###########################################################

erroDivisao:

    li $v0, 4
    la $a0, erroDiv
    syscall

    j menuLoop

###########################################################
# Encerramento do programa
###########################################################

sair:

    li $v0, 10
    syscall