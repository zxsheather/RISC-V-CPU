
0to100.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	00c000ef          	jal	10 <main>
   8:	00100073          	ebreak

0000000c <loop>:
   c:	0000006f          	j	c <loop>

00000010 <main>:
  10:	fe010113          	addi	sp,sp,-32 # 1ffe0 <main+0x1ffd0>
  14:	00112e23          	sw	ra,28(sp)
  18:	00812c23          	sw	s0,24(sp)
  1c:	02010413          	addi	s0,sp,32
  20:	fe042623          	sw	zero,-20(s0)
  24:	fe042423          	sw	zero,-24(s0)
  28:	0200006f          	j	48 <main+0x38>
  2c:	fec42703          	lw	a4,-20(s0)
  30:	fe842783          	lw	a5,-24(s0)
  34:	00f707b3          	add	a5,a4,a5
  38:	fef42623          	sw	a5,-20(s0)
  3c:	fe842783          	lw	a5,-24(s0)
  40:	00178793          	addi	a5,a5,1
  44:	fef42423          	sw	a5,-24(s0)
  48:	fe842703          	lw	a4,-24(s0)
  4c:	06400793          	li	a5,100
  50:	fce7dee3          	bge	a5,a4,2c <main+0x1c>
  54:	fec42783          	lw	a5,-20(s0)
  58:	00078513          	mv	a0,a5
  5c:	01c12083          	lw	ra,28(sp)
  60:	01812403          	lw	s0,24(sp)
  64:	02010113          	addi	sp,sp,32
  68:	00008067          	ret
