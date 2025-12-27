
expr.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	0e8000ef          	jal	ec <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <judgeResult+0xffd0>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000107b7          	lui	a5,0x10
  2c:	0107a703          	lw	a4,16(a5) # 10010 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000107b7          	lui	a5,0x10
  3c:	00e7a823          	sw	a4,16(a5) # 10010 <judgeResult>
  40:	000107b7          	lui	a5,0x10
  44:	0107a783          	lw	a5,16(a5) # 10010 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000107b7          	lui	a5,0x10
  50:	00e7a823          	sw	a4,16(a5) # 10010 <judgeResult>
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
  94:	000107b7          	lui	a5,0x10
  98:	0107a783          	lw	a5,16(a5) # 10010 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000107b7          	lui	a5,0x10
  a4:	00e7a823          	sw	a4,16(a5) # 10010 <judgeResult>
  a8:	000107b7          	lui	a5,0x10
  ac:	0107a783          	lw	a5,16(a5) # 10010 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000107b7          	lui	a5,0x10
  b8:	00e7a823          	sw	a4,16(a5) # 10010 <judgeResult>
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

000000ec <main>:
  ec:	ff010113          	addi	sp,sp,-16
  f0:	00112623          	sw	ra,12(sp)
  f4:	00812423          	sw	s0,8(sp)
  f8:	01010413          	addi	s0,sp,16
  fc:	1cc0006f          	j	2c8 <main+0x1dc>
 100:	000107b7          	lui	a5,0x10
 104:	00c7a703          	lw	a4,12(a5) # 1000c <C>
 108:	000107b7          	lui	a5,0x10
 10c:	0047a783          	lw	a5,4(a5) # 10004 <A>
 110:	40f70733          	sub	a4,a4,a5
 114:	000107b7          	lui	a5,0x10
 118:	0047a783          	lw	a5,4(a5) # 10004 <A>
 11c:	40f70733          	sub	a4,a4,a5
 120:	000107b7          	lui	a5,0x10
 124:	00c7a683          	lw	a3,12(a5) # 1000c <C>
 128:	000107b7          	lui	a5,0x10
 12c:	0047a783          	lw	a5,4(a5) # 10004 <A>
 130:	40f686b3          	sub	a3,a3,a5
 134:	000107b7          	lui	a5,0x10
 138:	0047a783          	lw	a5,4(a5) # 10004 <A>
 13c:	40f686b3          	sub	a3,a3,a5
 140:	000107b7          	lui	a5,0x10
 144:	00c7a603          	lw	a2,12(a5) # 1000c <C>
 148:	000107b7          	lui	a5,0x10
 14c:	0047a783          	lw	a5,4(a5) # 10004 <A>
 150:	40f60633          	sub	a2,a2,a5
 154:	000107b7          	lui	a5,0x10
 158:	0087a783          	lw	a5,8(a5) # 10008 <B>
 15c:	00f607b3          	add	a5,a2,a5
 160:	40f686b3          	sub	a3,a3,a5
 164:	000107b7          	lui	a5,0x10
 168:	00c7a603          	lw	a2,12(a5) # 1000c <C>
 16c:	000107b7          	lui	a5,0x10
 170:	0047a783          	lw	a5,4(a5) # 10004 <A>
 174:	40f60633          	sub	a2,a2,a5
 178:	000107b7          	lui	a5,0x10
 17c:	0047a783          	lw	a5,4(a5) # 10004 <A>
 180:	40f607b3          	sub	a5,a2,a5
 184:	00179793          	slli	a5,a5,0x1
 188:	00f687b3          	add	a5,a3,a5
 18c:	40f70733          	sub	a4,a4,a5
 190:	000107b7          	lui	a5,0x10
 194:	00e7a223          	sw	a4,4(a5) # 10004 <A>
 198:	000107b7          	lui	a5,0x10
 19c:	00c7a703          	lw	a4,12(a5) # 1000c <C>
 1a0:	000107b7          	lui	a5,0x10
 1a4:	0047a783          	lw	a5,4(a5) # 10004 <A>
 1a8:	40f70733          	sub	a4,a4,a5
 1ac:	000107b7          	lui	a5,0x10
 1b0:	0047a783          	lw	a5,4(a5) # 10004 <A>
 1b4:	40f70733          	sub	a4,a4,a5
 1b8:	000107b7          	lui	a5,0x10
 1bc:	00c7a683          	lw	a3,12(a5) # 1000c <C>
 1c0:	000107b7          	lui	a5,0x10
 1c4:	0047a783          	lw	a5,4(a5) # 10004 <A>
 1c8:	40f686b3          	sub	a3,a3,a5
 1cc:	000107b7          	lui	a5,0x10
 1d0:	0047a783          	lw	a5,4(a5) # 10004 <A>
 1d4:	40f686b3          	sub	a3,a3,a5
 1d8:	000107b7          	lui	a5,0x10
 1dc:	00c7a603          	lw	a2,12(a5) # 1000c <C>
 1e0:	000107b7          	lui	a5,0x10
 1e4:	0047a783          	lw	a5,4(a5) # 10004 <A>
 1e8:	40f60633          	sub	a2,a2,a5
 1ec:	000107b7          	lui	a5,0x10
 1f0:	0087a783          	lw	a5,8(a5) # 10008 <B>
 1f4:	00f607b3          	add	a5,a2,a5
 1f8:	40f686b3          	sub	a3,a3,a5
 1fc:	000107b7          	lui	a5,0x10
 200:	00c7a603          	lw	a2,12(a5) # 1000c <C>
 204:	000107b7          	lui	a5,0x10
 208:	0047a783          	lw	a5,4(a5) # 10004 <A>
 20c:	40f60633          	sub	a2,a2,a5
 210:	000107b7          	lui	a5,0x10
 214:	0047a783          	lw	a5,4(a5) # 10004 <A>
 218:	40f607b3          	sub	a5,a2,a5
 21c:	00179793          	slli	a5,a5,0x1
 220:	00f687b3          	add	a5,a3,a5
 224:	40f70733          	sub	a4,a4,a5
 228:	000107b7          	lui	a5,0x10
 22c:	00e7a423          	sw	a4,8(a5) # 10008 <B>
 230:	000107b7          	lui	a5,0x10
 234:	00c7a703          	lw	a4,12(a5) # 1000c <C>
 238:	000107b7          	lui	a5,0x10
 23c:	0047a783          	lw	a5,4(a5) # 10004 <A>
 240:	40f70733          	sub	a4,a4,a5
 244:	000107b7          	lui	a5,0x10
 248:	0047a783          	lw	a5,4(a5) # 10004 <A>
 24c:	40f70733          	sub	a4,a4,a5
 250:	000107b7          	lui	a5,0x10
 254:	00c7a683          	lw	a3,12(a5) # 1000c <C>
 258:	000107b7          	lui	a5,0x10
 25c:	0047a783          	lw	a5,4(a5) # 10004 <A>
 260:	40f686b3          	sub	a3,a3,a5
 264:	000107b7          	lui	a5,0x10
 268:	0047a783          	lw	a5,4(a5) # 10004 <A>
 26c:	40f686b3          	sub	a3,a3,a5
 270:	000107b7          	lui	a5,0x10
 274:	00c7a603          	lw	a2,12(a5) # 1000c <C>
 278:	000107b7          	lui	a5,0x10
 27c:	0047a783          	lw	a5,4(a5) # 10004 <A>
 280:	40f60633          	sub	a2,a2,a5
 284:	000107b7          	lui	a5,0x10
 288:	0087a783          	lw	a5,8(a5) # 10008 <B>
 28c:	00f607b3          	add	a5,a2,a5
 290:	40f686b3          	sub	a3,a3,a5
 294:	000107b7          	lui	a5,0x10
 298:	00c7a603          	lw	a2,12(a5) # 1000c <C>
 29c:	000107b7          	lui	a5,0x10
 2a0:	0047a783          	lw	a5,4(a5) # 10004 <A>
 2a4:	40f60633          	sub	a2,a2,a5
 2a8:	000107b7          	lui	a5,0x10
 2ac:	0047a783          	lw	a5,4(a5) # 10004 <A>
 2b0:	40f607b3          	sub	a5,a2,a5
 2b4:	00179793          	slli	a5,a5,0x1
 2b8:	00f687b3          	add	a5,a3,a5
 2bc:	40f70733          	sub	a4,a4,a5
 2c0:	000107b7          	lui	a5,0x10
 2c4:	00e7a623          	sw	a4,12(a5) # 1000c <C>
 2c8:	000107b7          	lui	a5,0x10
 2cc:	00c7a703          	lw	a4,12(a5) # 1000c <C>
 2d0:	200007b7          	lui	a5,0x20000
 2d4:	00f75a63          	bge	a4,a5,2e8 <main+0x1fc>
 2d8:	000107b7          	lui	a5,0x10
 2dc:	00c7a703          	lw	a4,12(a5) # 1000c <C>
 2e0:	e00007b7          	lui	a5,0xe0000
 2e4:	e0e7cee3          	blt	a5,a4,100 <main+0x14>
 2e8:	000107b7          	lui	a5,0x10
 2ec:	0047a783          	lw	a5,4(a5) # 10004 <A>
 2f0:	00078513          	mv	a0,a5
 2f4:	d21ff0ef          	jal	14 <printInt>
 2f8:	000107b7          	lui	a5,0x10
 2fc:	0087a783          	lw	a5,8(a5) # 10008 <B>
 300:	00078513          	mv	a0,a5
 304:	d11ff0ef          	jal	14 <printInt>
 308:	000107b7          	lui	a5,0x10
 30c:	00c7a783          	lw	a5,12(a5) # 1000c <C>
 310:	00078513          	mv	a0,a5
 314:	d01ff0ef          	jal	14 <printInt>
 318:	000107b7          	lui	a5,0x10
 31c:	0107a783          	lw	a5,16(a5) # 10010 <judgeResult>
 320:	0fd00713          	li	a4,253
 324:	00070593          	mv	a1,a4
 328:	00078513          	mv	a0,a5
 32c:	0a0000ef          	jal	3cc <__modsi3>
 330:	00050793          	mv	a5,a0
 334:	00078513          	mv	a0,a5
 338:	00c12083          	lw	ra,12(sp)
 33c:	00812403          	lw	s0,8(sp)
 340:	01010113          	addi	sp,sp,16
 344:	00008067          	ret

