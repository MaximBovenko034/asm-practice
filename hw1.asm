section .data
    msg db "Hello World!", 0xA
    len equ $ - msg

section .text
    global _start

_start:
    mov eax, 4      ; sys_write
    mov ebx, 1      ; stdout
    mov ecx, msg    ; адрес сообщения
    mov edx, len    ; длина сообщения
    int 0x80

    mov eax, 1      ; sys_exit
    xor ebx, ebx    ; код выхода = 0
    int 0x80
