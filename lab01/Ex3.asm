# ==========================================================
# Laboratório 1 - Exercício 3
# Análise de Bits e Paridade
#
# Dandi Mateus Aguiar Reis              RA: 10444938
# Leandro Solovjovas dos Santos         RA: 10438426
# Pedro Henrique Marques Ferreira       RA: 10723681
# ==========================================================

.data

msgEntrada: .asciiz "Digite um numero inteiro: "

msgPar: .asciiz "\nO numero e PAR."
msgImpar: .asciiz "\nO numero e IMPAR."

msgBitOn: .asciiz "\nO 5º bit esta ON."
msgBitOff: .asciiz "\nO 5º bit esta OFF."

novaLinha: .asciiz "\n"

.text
.globl main

###########################################################
# Programa Principal
###########################################################

main:

    # Solicita um número ao usuário
    li $v0,4
    la $a0,msgEntrada
    syscall

    # Lê o número
    li $v0,5
    syscall
    move $s0,$v0

###########################################################
# Verificação de Paridade
# Utiliza máscara 1 (00000001)
###########################################################

    andi $t0,$s0,1

    beq $t0,$zero,numeroPar

###########################################################
# Número Ímpar
###########################################################

numeroImpar:

    li $v0,4
    la $a0,msgImpar
    syscall

    j verificaBit5

###########################################################
# Número Par
###########################################################

numeroPar:

    li $v0,4
    la $a0,msgPar
    syscall

###########################################################
# Verificação do 5º bit
# Bit 5 -> máscara 32 (00100000)
###########################################################

verificaBit5:

    andi $t1,$s0,32

    beq $t1,$zero,bitOff

###########################################################
# Bit ligado
###########################################################

bitOn:

    li $v0,4
    la $a0,msgBitOn
    syscall

    j fim

###########################################################
# Bit desligado
###########################################################

bitOff:

    li $v0,4
    la $a0,msgBitOff
    syscall

###########################################################
# Encerramento
###########################################################

fim:

    li $v0,4
    la $a0,novaLinha
    syscall

    li $v0,10
    syscall