00000348 <__divsi3>:
 348:	06054063          	bltz	a0,3a8 <__umodsi3+0x10>
 34c:	0605c663          	bltz	a1,3b8 <__umodsi3+0x20>

00000350 <__hidden___udivsi3>:
 350:	00058613          	mv	a2,a1
 354:	00050593          	mv	a1,a0
 358:	fff00513          	li	a0,-1
 35c:	02060c63          	beqz	a2,394 <__hidden___udivsi3+0x44>
 360:	00100693          	li	a3,1
 364:	00b67a63          	bgeu	a2,a1,378 <__hidden___udivsi3+0x28>
 368:	00c05863          	blez	a2,378 <__hidden___udivsi3+0x28>
 36c:	00161613          	slli	a2,a2,0x1
 370:	00169693          	slli	a3,a3,0x1
 374:	feb66ae3          	bltu	a2,a1,368 <__hidden___udivsi3+0x18>
 378:	00000513          	li	a0,0
 37c:	00c5e663          	bltu	a1,a2,388 <__hidden___udivsi3+0x38>
 380:	40c585b3          	sub	a1,a1,a2
 384:	00d56533          	or	a0,a0,a3
 388:	0016d693          	srli	a3,a3,0x1
 38c:	00165613          	srli	a2,a2,0x1
 390:	fe0696e3          	bnez	a3,37c <__hidden___udivsi3+0x2c>
 394:	00008067          	ret

