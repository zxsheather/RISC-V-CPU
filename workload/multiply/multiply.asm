
multiply.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	094000ef          	jal	98 <main>
   8:	00100073          	ebreak

0000000c <loop>:
   c:	0000006f          	j	c <loop>

00000010 <multiply>:
  10:	fd010113          	addi	sp,sp,-48 # 1ffd0 <verify_data+0xfcb0>
  14:	02112623          	sw	ra,44(sp)
  18:	02812423          	sw	s0,40(sp)
  1c:	03010413          	addi	s0,sp,48
  20:	fca42e23          	sw	a0,-36(s0)
  24:	fcb42c23          	sw	a1,-40(s0)
  28:	fe042423          	sw	zero,-24(s0)
  2c:	fe042623          	sw	zero,-20(s0)
  30:	0440006f          	j	74 <multiply+0x64>
  34:	fdc42783          	lw	a5,-36(s0)
  38:	0017f793          	andi	a5,a5,1
  3c:	00078a63          	beqz	a5,50 <multiply+0x40>
  40:	fe842703          	lw	a4,-24(s0)
  44:	fd842783          	lw	a5,-40(s0)
  48:	00f707b3          	add	a5,a4,a5
  4c:	fef42423          	sw	a5,-24(s0)
  50:	fdc42783          	lw	a5,-36(s0)
  54:	4017d793          	srai	a5,a5,0x1
  58:	fcf42e23          	sw	a5,-36(s0)
  5c:	fd842783          	lw	a5,-40(s0)
  60:	00179793          	slli	a5,a5,0x1
  64:	fcf42c23          	sw	a5,-40(s0)
  68:	fec42783          	lw	a5,-20(s0)
  6c:	00178793          	addi	a5,a5,1
  70:	fef42623          	sw	a5,-20(s0)
  74:	fec42703          	lw	a4,-20(s0)
  78:	01f00793          	li	a5,31
  7c:	fae7dce3          	bge	a5,a4,34 <multiply+0x24>
  80:	fe842783          	lw	a5,-24(s0)
  84:	00078513          	mv	a0,a5
  88:	02c12083          	lw	ra,44(sp)
  8c:	02812403          	lw	s0,40(sp)
  90:	03010113          	addi	sp,sp,48
  94:	00008067          	ret

00000098 <main>:
  98:	fe010113          	addi	sp,sp,-32
  9c:	00112e23          	sw	ra,28(sp)
  a0:	00812c23          	sw	s0,24(sp)
  a4:	02010413          	addi	s0,sp,32
  a8:	fe042423          	sw	zero,-24(s0)
  ac:	fe042623          	sw	zero,-20(s0)
  b0:	07c0006f          	j	12c <main+0x94>
  b4:	000107b7          	lui	a5,0x10
  b8:	00078713          	mv	a4,a5
  bc:	fec42783          	lw	a5,-20(s0)
  c0:	00279793          	slli	a5,a5,0x2
  c4:	00f707b3          	add	a5,a4,a5
  c8:	0007a683          	lw	a3,0(a5) # 10000 <input_data1>
  cc:	000107b7          	lui	a5,0x10
  d0:	19078713          	addi	a4,a5,400 # 10190 <input_data2>
  d4:	fec42783          	lw	a5,-20(s0)
  d8:	00279793          	slli	a5,a5,0x2
  dc:	00f707b3          	add	a5,a4,a5
  e0:	0007a783          	lw	a5,0(a5)
  e4:	00078593          	mv	a1,a5
  e8:	00068513          	mv	a0,a3
  ec:	f25ff0ef          	jal	10 <multiply>
  f0:	fea42223          	sw	a0,-28(s0)
  f4:	000107b7          	lui	a5,0x10
  f8:	32078713          	addi	a4,a5,800 # 10320 <verify_data>
  fc:	fec42783          	lw	a5,-20(s0)
 100:	00279793          	slli	a5,a5,0x2
 104:	00f707b3          	add	a5,a4,a5
 108:	0007a783          	lw	a5,0(a5)
 10c:	fe442703          	lw	a4,-28(s0)
 110:	00f70863          	beq	a4,a5,120 <main+0x88>
 114:	fe842783          	lw	a5,-24(s0)
 118:	00178793          	addi	a5,a5,1
 11c:	fef42423          	sw	a5,-24(s0)
 120:	fec42783          	lw	a5,-20(s0)
 124:	00178793          	addi	a5,a5,1
 128:	fef42623          	sw	a5,-20(s0)
 12c:	fec42703          	lw	a4,-20(s0)
 130:	06300793          	li	a5,99
 134:	f8e7d0e3          	bge	a5,a4,b4 <main+0x1c>
 138:	fe842783          	lw	a5,-24(s0)
 13c:	00078513          	mv	a0,a5
 140:	01c12083          	lw	ra,28(sp)
 144:	01812403          	lw	s0,24(sp)
 148:	02010113          	addi	sp,sp,32
 14c:	00008067          	ret
