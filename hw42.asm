.MODEL SMALL
.STACK 100H
.DATA
msgNum DB 'Number: $'
msgRes DB 'Factorial: $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- Вхідне число
    MOV AX, 5       ; <- змінити на потрібне число

    ; --- Вивід числа
    MOV DX, OFFSET msgNum
    MOV AH, 09H
    INT 21H
    MOV BX, AX
    CALL PrintNumber

    ; --- Виклик рекурсивної функції
    MOV DX, 0       ; високі 16 біт
    CALL FactorialRec

    ; --- Вивід результату
    MOV DX, OFFSET msgRes
    MOV AH, 09H
    INT 21H
    CALL PrintNumberDXAX

    ; --- Завершення програми
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; --- Рекурсивна функція факторіалу
; DX:AX = результат
FactorialRec PROC
    CMP AX, 0
    JE BaseCase

    PUSH AX
    PUSH DX

    DEC AX
    CALL FactorialRec      ; рекурсивний виклик

    POP DX
    POP BX                 ; зберігаємо n
    MOV BX, AX             ; BX = n
    MOV AX, DX
    MUL BX                 ; AX*BX -> DX:AX

    RET

BaseCase:
    MOV AX, 1
    MOV DX, 0
    RET
FactorialRec ENDP

; --- Процедури для виводу чисел
PrintNumber PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, 0
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

PrintNumberDXAX PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ; Для простоти виводимо AX (молодші 16 біт)
    MOV BX, AX
    CALL PrintNumber
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNumberDXAX ENDP

END MAIN
