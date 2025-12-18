# linker.ld
SECTIONS
{
    . = 0x0;
    .text : { *(.text) }
    
    . = 0x10000;  /* 数据段从 64KB 开始，避免与代码段冲突 */
    .data : { *(.data) }
}