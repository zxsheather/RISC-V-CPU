
array_test1.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	1d0000ef          	jal	1d4 <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <__modsi3>:
  14:	fc010113          	addi	sp,sp,-64 # 1ffc0 <judgeResult+0xffac>
  18:	02112e23          	sw	ra,60(sp)
  1c:	02812c23          	sw	s0,56(sp)
  20:	04010413          	addi	s0,sp,64
  24:	fca42623          	sw	a0,-52(s0)
  28:	fcb42423          	sw	a1,-56(s0)
  2c:	fe042623          	sw	zero,-20(s0)
  30:	fcc42783          	lw	a5,-52(s0)
  34:	0007dc63          	bgez	a5,4c <__modsi3+0x38>
  38:	fcc42783          	lw	a5,-52(s0)
  3c:	40f007b3          	neg	a5,a5
  40:	fcf42623          	sw	a5,-52(s0)
  44:	00100793          	li	a5,1
  48:	fef42623          	sw	a5,-20(s0)
  4c:	fc842783          	lw	a5,-56(s0)
  50:	0007d863          	bgez	a5,60 <__modsi3+0x4c>
  54:	fc842783          	lw	a5,-56(s0)
  58:	40f007b3          	neg	a5,a5
  5c:	fcf42423          	sw	a5,-56(s0)
  60:	fcc42783          	lw	a5,-52(s0)
  64:	fef42023          	sw	a5,-32(s0)
  68:	fc842783          	lw	a5,-56(s0)
  6c:	fcf42e23          	sw	a5,-36(s0)
  70:	fe042423          	sw	zero,-24(s0)
  74:	01f00793          	li	a5,31
  78:	fef42223          	sw	a5,-28(s0)
  7c:	04c0006f          	j	c8 <__modsi3+0xb4>
  80:	fe842783          	lw	a5,-24(s0)
  84:	00179713          	slli	a4,a5,0x1
  88:	fe442783          	lw	a5,-28(s0)
  8c:	fe042683          	lw	a3,-32(s0)
  90:	00f6d7b3          	srl	a5,a3,a5
  94:	0017f793          	andi	a5,a5,1
  98:	00f767b3          	or	a5,a4,a5
  9c:	fef42423          	sw	a5,-24(s0)
  a0:	fe842703          	lw	a4,-24(s0)
  a4:	fdc42783          	lw	a5,-36(s0)
  a8:	00f76a63          	bltu	a4,a5,bc <__modsi3+0xa8>
  ac:	fe842703          	lw	a4,-24(s0)
  b0:	fdc42783          	lw	a5,-36(s0)
  b4:	40f707b3          	sub	a5,a4,a5
  b8:	fef42423          	sw	a5,-24(s0)
  bc:	fe442783          	lw	a5,-28(s0)
  c0:	fff78793          	addi	a5,a5,-1
  c4:	fef42223          	sw	a5,-28(s0)
  c8:	fe442783          	lw	a5,-28(s0)
  cc:	fa07dae3          	bgez	a5,80 <__modsi3+0x6c>
  d0:	fec42783          	lw	a5,-20(s0)
  d4:	00078863          	beqz	a5,e4 <__modsi3+0xd0>
  d8:	fe842783          	lw	a5,-24(s0)
  dc:	40f007b3          	neg	a5,a5
  e0:	0080006f          	j	e8 <__modsi3+0xd4>
  e4:	fe842783          	lw	a5,-24(s0)
  e8:	00078513          	mv	a0,a5
  ec:	03c12083          	lw	ra,60(sp)
  f0:	03812403          	lw	s0,56(sp)
  f4:	04010113          	addi	sp,sp,64
  f8:	00008067          	ret

000000fc <printInt>:
  fc:	fe010113          	addi	sp,sp,-32
 100:	00112e23          	sw	ra,28(sp)
 104:	00812c23          	sw	s0,24(sp)
 108:	02010413          	addi	s0,sp,32
 10c:	fea42623          	sw	a0,-20(s0)
 110:	000107b7          	lui	a5,0x10
 114:	0147a703          	lw	a4,20(a5) # 10014 <judgeResult>
 118:	fec42783          	lw	a5,-20(s0)
 11c:	00f74733          	xor	a4,a4,a5
 120:	000107b7          	lui	a5,0x10
 124:	00e7aa23          	sw	a4,20(a5) # 10014 <judgeResult>
 128:	000107b7          	lui	a5,0x10
 12c:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
 130:	0ad78713          	addi	a4,a5,173
 134:	000107b7          	lui	a5,0x10
 138:	00e7aa23          	sw	a4,20(a5) # 10014 <judgeResult>
 13c:	00000013          	nop
 140:	01c12083          	lw	ra,28(sp)
 144:	01812403          	lw	s0,24(sp)
 148:	02010113          	addi	sp,sp,32
 14c:	00008067          	ret

