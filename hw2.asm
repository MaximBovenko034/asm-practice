section .data
buffer db 12 dup(0)   ; місце для рядка числа

section .text
global _start

_start:
    mov eax, 1234567  ; число для перетворення
    mov esi, buffer    ; покажчик на буфер
    call int2str

    ; тут можна додати код для виводу buffer на екран
    ; або завершення програми

    mov eax, 1        ; sys_exit
    xor ebx, ebx
    int 0x80

;------------------------------------------
; int2str: перетворює число у рядок
; вхід: eax = число, esi = буфер
; вихід: рядок у буфері
;------------------------------------------
int2str:
    mov ecx, 0        ; лічильник цифр
    mov ebx, 10       ; дільник

    cmp eax, 0
    jne .convert
    mov byte [esi], '0'
    inc esi
    mov byte [esi], 0
    ret

.convert:
    mov edi, esi      ; зберігаємо початок буфера
.next_digit:
    xor edx, edx
    div ebx           ; eax = eax / 10, edx = eax % 10
    add dl, '0'
    push dx
    inc ecx
    cmp eax, 0
    jne .next_digit

.write_digits:
    pop dx
    mov [esi], dl
    inc esi
    dec ecx
    jnz .write_digits

    mov byte [esi], 0
    ret

