
plus.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	00c000ef          	jal	10 <main>
   8:	00100073          	ebreak

0000000c <loop>:
   c:	0000006f          	j	c <loop>

00000010 <main>:
  10:	fe010113          	addi	sp,sp,-32 # 1ffe0 <verify_data+0xf680>
  14:	00112e23          	sw	ra,28(sp)
  18:	00812c23          	sw	s0,24(sp)
  1c:	02010413          	addi	s0,sp,32
  20:	fe042423          	sw	zero,-24(s0)
  24:	fe042623          	sw	zero,-20(s0)
  28:	0740006f          	j	9c <main+0x8c>
  2c:	000107b7          	lui	a5,0x10
  30:	00078713          	mv	a4,a5
  34:	fec42783          	lw	a5,-20(s0)
  38:	00279793          	slli	a5,a5,0x2
  3c:	00f707b3          	add	a5,a4,a5
  40:	0007a703          	lw	a4,0(a5) # 10000 <input1_data>
  44:	000107b7          	lui	a5,0x10
  48:	4b078693          	addi	a3,a5,1200 # 104b0 <input2_data>
  4c:	fec42783          	lw	a5,-20(s0)
  50:	00279793          	slli	a5,a5,0x2
  54:	00f687b3          	add	a5,a3,a5
  58:	0007a783          	lw	a5,0(a5)
  5c:	00f707b3          	add	a5,a4,a5
  60:	fef42223          	sw	a5,-28(s0)
  64:	000117b7          	lui	a5,0x11
  68:	96078713          	addi	a4,a5,-1696 # 10960 <verify_data>
  6c:	fec42783          	lw	a5,-20(s0)
  70:	00279793          	slli	a5,a5,0x2
  74:	00f707b3          	add	a5,a4,a5
  78:	0007a783          	lw	a5,0(a5)
  7c:	fe442703          	lw	a4,-28(s0)
  80:	00f70863          	beq	a4,a5,90 <main+0x80>
  84:	fe842783          	lw	a5,-24(s0)
  88:	00178793          	addi	a5,a5,1
  8c:	fef42423          	sw	a5,-24(s0)
  90:	fec42783          	lw	a5,-20(s0)
  94:	00178793          	addi	a5,a5,1
  98:	fef42623          	sw	a5,-20(s0)
  9c:	fec42703          	lw	a4,-20(s0)
  a0:	12b00793          	li	a5,299
  a4:	f8e7d4e3          	bge	a5,a4,2c <main+0x1c>
  a8:	fe842783          	lw	a5,-24(s0)
  ac:	00078513          	mv	a0,a5
  b0:	01c12083          	lw	ra,28(sp)
  b4:	01812403          	lw	s0,24(sp)
  b8:	02010113          	addi	sp,sp,32
  bc:	00008067          	ret
