
qsort.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	284000ef          	jal	288 <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <judgeResult+0x6200>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	0001a7b7          	lui	a5,0x1a
  2c:	de07a703          	lw	a4,-544(a5) # 19de0 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	0001a7b7          	lui	a5,0x1a
  3c:	dee7a023          	sw	a4,-544(a5) # 19de0 <judgeResult>
  40:	0001a7b7          	lui	a5,0x1a
  44:	de07a783          	lw	a5,-544(a5) # 19de0 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	0001a7b7          	lui	a5,0x1a
  50:	dee7a023          	sw	a4,-544(a5) # 19de0 <judgeResult>
  54:	00000013          	nop
  58:	01c12083          	lw	ra,28(sp)
  5c:	01812403          	lw	s0,24(sp)
  60:	02010113          	addi	sp,sp,32
  64:	00008067          	ret

00000068 <printStr>:
  68:	fd010113          	addi	sp,sp,-48
  6c:	02112623          	sw	ra,44(sp)
  70:	02812423          	sw	s0,40(sp)
  74:	03010413          	addi	s0,sp,48
  78:	fca42e23          	sw	a0,-36(s0)
  7c:	fdc42783          	lw	a5,-36(s0)
  80:	fef42623          	sw	a5,-20(s0)
  84:	0440006f          	j	c8 <printStr+0x60>
  88:	fec42783          	lw	a5,-20(s0)
  8c:	0007c783          	lbu	a5,0(a5)
  90:	00078713          	mv	a4,a5
  94:	0001a7b7          	lui	a5,0x1a
  98:	de07a783          	lw	a5,-544(a5) # 19de0 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	0001a7b7          	lui	a5,0x1a
  a4:	dee7a023          	sw	a4,-544(a5) # 19de0 <judgeResult>
  a8:	0001a7b7          	lui	a5,0x1a
  ac:	de07a783          	lw	a5,-544(a5) # 19de0 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	0001a7b7          	lui	a5,0x1a
  b8:	dee7a023          	sw	a4,-544(a5) # 19de0 <judgeResult>
  bc:	fec42783          	lw	a5,-20(s0)
  c0:	00178793          	addi	a5,a5,1
  c4:	fef42623          	sw	a5,-20(s0)
  c8:	fec42783          	lw	a5,-20(s0)
  cc:	0007c783          	lbu	a5,0(a5)
  d0:	fa079ce3          	bnez	a5,88 <printStr+0x20>
  d4:	00000013          	nop
  d8:	00000013          	nop
  dc:	02c12083          	lw	ra,44(sp)
  e0:	02812403          	lw	s0,40(sp)
  e4:	03010113          	addi	sp,sp,48
  e8:	00008067          	ret

