# ==========================================================
# Laboratorio 3 - Exercicio 1
# Bubble Sort com Alocacao Dinamica e Contadores
#
# Dandi Mateus Aguiar Reis              RA: 10444938
# Leandro Solovjovas dos Santos         RA: 10438426
# Pedro Henrique Marques Ferreira       RA: 10723681
# ==========================================================

.data

msgN: .asciiz "\nDigite a quantidade de numeros: "
msgErroN: .asciiz "\nErro! Deve ser maior que zero.\n"
msgNumero: .asciiz "Digite um numero: "
msgVetor: .asciiz "\nVetor ordenado: "
msgComparacoes: .asciiz "\nTotal de comparacoes: "
msgTrocas: .asciiz "\nTotal de trocas: "
separador: .asciiz " "
novaLinha: .asciiz "\n"

.text
.globl main

###########################################################
# Programa Principal
###########################################################

main:

###########################################################
# Leitura e validacao da quantidade de elementos
###########################################################

lerN:

    li $v0, 4
    la $a0, msgN
    syscall

    li $v0, 5
    syscall
    move $s1, $v0

    # Garante que N seja maior que zero
    bgtz $s1, alocarVetor

    li $v0, 4
    la $a0, msgErroN
    syscall

    j lerN

###########################################################
# Alocacao dinamica do vetor na heap
###########################################################

alocarVetor:

    # Cada inteiro ocupa 4 bytes: tamanho = N * 4
    sll $a0, $s1, 2
    li $v0, 9
    syscall
    move $s0, $v0

###########################################################
# Leitura e armazenamento dos elementos
###########################################################

    li $t0, 0

lerElementos:

    bge $t0, $s1, ordenarVetor

    li $v0, 4
    la $a0, msgNumero
    syscall

    li $v0, 5
    syscall

    # Calcula o endereco do elemento: base + indice * 4
    sll $t1, $t0, 2
    addu $t2, $s0, $t1
    sw $v0, 0($t2)

    addi $t0, $t0, 1
    j lerElementos

###########################################################
# Chamada da rotina Bubble Sort
###########################################################

ordenarVetor:

    move $a0, $s0
    move $a1, $s1
    jal bubbleSort

    # A rotina retorna comparacoes em $v0 e trocas em $v1
    move $s2, $v0
    move $s3, $v1

###########################################################
# Impressao do vetor ordenado
###########################################################

    li $v0, 4
    la $a0, msgVetor
    syscall

    li $t0, 0

imprimirVetor:

    bge $t0, $s1, imprimirContadores

    sll $t1, $t0, 2
    addu $t2, $s0, $t1
    lw $a0, 0($t2)

    li $v0, 1
    syscall

    li $v0, 4
    la $a0, separador
    syscall

    addi $t0, $t0, 1
    j imprimirVetor

###########################################################
# Impressao das comparacoes e trocas
###########################################################

imprimirContadores:

    li $v0, 4
    la $a0, msgComparacoes
    syscall

    li $v0, 1
    move $a0, $s2
    syscall

    li $v0, 4
    la $a0, msgTrocas
    syscall

    li $v0, 1
    move $a0, $s3
    syscall

    li $v0, 4
    la $a0, novaLinha
    syscall

###########################################################
# Encerramento do programa
###########################################################

    li $v0, 10
    syscall

###########################################################
# Rotina Bubble Sort
# Entrada: $a0 = endereco do vetor, $a1 = quantidade
# Saida: $v0 = comparacoes, $v1 = trocas
###########################################################

bubbleSort:

    move $t6, $a0
    addi $t0, $a1, -1
    li $v0, 0
    li $v1, 0

    # Vetores com zero ou um elemento nao precisam de trocas
    blez $t0, fimBubble

loopExterno:

    li $t1, 0

loopInterno:

    bge $t1, $t0, fimPassagem

    # Calcula o endereco do elemento atual
    sll $t2, $t1, 2
    addu $t3, $t6, $t2

    lw $t4, 0($t3)
    lw $t5, 4($t3)

    # Cada comparacao entre elementos adjacentes e contabilizada
    addi $v0, $v0, 1

    # Troca os elementos se estiverem fora de ordem
    ble $t4, $t5, proximoElemento

    sw $t5, 0($t3)
    sw $t4, 4($t3)
    addi $v1, $v1, 1

proximoElemento:

    addi $t1, $t1, 1
    j loopInterno

fimPassagem:

    addi $t0, $t0, -1
    bgtz $t0, loopExterno

fimBubble:

    jr $ra