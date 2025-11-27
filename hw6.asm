; ================================
; HW6 - Sort Function
; Bubble sort for element sizes 1,2,4,8 bytes
; ================================
org 100h

start:

    ; Demo input (можешь менять как хочешь)
    mov si, array_in
    mov di, array_out
    mov cx, 6        ; number of elements
    mov bx, 2        ; element size: 1,2,4,8 bytes

    call sort

    mov ax, 4C00h
    int 21h

; =====================================
; sort procedure
; SI - input array
; DI - output array
; CX - number of elements
; BX - element size (1,2,4,8 bytes)
; =====================================

sort:
    push ax bx cx dx si di bp

    ; Copy input array to output (DI)
    mov bp, cx
    mov dx, bx      ; dx = element size

copy_loop:
    push si
    push di
    mov cx, dx
copy_bytes:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_bytes
    pop di
    pop si
    add si, dx
    add di, dx
    dec bp
    jnz copy_loop

    ; Now DI holds unsorted copy → run bubble sort
    mov bp, cx      ; number of elements

outer_loop:
    mov si, di
    mov dx, bp
    dec dx

inner_loop:
    push si

    ; Compare si and si+bx
    mov cx, bx
    mov si, si
    mov di, si
    add di, bx      ; next element

    mov ah, 0
    mov al, 0

    mov bx, cx
    mov si, si
    mov di, di

    mov cx, bx
    xor ax, ax
    xor bx, bx

compare_bytes:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne decide
    inc si
    inc di
    loop compare_bytes
    jmp no_swap

decide:
    jb no_swap

swap:
    ; swap elements
    mov si, [sp]        ; restore pointer to element 1
    mov di, si
    add di, bx

    mov cx, bx
swap_loop:
    mov al, [si]
    mov bl, [di]
    mov [si], bl
    mov [di], al
    inc si
    inc di
    loop swap_loop

no_swap:
    pop si
    add si, bx
    dec dx
    jnz inner_loop

    dec bp
    jnz outer_loop

    pop bp di si dx cx bx ax
    ret

; ================================
; Test data
; ================================
array_in:
    dw 12, 4, 99, 25, 1, 55

array_out:
    times 100 db 0
