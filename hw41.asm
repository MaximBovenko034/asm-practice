.MODEL SMALL
.STACK 100H
.DATA
msgNum DB 'Number: $'
msgRes DB 'Factorial: $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- Вхідне число в AX
    MOV AX, 5       ; <- змінити на потрібне число

    ; --- Вивід числа
    MOV DX, OFFSET msgNum
    MOV AH, 09H
    INT 21H
    MOV BX, AX
    CALL PrintNumber
    ; --- Обчислення факторіалу
    MOV DX, 0       ; високі 16 біт
    CALL FactorialIter

    ; --- Вивід результату
    MOV DX, OFFSET msgRes
    MOV AH, 09H
    INT 21H
    CALL PrintNumberDXAX

    ; --- Завершення програми
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; --- Ітеративна функція факторіалу
FactorialIter PROC
    MOV CX, AX      ; CX = n
    MOV AX, 1
    MOV DX, 0

    CMP CX, 0
    JE DoneIter

IterLoop:
    ; DX:AX = DX:AX * CX
    MOV BX, AX
    MOV SI, DX
    MUL CX          ; AX = AX*CX, результат у DX:AX
    ; Розширення на DX для 32-бітного результату
    ; Тут робимо просту 16-бітну імітацію, бо MUL дає DX:AX
    DEC CX
    JNZ IterLoop

DoneIter:
    RET
FactorialIter ENDP

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
    ; Для простоти, виводимо лише AX (молодші 16 біт)
    MOV BX, AX
    CALL PrintNumber
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNumberDXAX ENDP

END MAIN