000000ec <qsrt>:
  ec:	fd010113          	addi	sp,sp,-48
  f0:	02112623          	sw	ra,44(sp)
  f4:	02812423          	sw	s0,40(sp)
  f8:	03010413          	addi	s0,sp,48
  fc:	fca42e23          	sw	a0,-36(s0)
 100:	fcb42c23          	sw	a1,-40(s0)
 104:	fdc42783          	lw	a5,-36(s0)
 108:	fef42623          	sw	a5,-20(s0)
 10c:	fd842783          	lw	a5,-40(s0)
 110:	fef42423          	sw	a5,-24(s0)
 114:	fdc42703          	lw	a4,-36(s0)
 118:	fd842783          	lw	a5,-40(s0)
 11c:	00f707b3          	add	a5,a4,a5
 120:	01f7d713          	srli	a4,a5,0x1f
 124:	00f707b3          	add	a5,a4,a5
 128:	4017d793          	srai	a5,a5,0x1
 12c:	00078693          	mv	a3,a5
 130:	000107b7          	lui	a5,0x10
 134:	01078713          	addi	a4,a5,16 # 10010 <a>
 138:	00269793          	slli	a5,a3,0x2
 13c:	00f707b3          	add	a5,a4,a5
 140:	0007a783          	lw	a5,0(a5)
 144:	fef42223          	sw	a5,-28(s0)
 148:	0ec0006f          	j	234 <qsrt+0x148>
 14c:	fec42783          	lw	a5,-20(s0)
 150:	00178793          	addi	a5,a5,1
 154:	fef42623          	sw	a5,-20(s0)
 158:	000107b7          	lui	a5,0x10
 15c:	01078713          	addi	a4,a5,16 # 10010 <a>
 160:	fec42783          	lw	a5,-20(s0)
 164:	00279793          	slli	a5,a5,0x2
 168:	00f707b3          	add	a5,a4,a5
 16c:	0007a783          	lw	a5,0(a5)
 170:	fe442703          	lw	a4,-28(s0)
 174:	fce7cce3          	blt	a5,a4,14c <qsrt+0x60>
 178:	0100006f          	j	188 <qsrt+0x9c>
 17c:	fe842783          	lw	a5,-24(s0)
 180:	fff78793          	addi	a5,a5,-1
 184:	fef42423          	sw	a5,-24(s0)
 188:	000107b7          	lui	a5,0x10
 18c:	01078713          	addi	a4,a5,16 # 10010 <a>
 190:	fe842783          	lw	a5,-24(s0)
 194:	00279793          	slli	a5,a5,0x2
 198:	00f707b3          	add	a5,a4,a5
 19c:	0007a783          	lw	a5,0(a5)
 1a0:	fe442703          	lw	a4,-28(s0)
 1a4:	fcf74ce3          	blt	a4,a5,17c <qsrt+0x90>
 1a8:	fec42703          	lw	a4,-20(s0)
 1ac:	fe842783          	lw	a5,-24(s0)
 1b0:	08e7c263          	blt	a5,a4,234 <qsrt+0x148>
 1b4:	000107b7          	lui	a5,0x10
 1b8:	01078713          	addi	a4,a5,16 # 10010 <a>
 1bc:	fec42783          	lw	a5,-20(s0)
 1c0:	00279793          	slli	a5,a5,0x2
 1c4:	00f707b3          	add	a5,a4,a5
 1c8:	0007a783          	lw	a5,0(a5)
 1cc:	fef42023          	sw	a5,-32(s0)
 1d0:	000107b7          	lui	a5,0x10
 1d4:	01078713          	addi	a4,a5,16 # 10010 <a>
 1d8:	fe842783          	lw	a5,-24(s0)
 1dc:	00279793          	slli	a5,a5,0x2
 1e0:	00f707b3          	add	a5,a4,a5
 1e4:	0007a703          	lw	a4,0(a5)
 1e8:	000107b7          	lui	a5,0x10
 1ec:	01078693          	addi	a3,a5,16 # 10010 <a>
 1f0:	fec42783          	lw	a5,-20(s0)
 1f4:	00279793          	slli	a5,a5,0x2
 1f8:	00f687b3          	add	a5,a3,a5
 1fc:	00e7a023          	sw	a4,0(a5)
 200:	000107b7          	lui	a5,0x10
 204:	01078713          	addi	a4,a5,16 # 10010 <a>
 208:	fe842783          	lw	a5,-24(s0)
 20c:	00279793          	slli	a5,a5,0x2
 210:	00f707b3          	add	a5,a4,a5
 214:	fe042703          	lw	a4,-32(s0)
 218:	00e7a023          	sw	a4,0(a5)
 21c:	fec42783          	lw	a5,-20(s0)
 220:	00178793          	addi	a5,a5,1
 224:	fef42623          	sw	a5,-20(s0)
 228:	fe842783          	lw	a5,-24(s0)
 22c:	fff78793          	addi	a5,a5,-1
 230:	fef42423          	sw	a5,-24(s0)
 234:	fec42703          	lw	a4,-20(s0)
 238:	fe842783          	lw	a5,-24(s0)
 23c:	f0e7dee3          	bge	a5,a4,158 <qsrt+0x6c>
 240:	fdc42703          	lw	a4,-36(s0)
 244:	fe842783          	lw	a5,-24(s0)
 248:	00f75863          	bge	a4,a5,258 <qsrt+0x16c>
 24c:	fe842583          	lw	a1,-24(s0)
 250:	fdc42503          	lw	a0,-36(s0)
 254:	e99ff0ef          	jal	ec <qsrt>
 258:	fec42703          	lw	a4,-20(s0)
 25c:	fd842783          	lw	a5,-40(s0)
 260:	00f75863          	bge	a4,a5,270 <qsrt+0x184>
 264:	fd842583          	lw	a1,-40(s0)
 268:	fec42503          	lw	a0,-20(s0)
 26c:	e81ff0ef          	jal	ec <qsrt>
 270:	00000793          	li	a5,0
 274:	00078513          	mv	a0,a5
 278:	02c12083          	lw	ra,44(sp)
 27c:	02812403          	lw	s0,40(sp)
 280:	03010113          	addi	sp,sp,48
 284:	00008067          	ret

