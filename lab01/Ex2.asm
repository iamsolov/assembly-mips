# ==========================================================
# Laboratório 1 - Exercício 2
# Comparação de Três Números
#
# Dandi Mateus Aguiar Reis              RA: 10444938
# Leandro Solovjovas dos Santos         RA: 10438426
# Pedro Henrique Marques Ferreira       RA: 10723681
# ==========================================================

.data

msg1: .asciiz "Digite o primeiro numero: "
msg2: .asciiz "Digite o segundo numero: "
msg3: .asciiz "Digite o terceiro numero: "

msgMaior: .asciiz "\nMaior valor: "
msgMenor: .asciiz "\nMenor valor: "
msgMeio:  .asciiz "\nValor intermediario: "

novaLinha: .asciiz "\n"

.text
.globl main

###########################################################
# Leitura dos três números
###########################################################

main:

    # Primeiro número
    li $v0,4
    la $a0,msg1
    syscall

    li $v0,5
    syscall
    move $s0,$v0

    # Segundo número
    li $v0,4
    la $a0,msg2
    syscall

    li $v0,5
    syscall
    move $s1,$v0

    # Terceiro número
    li $v0,4
    la $a0,msg3
    syscall

    li $v0,5
    syscall
    move $s2,$v0

###########################################################
# Inicialmente considera o primeiro número como
# maior e menor provisórios.
###########################################################

    move $t0,$s0      # maior
    move $t1,$s0      # menor

###########################################################
# Comparação do segundo número
###########################################################

    bgt $s1,$t0,novoMaior1
    blt $s1,$t1,novoMenor1
    j comparaTerceiro

novoMaior1:
    move $t0,$s1
    j comparaTerceiro

novoMenor1:
    move $t1,$s1

###########################################################
# Comparação do terceiro número
###########################################################

comparaTerceiro:

    bgt $s2,$t0,novoMaior2
    blt $s2,$t1,novoMenor2
    j achaIntermediario

novoMaior2:
    move $t0,$s2
    j achaIntermediario

novoMenor2:
    move $t1,$s2

###########################################################
# O intermediário é o valor que não é nem maior
# nem menor.
###########################################################

achaIntermediario:

    beq $s0,$t0,testaS1
    beq $s0,$t1,testaS1
    move $t2,$s0
    j imprime

testaS1:

    beq $s1,$t0,usaS2
    beq $s1,$t1,usaS2
    move $t2,$s1
    j imprime

usaS2:

    move $t2,$s2

###########################################################
# Impressão dos resultados
###########################################################

imprime:

    # Maior
    li $v0,4
    la $a0,msgMaior
    syscall

    li $v0,1
    move $a0,$t0
    syscall

    # Menor
    li $v0,4
    la $a0,msgMenor
    syscall

    li $v0,1
    move $a0,$t1
    syscall

    # Intermediário
    li $v0,4
    la $a0,msgMeio
    syscall

    li $v0,1
    move $a0,$t2
    syscall

    li $v0,4
    la $a0,novaLinha
    syscall

###########################################################
# Encerramento
###########################################################

    li $v0,10
    syscall