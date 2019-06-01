#!/bin/sh
set -e      # 以下任意一条命令出现错误时终止命令
nasm -f bin -o boot/boot.img boot/boot.asm
# boot.img 启动扇区镜像文件

# 操作系统内核可执行文件
nasm -f elf -o cpu/entry.o cpu/entry.asm
gcc -c -m32 -fno-stack-protector -nostdinc -I. -o kernel/main.o kernel/main.c 
gcc -c -m32 -fno-stack-protector -nostdinc -I. -o dev/vga.o dev/vga.c
gcc -c -m32 -fno-stack-protector -nostdinc -I. -o utils/stdio.o utils/stdio.c
# -c: compile; -m32: 32-bit machine code 

# add printf test [link]
ld -m elf_i386 -Ttext=0xC0010000 -o boot/uxos.elf cpu/entry.o kernel/main.o dev/vga.o utils/stdio.o
objcopy -O binary boot/uxos.elf boot/uxos.img
# [link] -m elf_i386: 386 processor; -Ttext: code start position
# 4G: 0~3G: user; 3G~4G: OS; 3G + 64K

cat boot/boot.img boot/uxos.img >boot/fd.img