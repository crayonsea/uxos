%define CR0_PE		(1 << 0)
%define CR0_MP		(1 << 1)
%define CR0_EM		(1 << 2)
%define CR0_TS		(1 << 3)
%define CR0_WP		(1 << 16)
%define CR0_PG		(1 << 31)

        org     0x7c00
        [bits 16]
        ; First, BIOS loads the bootsector into 0000:7C00.
        cli
        xor     ax, ax
        mov     ds, ax
        mov     ss, ax
        mov     sp, 0

        ; Switch to protect mode 
        lgdt    [gdt_desc]      ; load GDT
        mov     eax, cr0
        or      eax, CR0_PE
        mov     cr0, eax
        jmp     0x08:start32    ; CS = 0x08 - Descriptor Table subscript
        ; descriptor: 
        ; 15~3 -- index     2 -- TI     1~0 -- RPL
        ; 0x08 means the first descriptor

        [bits 32]
start32:
        ; In protect mode
        cli
        mov     ax, 0x10        ; DATA segment -- gdt:2
        mov     ds, ax
        mov     es, ax
        mov     ss, ax
        mov     esp, 0x10000

        mov     ah, 0x0c
        mov     esi, msg
        mov     edi, 0xB8000
print_string:
        mov     al, [esi]
        mov     [edi], ax
        inc     esi
        add     edi, 2
        cmp     al, 0
        jne     print_string

        jmp     $

        align   8                       
gdt:    dw      0,0,0,0         ; dummy - hardware required
        ; CODE
        dw      0xFFFF          ; limit=4GB
        dw      0x0000          ; base address=0
        dw      0x9A00          ; code read/exec
        dw      0x00CF          ; granularity=4096,386
        ; DATA
        dw      0xFFFF          ; limit=4GB
        dw      0x0000          ; base address=0
        dw      0x9200          ; data read/write
        dw      0x00CF          ; granularity=4096,386

        align   8
gdt_desc: 
        dw      23              ; gdt limit=sizeof(gdt) - 1
        dd      gdt

msg:    db "Hello world in protected/paging mode", 0
        times   510-($-$$) db 0
        dw      0xAA55