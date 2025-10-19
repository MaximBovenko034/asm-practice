.MODEL SMALL
.STACK 100H
.DATA
msgNum      DB 'Number: $'
msgPrime    DB 'Prime number$'
msgNotPrime DB 'Not a prime number$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- Входное число в AX (можешь заменить на любое)
    MOV AX, 17      ; <- здесь число, которое проверяем

    ; --- Вывод текста "Number: "
    MOV DX, OFFSET msgNum
    MOV AH, 09H
    INT 21H

    ; --- Вывод числа
    MOV BX, AX
    CALL PrintNumber

    ; --- Проверка на простое число
    MOV CX, 2        ; начинаем делить с 2
    MOV DX, 0
    MOV SI, AX       ; сохраняем число

CheckLoop:
    CMP CX, SI
    JGE IsPrime      ; если дошли до числа, оно простое

    MOV AX, SI
    DIV CX           ; AX / CX, остаток в DX
    CMP DX, 0
    JE NotPrime      ; если остаток 0, число не простое

    INC CX
    JMP CheckLoop

IsPrime:
    MOV DX, OFFSET msgPrime
    MOV AH, 09H
    INT 21H
    JMP EndProg

NotPrime:
    MOV DX, OFFSET msgNotPrime
    MOV AH, 09H
    INT 21H

EndProg:
    MOV AH, 4CH
    INT 21H

; --- Процедура вывода числа
PrintNumber PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, 0
    MOV DX, 0

ConvertLoop:
    MOV AX, BX
    MOV DX, 0
    MOV SI, 10
    DIV SI
    PUSH DX
    INC CX
    MOV BX, AX
    CMP AX, 0
    JNE ConvertLoop

PrintLoop:
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP PrintLoop

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNumber ENDP

MAIN ENDP
END MAIN
