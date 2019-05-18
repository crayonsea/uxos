        org     0x7c00
        [bits 16]
        ; vga buffer
        mov     ax, 0xB800
        mov     es, ax
        ; clear screen
        mov     si, 0
        mov     ah, 0x07
        mov     al, ' '
print_blank:
        mov     [es:si], ax
        add     si, 2
        cmp     si, 160
        jl     print_blank
        ; print 'X' - font red
        mov     ah, 0x0c
        mov     al, 'X'
        mov     [es:0], ax
        
        jmp $

        times 510-($-$$) db 0
        dw      0xAA55


; /home/guest/real/vga-clear.bin