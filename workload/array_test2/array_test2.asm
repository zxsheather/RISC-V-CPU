
array_test2.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	1d0000ef          	jal	1d4 <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <__modsi3>:
  14:	fc010113          	addi	sp,sp,-64 # 1ffc0 <judgeResult+0xffa8>
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
 114:	0187a703          	lw	a4,24(a5) # 10018 <judgeResult>
 118:	fec42783          	lw	a5,-20(s0)
 11c:	00f74733          	xor	a4,a4,a5
 120:	000107b7          	lui	a5,0x10
 124:	00e7ac23          	sw	a4,24(a5) # 10018 <judgeResult>
 128:	000107b7          	lui	a5,0x10
 12c:	0187a783          	lw	a5,24(a5) # 10018 <judgeResult>
 130:	0ad78713          	addi	a4,a5,173
 134:	000107b7          	lui	a5,0x10
 138:	00e7ac23          	sw	a4,24(a5) # 10018 <judgeResult>
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
 180:	0187a783          	lw	a5,24(a5) # 10018 <judgeResult>
 184:	00f74733          	xor	a4,a4,a5
 188:	000107b7          	lui	a5,0x10
 18c:	00e7ac23          	sw	a4,24(a5) # 10018 <judgeResult>
 190:	000107b7          	lui	a5,0x10
 194:	0187a783          	lw	a5,24(a5) # 10018 <judgeResult>
 198:	20978713          	addi	a4,a5,521
 19c:	000107b7          	lui	a5,0x10
 1a0:	00e7ac23          	sw	a4,24(a5) # 10018 <judgeResult>
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
 1e4:	000107b7          	lui	a5,0x10
 1e8:	0047a783          	lw	a5,4(a5) # 10004 <pa>
 1ec:	fcf42e23          	sw	a5,-36(s0)
 1f0:	000107b7          	lui	a5,0x10
 1f4:	0047a783          	lw	a5,4(a5) # 10004 <pa>
 1f8:	fef42023          	sw	a5,-32(s0)
 1fc:	000107b7          	lui	a5,0x10
 200:	0047a783          	lw	a5,4(a5) # 10004 <pa>
 204:	fef42223          	sw	a5,-28(s0)
 208:	000107b7          	lui	a5,0x10
 20c:	0047a783          	lw	a5,4(a5) # 10004 <pa>
 210:	fef42423          	sw	a5,-24(s0)
 214:	00400513          	li	a0,4
 218:	ee5ff0ef          	jal	fc <printInt>
 21c:	fe042623          	sw	zero,-20(s0)
 220:	02c0006f          	j	24c <main+0x78>
 224:	fdc42703          	lw	a4,-36(s0)
 228:	fec42783          	lw	a5,-20(s0)
 22c:	00279793          	slli	a5,a5,0x2
 230:	00f707b3          	add	a5,a4,a5
 234:	fec42703          	lw	a4,-20(s0)
 238:	00170713          	addi	a4,a4,1
 23c:	00e7a023          	sw	a4,0(a5)
 240:	fec42783          	lw	a5,-20(s0)
 244:	00178793          	addi	a5,a5,1
 248:	fef42623          	sw	a5,-20(s0)
 24c:	fec42703          	lw	a4,-20(s0)
 250:	00300793          	li	a5,3
 254:	fce7d8e3          	bge	a5,a4,224 <main+0x50>
 258:	fe042623          	sw	zero,-20(s0)
 25c:	02c0006f          	j	288 <main+0xb4>
 260:	fe042703          	lw	a4,-32(s0)
 264:	fec42783          	lw	a5,-20(s0)
 268:	00279793          	slli	a5,a5,0x2
 26c:	00f707b3          	add	a5,a4,a5
 270:	0007a783          	lw	a5,0(a5)
 274:	00078513          	mv	a0,a5
 278:	e85ff0ef          	jal	fc <printInt>
 27c:	fec42783          	lw	a5,-20(s0)
 280:	00178793          	addi	a5,a5,1
 284:	fef42623          	sw	a5,-20(s0)
 288:	fec42703          	lw	a4,-20(s0)
 28c:	00300793          	li	a5,3
 290:	fce7d8e3          	bge	a5,a4,260 <main+0x8c>
 294:	fe042623          	sw	zero,-20(s0)
 298:	0240006f          	j	2bc <main+0xe8>
 29c:	fe442703          	lw	a4,-28(s0)
 2a0:	fec42783          	lw	a5,-20(s0)
 2a4:	00279793          	slli	a5,a5,0x2
 2a8:	00f707b3          	add	a5,a4,a5
 2ac:	0007a023          	sw	zero,0(a5)
 2b0:	fec42783          	lw	a5,-20(s0)
 2b4:	00178793          	addi	a5,a5,1
 2b8:	fef42623          	sw	a5,-20(s0)
 2bc:	fec42703          	lw	a4,-20(s0)
 2c0:	00300793          	li	a5,3
 2c4:	fce7dce3          	bge	a5,a4,29c <main+0xc8>
 2c8:	fe042623          	sw	zero,-20(s0)
 2cc:	02c0006f          	j	2f8 <main+0x124>
 2d0:	fe842703          	lw	a4,-24(s0)
 2d4:	fec42783          	lw	a5,-20(s0)
 2d8:	00279793          	slli	a5,a5,0x2
 2dc:	00f707b3          	add	a5,a4,a5
 2e0:	0007a783          	lw	a5,0(a5)
 2e4:	00078513          	mv	a0,a5
 2e8:	e15ff0ef          	jal	fc <printInt>
 2ec:	fec42783          	lw	a5,-20(s0)
 2f0:	00178793          	addi	a5,a5,1
 2f4:	fef42623          	sw	a5,-20(s0)
 2f8:	fec42703          	lw	a4,-20(s0)
 2fc:	00300793          	li	a5,3
 300:	fce7d8e3          	bge	a5,a4,2d0 <main+0xfc>
 304:	000107b7          	lui	a5,0x10
 308:	0187a783          	lw	a5,24(a5) # 10018 <judgeResult>
 30c:	0fd00713          	li	a4,253
 310:	00070593          	mv	a1,a4
 314:	00078513          	mv	a0,a5
 318:	cfdff0ef          	jal	14 <__modsi3>
 31c:	00050793          	mv	a5,a0
 320:	00078513          	mv	a0,a5
 324:	02c12083          	lw	ra,44(sp)
 328:	02812403          	lw	s0,40(sp)
 32c:	03010113          	addi	sp,sp,48
 330:	00008067          	ret
