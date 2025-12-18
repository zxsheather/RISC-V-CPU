#!/bin/bash

if [ -z "$1" ]; then
    echo "用法: ./compile.sh <文件名前缀>"
    echo "例如: ./compile.sh plus"
    exit 1
fi

NAME=$1

riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -Wl,-Ttext=0x0 -T ./linker.ld -o ${NAME}.elf start.S ${NAME}.c
mkdir -p ${NAME}
touch ${NAME}/${NAME}.asm
riscv64-unknown-elf-objdump -d ${NAME}.elf > ${NAME}/${NAME}.asm
python3 ./extract.py ${NAME}.elf ${NAME}
rm ${NAME}/${NAME}_data.bin
rm ${NAME}/${NAME}_text.bin
cp ${NAME}.c ${NAME}/
echo "编译完成"