00000150 <printStr>:
 150:	fd010113          	addi	sp,sp,-48
 154:	02112623          	sw	ra,44(sp)
 158:	02812423          	sw	s0,40(sp)
 15c:	03010413          	addi	s0,sp,48
 160:	fca42e23          	sw	a0,-36(s0)
 164:	fdc42783          	lw	a5,-36(s0)
 168:	fef42623          	sw	a5,-20(s0)
 16c:	0440006f          	j	1b0 <printStr+0x60>
 170:	fec42783          	lw	a5,-20(s0)
 174:	0007c783          	lbu	a5,0(a5)
 178:	00078713          	mv	a4,a5
 17c:	000107b7          	lui	a5,0x10
 180:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
 184:	00f74733          	xor	a4,a4,a5
 188:	000107b7          	lui	a5,0x10
 18c:	00e7aa23          	sw	a4,20(a5) # 10014 <judgeResult>
 190:	000107b7          	lui	a5,0x10
 194:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
 198:	20978713          	addi	a4,a5,521
 19c:	000107b7          	lui	a5,0x10
 1a0:	00e7aa23          	sw	a4,20(a5) # 10014 <judgeResult>
 1a4:	fec42783          	lw	a5,-20(s0)
 1a8:	00178793          	addi	a5,a5,1
 1ac:	fef42623          	sw	a5,-20(s0)
 1b0:	fec42783          	lw	a5,-20(s0)
 1b4:	0007c783          	lbu	a5,0(a5)
 1b8:	fa079ce3          	bnez	a5,170 <printStr+0x20>
 1bc:	00000013          	nop
 1c0:	00000013          	nop
 1c4:	02c12083          	lw	ra,44(sp)
 1c8:	02812403          	lw	s0,40(sp)
 1cc:	03010113          	addi	sp,sp,48
 1d0:	00008067          	ret

000001d4 <main>:
 1d4:	fd010113          	addi	sp,sp,-48
 1d8:	02112623          	sw	ra,44(sp)
 1dc:	02812423          	sw	s0,40(sp)
 1e0:	03010413          	addi	s0,sp,48
 1e4:	fe042623          	sw	zero,-20(s0)
 1e8:	0440006f          	j	22c <main+0x58>
 1ec:	000107b7          	lui	a5,0x10
 1f0:	00478713          	addi	a4,a5,4 # 10004 <a>
 1f4:	fec42783          	lw	a5,-20(s0)
 1f8:	00279793          	slli	a5,a5,0x2
 1fc:	00f707b3          	add	a5,a4,a5
 200:	0007a023          	sw	zero,0(a5)
 204:	fec42783          	lw	a5,-20(s0)
 208:	00178713          	addi	a4,a5,1
 20c:	fec42683          	lw	a3,-20(s0)
 210:	fd840793          	addi	a5,s0,-40
 214:	00269693          	slli	a3,a3,0x2
 218:	00f687b3          	add	a5,a3,a5
 21c:	00e7a023          	sw	a4,0(a5)
 220:	fec42783          	lw	a5,-20(s0)
 224:	00178793          	addi	a5,a5,1
 228:	fef42623          	sw	a5,-20(s0)
 22c:	fec42703          	lw	a4,-20(s0)
 230:	00300793          	li	a5,3
 234:	fae7dce3          	bge	a5,a4,1ec <main+0x18>
 238:	fe042623          	sw	zero,-20(s0)
 23c:	0300006f          	j	26c <main+0x98>
 240:	000107b7          	lui	a5,0x10
 244:	00478713          	addi	a4,a5,4 # 10004 <a>
 248:	fec42783          	lw	a5,-20(s0)
 24c:	00279793          	slli	a5,a5,0x2
 250:	00f707b3          	add	a5,a4,a5
 254:	0007a783          	lw	a5,0(a5)
 258:	00078513          	mv	a0,a5
 25c:	ea1ff0ef          	jal	fc <printInt>
 260:	fec42783          	lw	a5,-20(s0)
 264:	00178793          	addi	a5,a5,1
 268:	fef42623          	sw	a5,-20(s0)
 26c:	fec42703          	lw	a4,-20(s0)
 270:	00300793          	li	a5,3
 274:	fce7d6e3          	bge	a5,a4,240 <main+0x6c>
 278:	fd840793          	addi	a5,s0,-40
 27c:	fef42423          	sw	a5,-24(s0)
 280:	fe042623          	sw	zero,-20(s0)
 284:	02c0006f          	j	2b0 <main+0xdc>
 288:	fec42783          	lw	a5,-20(s0)
 28c:	00279793          	slli	a5,a5,0x2
 290:	fe842703          	lw	a4,-24(s0)
 294:	00f707b3          	add	a5,a4,a5
 298:	0007a783          	lw	a5,0(a5)
 29c:	00078513          	mv	a0,a5
 2a0:	e5dff0ef          	jal	fc <printInt>
 2a4:	fec42783          	lw	a5,-20(s0)
 2a8:	00178793          	addi	a5,a5,1
 2ac:	fef42623          	sw	a5,-20(s0)
 2b0:	fec42703          	lw	a4,-20(s0)
 2b4:	00300793          	li	a5,3
 2b8:	fce7d8e3          	bge	a5,a4,288 <main+0xb4>
 2bc:	000107b7          	lui	a5,0x10
 2c0:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
 2c4:	0fd00713          	li	a4,253
 2c8:	00070593          	mv	a1,a4
 2cc:	00078513          	mv	a0,a5
 2d0:	d45ff0ef          	jal	14 <__modsi3>
 2d4:	00050793          	mv	a5,a0
 2d8:	00078513          	mv	a0,a5
 2dc:	02c12083          	lw	ra,44(sp)
 2e0:	02812403          	lw	s0,40(sp)
 2e4:	03010113          	addi	sp,sp,48
 2e8:	00008067          	ret
