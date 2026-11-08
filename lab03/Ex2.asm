# ==========================================================
# Laboratorio 3 - Exercicio 2
# Categorizacao de Numeros em Listas Encadeadas
#
# Dandi Mateus Aguiar Reis              RA: 10444938
# Leandro Solovjovas dos Santos         RA: 10438426
# Pedro Henrique Marques Ferreira       RA: 10723681
# ==========================================================

.data

# Vetor para armazenar os dez numeros digitados
vetor: .space 40

# Ponteiros para o inicio das listas
headPar:   .word 0
headImpar: .word 0

msgEntrada: .asciiz "Digite 10 numeros inteiros:\n"
msgPares:   .asciiz "\nNumeros pares: "
msgImpares: .asciiz "\nNumeros impares: "
msgVazia:   .asciiz "(lista vazia)"
separador:  .asciiz " "
novaLinha:  .asciiz "\n"

.text
.globl main

# ==========================================================
# Programa principal
# ==========================================================

main:
    # Solicita os dez numeros ao usuario
    li $v0, 4
    la $a0, msgEntrada
    syscall

    la $s0, vetor
    li $s1, 10
    li $s2, 0

lerVetor:
    bge $s2, $s1, classificarVetor

    # Le um numero inteiro pelo console
    li $v0, 5
    syscall

    # Calcula o endereco do elemento: base + indice * 4
    sll $t0, $s2, 2
    addu $t1, $s0, $t0
    sw $v0, 0($t1)

    addi $s2, $s2, 1
    j lerVetor

# ==========================================================
# Classifica os numeros em pares e impares
# ==========================================================

classificarVetor:
    li $s2, 0

percorrerVetor:
    bge $s2, $s1, mostrarListas

    # Recupera o elemento atual do vetor
    sll $t0, $s2, 2
    addu $t1, $s0, $t0
    lw $a0, 0($t1)

    # O bit menos significativo determina a paridade
    andi $t2, $a0, 1
    bnez $t2, encaminharImpar

encaminharPar:
    la $a1, headPar
    jal inserirFinal
    j proximoNumero

encaminharImpar:
    la $a1, headImpar
    jal inserirFinal

proximoNumero:
    addi $s2, $s2, 1
    j percorrerVetor

# ==========================================================
# Exibe as duas listas
# ==========================================================

mostrarListas:
    li $v0, 4
    la $a0, msgPares
    syscall

    lw $a0, headPar
    jal imprimirLista

    li $v0, 4
    la $a0, msgImpares
    syscall

    lw $a0, headImpar
    jal imprimirLista

    li $v0, 4
    la $a0, novaLinha
    syscall

    # Encerra a execucao
    li $v0, 10
    syscall

# ==========================================================
# inserirFinal
# Entrada: $a0 = valor; $a1 = endereco do head
# Cada no possui 8 bytes: valor e ponteiro next
# ==========================================================

inserirFinal:
    # Salva os argumentos antes da syscall
    move $t7, $a0
    move $t6, $a1

    # Solicita oito bytes na heap
    li $a0, 8
    li $v0, 9
    syscall

    move $t0, $v0

    # Inicializa os campos do novo no
    sw $t7, 0($t0)
    sw $zero, 4($t0)

    # Verifica se a lista esta vazia
    lw $t1, 0($t6)
    beqz $t1, inserirComoPrimeiro

# Percorre a lista ate o ultimo no
percorrerLista:
    lw $t2, 4($t1)
    beqz $t2, conectarNo

    move $t1, $t2
    j percorrerLista

conectarNo:
    sw $t0, 4($t1)
    jr $ra

# Atualiza o head da lista vazia
inserirComoPrimeiro:
    sw $t0, 0($t6)
    jr $ra

# ==========================================================
# imprimirLista
# Entrada: $a0 = endereco do primeiro no
# ==========================================================

imprimirLista:
    move $t0, $a0

    # Lista vazia quando o endereco inicial e zero
    beqz $t0, imprimirListaVazia

percorrerParaImprimir:
    # Imprime o valor do no atual
    lw $a0, 0($t0)
    li $v0, 1
    syscall

    # Imprime um espaco entre os numeros
    li $v0, 4
    la $a0, separador
    syscall

    # Avanca para o proximo no
    lw $t0, 4($t0)
    bnez $t0, percorrerParaImprimir

    jr $ra

imprimirListaVazia:
    li $v0, 4
    la $a0, msgVazia
    syscall

    jr $ra
