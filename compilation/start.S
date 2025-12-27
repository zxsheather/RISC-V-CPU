    .section .text
    .global _start

_start:
    # 设置栈指针 (Stack Pointer)
    # 假设内存足够，将栈设置在数据段之后的一个高地址
    # 这里设置为 0x20000 (128KB)，可以根据实际内存大小调整
    li sp, 0x20000

    # 跳转到 main 函数
    call main

    # 截取程序返回值
    andi a0, a0, 0xff  

    # main 返回后停止执行
    ebreak
loop:
    j loop
