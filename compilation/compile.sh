#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "用法: ./compile.sh <文件名前缀>"
    echo "例如: ./compile.sh plus"
    exit 1
fi

NAME=$1

if [ ! -f "${NAME}.c" ]; then
    echo "错误: 找不到源文件 ${NAME}.c"
    exit 1
fi

LIBGCC=$(riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -print-libgcc-file-name)
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -Wl,-Ttext=0x0 -T ./linker.ld -o ${NAME}.elf start.S ${NAME}.c "${LIBGCC}"
mkdir -p ${NAME}
touch ${NAME}/${NAME}.asm
riscv64-unknown-elf-objdump -d ${NAME}.elf > ${NAME}/${NAME}.asm
python3 ./extract.py ${NAME}.elf ${NAME}
rm -f ${NAME}/${NAME}_data.bin
rm -f ${NAME}/${NAME}_text.bin
cp ${NAME}.c ${NAME}/

# 运行（使用本机编译器生成参考退出码），并写入 ans 文件
if command -v cc >/dev/null 2>&1; then
    cc -O2 -std=c11 -o "${NAME}/${NAME}.host" "${NAME}.c"
    set +e
    "./${NAME}/${NAME}.host"
    EXIT_CODE=$?
    set -e
    echo "${EXIT_CODE}" > "${NAME}/${NAME}.ans"
    echo "运行完成，exit code=${EXIT_CODE} 已写入 ${NAME}/${NAME}.ans"
else
    echo "警告: 未找到本机编译器 cc，跳过运行与 ans 生成"
fi

rm -f ${NAME}/${NAME}.host

echo "编译完成"