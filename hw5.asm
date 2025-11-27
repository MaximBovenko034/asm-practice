; ================================
; HW5 - Envelope
; Draw ASCII envelope with width(AH) and height(AL)
; ================================
org 100h

; ------------ INPUT -------------
; For testing you can change these values:
mov AH, 32    ; width
mov AL, 16    ; height

; AH = width
; AL = height

    mov cx, AL          ; outer loop = rows

row_loop:
    push cx

    mov cx, AH          ; inner loop = columns
    mov si, AH
    dec si              ; max index = width-1

    mov di, AL
    dec di              ; max index = height-1

col_loop:

    ; Get current row and col
    mov dx, AL
    sub dx, cx          ; row index = totalRows - cx
    mov bx, AH
    sub bx, cx          ; col index = totalCols - cx

    ; TOP or BOTTOM BORDER
    cmp dx, 0
    je print_star

    cmp dx, di
    je print_star

    ; LEFT or RIGHT BORDER
    cmp bx, 0
    je print_star

    cmp bx, si
    je print_star

    ; MAIN DIAGONAL (from top-left)
    cmp dx, bx
    je print_star

    ; OTHER DIAGONAL (from top-right)
    mov ax, si
    sub ax, bx
    cmp ax, dx
    je print_star

    ; else print space
    mov dl, ' '
    mov ah, 02h
    int 21h
    jmp next_col

print_star:
    mov dl, '*'
    mov ah, 02h
    int 21h

next_col:
    loop col_loop

    ; print newline
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h

    pop cx
    loop row_loop

; exit
mov ax, 4C00h
int 21h
