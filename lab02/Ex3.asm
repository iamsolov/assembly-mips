# ==========================================================
# Laboratório 2 - Exercício 3
# Conversao Decimal para Binario em Assembly MIPS
#
# Dandi Mateus Aguiar Reis              RA: 10444938
# Leandro Solovjovas dos Santos         RA: 10438426
# Pedro Henrique Marques Ferreira       RA: 10723681
# ==========================================================

.data

# Espaco para armazenar os restos das divisoes
binario:    .space 32

msg_prompt: .asciiz "Digite um numero decimal inteiro positivo: "
msg_erro:   .asciiz "Entrada invalida! O numero deve ser maior que zero.\n\n"
msg_result: .asciiz "O numero em binario e: "

.text
.globl main

###########################################################
# Programa Principal
###########################################################

main:

loop_leitura:

    # Solicita um numero decimal ao usuario
    li $v0, 4
    la $a0, msg_prompt
    syscall

    # Le o numero inteiro
    li $v0, 5
    syscall
    move $s0, $v0

    # Valida a entrada.
    # Se for menor ou igual a zero, solicita novamente.
    blez $s0, entrada_invalida

    # Passa o numero para a funcao atraves do registrador $a0.
    move $a0, $s0

    # Chama a funcao de conversao
    jal decimal_para_binario

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
# Funcao: decimal_para_binario
#
# Entrada:
#   $a0 = numero decimal positivo
#
# Funcionamento:
#   Divide sucessivamente o numero por 2.
#   Os restos sao armazenados na memoria.
#   Depois, os restos sao lidos de tras para frente.
###########################################################

decimal_para_binario:

    # $t0 = numero atual
    move $t0, $a0

    # $t1 = divisor 2
    li $t1, 2

    # $t2 = indice da memoria
    li $t2, 0


loop_divisoes:

    # Divide o numero por 2
    divu $t0, $t1

    # $t3 recebe o resto
    mfhi $t3

    # $t0 recebe o quociente
    mflo $t0

    # Armazena o resto na memoria
    sb $t3, binario($t2)

    # Avanca para a proxima posicao
    addi $t2, $t2, 1

    # Continua enquanto o quociente for maior que zero
    bgtz $t0, loop_divisoes


###########################################################
# Impressao do resultado
###########################################################

    # Imprime a mensagem do resultado
    li $v0, 4
    la $a0, msg_result
    syscall


loop_imprime_binario:

    # Os restos foram armazenados do menos significativo
    # para o mais significativo.
    # Por isso, a leitura e feita de tras para frente.

    subi $t2, $t2, 1

    # Verifica se todos os bits foram impressos
    bltz $t2, fim_binario

    # Carrega o bit armazenado
    lb $a0, binario($t2)

    # Imprime o bit
    li $v0, 1
    syscall

    # Continua a impressao
    j loop_imprime_binario


fim_binario:

    # Retorna para o programa principal
    jr $ra