00000288 <main>:
 288:	fe010113          	addi	sp,sp,-32
 28c:	00112e23          	sw	ra,28(sp)
 290:	00812c23          	sw	s0,24(sp)
 294:	02010413          	addi	s0,sp,32
 298:	00100793          	li	a5,1
 29c:	fef42623          	sw	a5,-20(s0)
 2a0:	03c0006f          	j	2dc <main+0x54>
 2a4:	000107b7          	lui	a5,0x10
 2a8:	00c7a783          	lw	a5,12(a5) # 1000c <n>
 2ac:	00178713          	addi	a4,a5,1
 2b0:	fec42783          	lw	a5,-20(s0)
 2b4:	40f70733          	sub	a4,a4,a5
 2b8:	000107b7          	lui	a5,0x10
 2bc:	01078693          	addi	a3,a5,16 # 10010 <a>
 2c0:	fec42783          	lw	a5,-20(s0)
 2c4:	00279793          	slli	a5,a5,0x2
 2c8:	00f687b3          	add	a5,a3,a5
 2cc:	00e7a023          	sw	a4,0(a5)
 2d0:	fec42783          	lw	a5,-20(s0)
 2d4:	00178793          	addi	a5,a5,1
 2d8:	fef42623          	sw	a5,-20(s0)
 2dc:	000107b7          	lui	a5,0x10
 2e0:	00c7a783          	lw	a5,12(a5) # 1000c <n>
 2e4:	fec42703          	lw	a4,-20(s0)
 2e8:	fae7dee3          	bge	a5,a4,2a4 <main+0x1c>
 2ec:	000107b7          	lui	a5,0x10
 2f0:	00c7a783          	lw	a5,12(a5) # 1000c <n>
 2f4:	00078593          	mv	a1,a5
 2f8:	00100513          	li	a0,1
 2fc:	df1ff0ef          	jal	ec <qsrt>
 300:	00100793          	li	a5,1
 304:	fef42623          	sw	a5,-20(s0)
 308:	03c0006f          	j	344 <main+0xbc>
 30c:	000107b7          	lui	a5,0x10
 310:	01078713          	addi	a4,a5,16 # 10010 <a>
 314:	fec42783          	lw	a5,-20(s0)
 318:	00279793          	slli	a5,a5,0x2
 31c:	00f707b3          	add	a5,a4,a5
 320:	0007a783          	lw	a5,0(a5)
 324:	00078513          	mv	a0,a5
 328:	cedff0ef          	jal	14 <printInt>
 32c:	000107b7          	lui	a5,0x10
 330:	00078513          	mv	a0,a5
 334:	d35ff0ef          	jal	68 <printStr>
 338:	fec42783          	lw	a5,-20(s0)
 33c:	00178793          	addi	a5,a5,1 # 10001 <__modsi3+0xfbed>
 340:	fef42623          	sw	a5,-20(s0)
 344:	000107b7          	lui	a5,0x10
 348:	00c7a783          	lw	a5,12(a5) # 1000c <n>
 34c:	fec42703          	lw	a4,-20(s0)
 350:	fae7dee3          	bge	a5,a4,30c <main+0x84>
 354:	000107b7          	lui	a5,0x10
 358:	00478513          	addi	a0,a5,4 # 10004 <__modsi3+0xfbf0>
 35c:	d0dff0ef          	jal	68 <printStr>
 360:	0001a7b7          	lui	a5,0x1a
 364:	de07a783          	lw	a5,-544(a5) # 19de0 <judgeResult>
 368:	0fd00713          	li	a4,253
 36c:	00070593          	mv	a1,a4
 370:	00078513          	mv	a0,a5
 374:	0a0000ef          	jal	414 <__modsi3>
 378:	00050793          	mv	a5,a0
 37c:	00078513          	mv	a0,a5
 380:	01c12083          	lw	ra,28(sp)
 384:	01812403          	lw	s0,24(sp)
 388:	02010113          	addi	sp,sp,32
 38c:	00008067          	ret

