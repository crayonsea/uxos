## 运行环境

运行在 [v86](https://github.com/copy/v86) 虚拟机上

## 项目结构

- [kernel][kernel_url]
  - boot
  - cpu
  - kernel
  - utils
  - dev
- user
- [trial][trial_url]
  - real
  - pmode
  - paging
  - va
  - make


[kernel_url]:https://github.com/123123-github/uxos/tree/master/kernel
[trial_url]:https://github.com/123123-github/uxos/tree/master/trial

## 启动

### 不同模式下启动

[386 内存管理](https://pdos.csail.mit.edu/6.828/2011/readings/i386/c05.htm)

#### 实模式

偏移 `0x7c00`

```nasm
        org     0x7c00
        [bits 16]
        ; First, BIOS loads the bootsector into 0000:7C00.
        ;==================================
        ;   CODE HERE...
        ;==================================
```

#### 保护模式

设置段表

```nasm
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

        ;==================================
        ;   CODE HERE...
        ;==================================

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

        times   510-($-$$) db 0
        dw      0xAA55

```

打开 A20 - 访问 1M 以上空间

```nasm
        ; Enable A20 
wait_8042_1: 
        in      al, 0x64 
        test    al, 0x2
        jnz     wait_8042_1
        mov     al, 0xd1
        out     0x64, al 

wait_8042_2:
        in      al, 0x64 
        test    al, 0x2
        jnz     wait_8042_2
        mov     al, 0xdf
        out     0x60, al
```

#### 分页模式


### 实现输出函数

## makefile 使用

[相关内容参考](https://github.com/123123-github/uxos/blob/master/trial/make/make_ref.md)

