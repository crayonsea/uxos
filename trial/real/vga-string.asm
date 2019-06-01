        org     0x7c00
        [bits 16]
        ; vga buffer
        mov     ax, 0xb800
        mov     es, ax
        ; clear screan
        mov     si, 0
        mov     ah, 0x07
        mov     al, ' '
print_blank:
        mov     [es:si], ax
        add     si, 2
        cmp     si, 80*2*2
        jl      print_blank
        ; print string
        mov     si, 0
        mov     ah, 0x07
print_string:
        ; load char
        mov     al, [string + si]
        ; print char
        mov     [es:si], ax
        ; mov to next
        inc     si
        ; not 0, continue
        cmp     al, 0
        jne     print_string

        ; string def
        string  db "hello world!", 0

        ; /home/guest/real/vga-string.bin