00000390 <__divsi3>:
 390:	06054063          	bltz	a0,3f0 <__umodsi3+0x10>
 394:	0605c663          	bltz	a1,400 <__umodsi3+0x20>

00000398 <__hidden___udivsi3>:
 398:	00058613          	mv	a2,a1
 39c:	00050593          	mv	a1,a0
 3a0:	fff00513          	li	a0,-1
 3a4:	02060c63          	beqz	a2,3dc <__hidden___udivsi3+0x44>
 3a8:	00100693          	li	a3,1
 3ac:	00b67a63          	bgeu	a2,a1,3c0 <__hidden___udivsi3+0x28>
 3b0:	00c05863          	blez	a2,3c0 <__hidden___udivsi3+0x28>
 3b4:	00161613          	slli	a2,a2,0x1
 3b8:	00169693          	slli	a3,a3,0x1
 3bc:	feb66ae3          	bltu	a2,a1,3b0 <__hidden___udivsi3+0x18>
 3c0:	00000513          	li	a0,0
 3c4:	00c5e663          	bltu	a1,a2,3d0 <__hidden___udivsi3+0x38>
 3c8:	40c585b3          	sub	a1,a1,a2
 3cc:	00d56533          	or	a0,a0,a3
 3d0:	0016d693          	srli	a3,a3,0x1
 3d4:	00165613          	srli	a2,a2,0x1
 3d8:	fe0696e3          	bnez	a3,3c4 <__hidden___udivsi3+0x2c>
 3dc:	00008067          	ret

000003e0 <__umodsi3>:
 3e0:	00008293          	mv	t0,ra
 3e4:	fb5ff0ef          	jal	398 <__hidden___udivsi3>
 3e8:	00058513          	mv	a0,a1
 3ec:	00028067          	jr	t0
 3f0:	40a00533          	neg	a0,a0
 3f4:	00b04863          	bgtz	a1,404 <__umodsi3+0x24>
 3f8:	40b005b3          	neg	a1,a1
 3fc:	f9dff06f          	j	398 <__hidden___udivsi3>
 400:	40b005b3          	neg	a1,a1
 404:	00008293          	mv	t0,ra
 408:	f91ff0ef          	jal	398 <__hidden___udivsi3>
 40c:	40a00533          	neg	a0,a0
 410:	00028067          	jr	t0

00000414 <__modsi3>:
 414:	00008293          	mv	t0,ra
 418:	0005ca63          	bltz	a1,42c <__modsi3+0x18>
 41c:	00054c63          	bltz	a0,434 <__modsi3+0x20>
 420:	f79ff0ef          	jal	398 <__hidden___udivsi3>
 424:	00058513          	mv	a0,a1
 428:	00028067          	jr	t0
 42c:	40b005b3          	neg	a1,a1
 430:	fe0558e3          	bgez	a0,420 <__modsi3+0xc>
 434:	40a00533          	neg	a0,a0
 438:	f61ff0ef          	jal	398 <__hidden___udivsi3>
 43c:	40b00533          	neg	a0,a1
 440:	00028067          	jr	t0