00000398 <__umodsi3>:
 398:	00008293          	mv	t0,ra
 39c:	fb5ff0ef          	jal	350 <__hidden___udivsi3>
 3a0:	00058513          	mv	a0,a1
 3a4:	00028067          	jr	t0
 3a8:	40a00533          	neg	a0,a0
 3ac:	00b04863          	bgtz	a1,3bc <__umodsi3+0x24>
 3b0:	40b005b3          	neg	a1,a1
 3b4:	f9dff06f          	j	350 <__hidden___udivsi3>
 3b8:	40b005b3          	neg	a1,a1
 3bc:	00008293          	mv	t0,ra
 3c0:	f91ff0ef          	jal	350 <__hidden___udivsi3>
 3c4:	40a00533          	neg	a0,a0
 3c8:	00028067          	jr	t0

000003cc <__modsi3>:
 3cc:	00008293          	mv	t0,ra
 3d0:	0005ca63          	bltz	a1,3e4 <__modsi3+0x18>
 3d4:	00054c63          	bltz	a0,3ec <__modsi3+0x20>
 3d8:	f79ff0ef          	jal	350 <__hidden___udivsi3>
 3dc:	00058513          	mv	a0,a1
 3e0:	00028067          	jr	t0
 3e4:	40b005b3          	neg	a1,a1
 3e8:	fe0558e3          	bgez	a0,3d8 <__modsi3+0xc>
 3ec:	40a00533          	neg	a0,a0
 3f0:	f61ff0ef          	jal	350 <__hidden___udivsi3>
 3f4:	40b00533          	neg	a0,a1
 3f8:	00028067          	jr	t0
