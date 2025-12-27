# linker.ld
SECTIONS
{
    . = 0x0;
    .text : { *(.text) }
    
    . = 0x10000;  /* 数据段从 64KB 开始 */
    .rodata : { *(.rodata) *(.srodata) }
    .data : { *(.data) *(.sdata) }
    .bss : { *(.bss) *(.sbss) }
}