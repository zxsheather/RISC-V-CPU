#!/usr/bin/env python3
"""
extract_data.py - 从 ELF 文件中提取代码段和数据段
"""

import sys
import subprocess
import os

def extract_sections(elf_file, output_dir):
    """从 ELF 文件提取 .text 和 .data 段"""
    
    base_name = os.path.splitext(os.path.basename(elf_file))[0]
    
    # 获取段信息
    result = subprocess.run(
        ['riscv64-unknown-elf-readelf', '-S', elf_file],
        capture_output=True, text=True
    )
    
    print("Section information:")
    print(result.stdout)
    
    # 提取 .text 段（代码）
    text_bin = os.path.join(output_dir, f'{base_name}_text.bin')
    subprocess.run([
        'riscv64-unknown-elf-objcopy',
        '-O', 'binary',
        '--only-section=.text',
        elf_file,
        text_bin
    ])
    
    # 提取 .data 段（数据）
    data_bin = os.path.join(output_dir, f'{base_name}_data.bin')
    subprocess.run([
        'riscv64-unknown-elf-objcopy',
        '-O', 'binary',
        '--only-section=.data',
        elf_file,
        data_bin
    ])
    
    # 转换为 txt 格式
    convert_bin_to_txt(text_bin, os.path.join(output_dir, f'{base_name}.txt'))
    convert_bin_to_txt(data_bin, os.path.join(output_dir, f'{base_name}.data'))

def convert_bin_to_txt(bin_file, txt_file):
    """将二进制文件转换为十六进制文本文件"""
    if not os.path.exists(bin_file) or os.path.getsize(bin_file) == 0:
        print(f"Warning: {bin_file} is empty or doesn't exist")
        with open(txt_file, 'w') as f:
            pass  # 创建空文件
        return
    
    with open(bin_file, 'rb') as f:
        data = f.read()
    
    with open(txt_file, 'w') as f:
        # 每 4 字节（32 位）转换为一行
        for i in range(0, len(data), 4):
            if i + 4 <= len(data):
                word = int.from_bytes(data[i:i+4], byteorder='little')
                f.write(f"{word:08x}\n")
            else:
                # 处理不足 4 字节的情况
                remaining = data[i:]
                word = int.from_bytes(remaining + b'\x00' * (4 - len(remaining)), 
                                     byteorder='little')
                f.write(f"{word:08x}\n")
    
    print(f"Converted {bin_file} -> {txt_file} ({len(data)} bytes)")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python extract_data.py <elf_file> <output_dir>")
        print("Example: python extract_data.py plus.elf workload/plus/")
        sys.exit(1)
    
    elf_file = sys.argv[1]
    output_dir = sys.argv[2]
    
    if not os.path.exists(elf_file):
        print(f"Error: {elf_file} not found")
        sys.exit(1)
    
    os.makedirs(output_dir, exist_ok=True)
    extract_sections(elf_file, output_dir)