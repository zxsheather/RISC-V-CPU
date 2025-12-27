
basicopt1.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	0e8000ef          	jal	ec <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <judgeResult+0xffdc>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000107b7          	lui	a5,0x10
  2c:	0047a703          	lw	a4,4(a5) # 10004 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000107b7          	lui	a5,0x10
  3c:	00e7a223          	sw	a4,4(a5) # 10004 <judgeResult>
  40:	000107b7          	lui	a5,0x10
  44:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000107b7          	lui	a5,0x10
  50:	00e7a223          	sw	a4,4(a5) # 10004 <judgeResult>
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
  98:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000107b7          	lui	a5,0x10
  a4:	00e7a223          	sw	a4,4(a5) # 10004 <judgeResult>
  a8:	000107b7          	lui	a5,0x10
  ac:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000107b7          	lui	a5,0x10
  b8:	00e7a223          	sw	a4,4(a5) # 10004 <judgeResult>
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
  ec:	81010113          	addi	sp,sp,-2032
  f0:	7e112623          	sw	ra,2028(sp)
  f4:	7e812423          	sw	s0,2024(sp)
  f8:	7f010413          	addi	s0,sp,2032
  fc:	ffff72b7          	lui	t0,0xffff7
 100:	b8028293          	addi	t0,t0,-1152 # ffff6b80 <judgeResult+0xfffe6b7c>
 104:	00510133          	add	sp,sp,t0
 108:	fe042223          	sw	zero,-28(s0)
 10c:	fe042623          	sw	zero,-20(s0)
 110:	06c0006f          	j	17c <main+0x90>
 114:	fe042423          	sw	zero,-24(s0)
 118:	04c0006f          	j	164 <main+0x78>
 11c:	ffff67b7          	lui	a5,0xffff6
 120:	ff078793          	addi	a5,a5,-16 # ffff5ff0 <judgeResult+0xfffe5fec>
 124:	008786b3          	add	a3,a5,s0
 128:	fec42703          	lw	a4,-20(s0)
 12c:	00070793          	mv	a5,a4
 130:	00179793          	slli	a5,a5,0x1
 134:	00e787b3          	add	a5,a5,a4
 138:	00379793          	slli	a5,a5,0x3
 13c:	00e787b3          	add	a5,a5,a4
 140:	00279793          	slli	a5,a5,0x2
 144:	fe842703          	lw	a4,-24(s0)
 148:	00e787b3          	add	a5,a5,a4
 14c:	00279793          	slli	a5,a5,0x2
 150:	00f687b3          	add	a5,a3,a5
 154:	3a07a623          	sw	zero,940(a5)
 158:	fe842783          	lw	a5,-24(s0)
 15c:	00178793          	addi	a5,a5,1
 160:	fef42423          	sw	a5,-24(s0)
 164:	fe842703          	lw	a4,-24(s0)
 168:	06300793          	li	a5,99
 16c:	fae7d8e3          	bge	a5,a4,11c <main+0x30>
 170:	fec42783          	lw	a5,-20(s0)
 174:	00178793          	addi	a5,a5,1
 178:	fef42623          	sw	a5,-20(s0)
 17c:	fec42703          	lw	a4,-20(s0)
 180:	06300793          	li	a5,99
 184:	f8e7d8e3          	bge	a5,a4,114 <main+0x28>
 188:	fe042623          	sw	zero,-20(s0)
 18c:	0e00006f          	j	26c <main+0x180>
 190:	fec42703          	lw	a4,-20(s0)
 194:	01400793          	li	a5,20
 198:	0ce7d463          	bge	a5,a4,260 <main+0x174>
 19c:	fec42703          	lw	a4,-20(s0)
 1a0:	04f00793          	li	a5,79
 1a4:	0ae7ce63          	blt	a5,a4,260 <main+0x174>
 1a8:	fe042423          	sw	zero,-24(s0)
 1ac:	0a80006f          	j	254 <main+0x168>
 1b0:	fe842703          	lw	a4,-24(s0)
 1b4:	00500793          	li	a5,5
 1b8:	00e7c863          	blt	a5,a4,1c8 <main+0xdc>
 1bc:	fec42703          	lw	a4,-20(s0)
 1c0:	05900793          	li	a5,89
 1c4:	08e7c263          	blt	a5,a4,248 <main+0x15c>
 1c8:	fe842783          	lw	a5,-24(s0)
 1cc:	01900593          	li	a1,25
 1d0:	00078513          	mv	a0,a5
 1d4:	170000ef          	jal	344 <__divsi3>
 1d8:	00050793          	mv	a5,a0
 1dc:	fef42023          	sw	a5,-32(s0)
 1e0:	fe842783          	lw	a5,-24(s0)
 1e4:	00279793          	slli	a5,a5,0x2
 1e8:	06400593          	li	a1,100
 1ec:	00078513          	mv	a0,a5
 1f0:	1d8000ef          	jal	3c8 <__modsi3>
 1f4:	00050793          	mv	a5,a0
 1f8:	fcf42e23          	sw	a5,-36(s0)
 1fc:	fec42703          	lw	a4,-20(s0)
 200:	fe042783          	lw	a5,-32(s0)
 204:	00f70733          	add	a4,a4,a5
 208:	fe842783          	lw	a5,-24(s0)
 20c:	03278693          	addi	a3,a5,50
 210:	ffff67b7          	lui	a5,0xffff6
 214:	ff078793          	addi	a5,a5,-16 # ffff5ff0 <judgeResult+0xfffe5fec>
 218:	00878633          	add	a2,a5,s0
 21c:	00070793          	mv	a5,a4
 220:	00179793          	slli	a5,a5,0x1
 224:	00e787b3          	add	a5,a5,a4
 228:	00379793          	slli	a5,a5,0x3
 22c:	00e787b3          	add	a5,a5,a4
 230:	00279793          	slli	a5,a5,0x2
 234:	fdc42703          	lw	a4,-36(s0)
 238:	00e787b3          	add	a5,a5,a4
 23c:	00279793          	slli	a5,a5,0x2
 240:	00f607b3          	add	a5,a2,a5
 244:	3ad7a623          	sw	a3,940(a5)
 248:	fe842783          	lw	a5,-24(s0)
 24c:	00178793          	addi	a5,a5,1
 250:	fef42423          	sw	a5,-24(s0)
 254:	fe842703          	lw	a4,-24(s0)
 258:	06300793          	li	a5,99
 25c:	f4e7dae3          	bge	a5,a4,1b0 <main+0xc4>
 260:	fec42783          	lw	a5,-20(s0)
 264:	00178793          	addi	a5,a5,1
 268:	fef42623          	sw	a5,-20(s0)
 26c:	fec42703          	lw	a4,-20(s0)
 270:	06300793          	li	a5,99
 274:	f0e7dee3          	bge	a5,a4,190 <main+0xa4>
 278:	fe042623          	sw	zero,-20(s0)
 27c:	0780006f          	j	2f4 <main+0x208>
 280:	fe042423          	sw	zero,-24(s0)
 284:	0580006f          	j	2dc <main+0x1f0>
 288:	ffff67b7          	lui	a5,0xffff6
 28c:	ff078793          	addi	a5,a5,-16 # ffff5ff0 <judgeResult+0xfffe5fec>
 290:	008786b3          	add	a3,a5,s0
 294:	fec42703          	lw	a4,-20(s0)
 298:	00070793          	mv	a5,a4
 29c:	00179793          	slli	a5,a5,0x1
 2a0:	00e787b3          	add	a5,a5,a4
 2a4:	00379793          	slli	a5,a5,0x3
 2a8:	00e787b3          	add	a5,a5,a4
 2ac:	00279793          	slli	a5,a5,0x2
 2b0:	fe842703          	lw	a4,-24(s0)
 2b4:	00e787b3          	add	a5,a5,a4
 2b8:	00279793          	slli	a5,a5,0x2
 2bc:	00f687b3          	add	a5,a3,a5
 2c0:	3ac7a783          	lw	a5,940(a5)
 2c4:	fe442703          	lw	a4,-28(s0)
 2c8:	00f707b3          	add	a5,a4,a5
 2cc:	fef42223          	sw	a5,-28(s0)
 2d0:	fe842783          	lw	a5,-24(s0)
 2d4:	00178793          	addi	a5,a5,1
 2d8:	fef42423          	sw	a5,-24(s0)
 2dc:	fe842703          	lw	a4,-24(s0)
 2e0:	06300793          	li	a5,99
 2e4:	fae7d2e3          	bge	a5,a4,288 <main+0x19c>
 2e8:	fec42783          	lw	a5,-20(s0)
 2ec:	00178793          	addi	a5,a5,1
 2f0:	fef42623          	sw	a5,-20(s0)
 2f4:	fec42703          	lw	a4,-20(s0)
 2f8:	06300793          	li	a5,99
 2fc:	f8e7d2e3          	bge	a5,a4,280 <main+0x194>
 300:	fe442503          	lw	a0,-28(s0)
 304:	d11ff0ef          	jal	14 <printInt>
 308:	000107b7          	lui	a5,0x10
 30c:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
 310:	0fd00713          	li	a4,253
 314:	00070593          	mv	a1,a4
 318:	00078513          	mv	a0,a5
 31c:	0ac000ef          	jal	3c8 <__modsi3>
 320:	00050793          	mv	a5,a0
 324:	00078513          	mv	a0,a5
 328:	000092b7          	lui	t0,0x9
 32c:	48028293          	addi	t0,t0,1152 # 9480 <__modsi3+0x90b8>
 330:	00510133          	add	sp,sp,t0
 334:	7ec12083          	lw	ra,2028(sp)
 338:	7e812403          	lw	s0,2024(sp)
 33c:	7f010113          	addi	sp,sp,2032
 340:	00008067          	ret

00000344 <__divsi3>:
 344:	06054063          	bltz	a0,3a4 <__umodsi3+0x10>
 348:	0605c663          	bltz	a1,3b4 <__umodsi3+0x20>

0000034c <__hidden___udivsi3>:
 34c:	00058613          	mv	a2,a1
 350:	00050593          	mv	a1,a0
 354:	fff00513          	li	a0,-1
 358:	02060c63          	beqz	a2,390 <__hidden___udivsi3+0x44>
 35c:	00100693          	li	a3,1
 360:	00b67a63          	bgeu	a2,a1,374 <__hidden___udivsi3+0x28>
 364:	00c05863          	blez	a2,374 <__hidden___udivsi3+0x28>
 368:	00161613          	slli	a2,a2,0x1
 36c:	00169693          	slli	a3,a3,0x1
 370:	feb66ae3          	bltu	a2,a1,364 <__hidden___udivsi3+0x18>
 374:	00000513          	li	a0,0
 378:	00c5e663          	bltu	a1,a2,384 <__hidden___udivsi3+0x38>
 37c:	40c585b3          	sub	a1,a1,a2
 380:	00d56533          	or	a0,a0,a3
 384:	0016d693          	srli	a3,a3,0x1
 388:	00165613          	srli	a2,a2,0x1
 38c:	fe0696e3          	bnez	a3,378 <__hidden___udivsi3+0x2c>
 390:	00008067          	ret

00000394 <__umodsi3>:
 394:	00008293          	mv	t0,ra
 398:	fb5ff0ef          	jal	34c <__hidden___udivsi3>
 39c:	00058513          	mv	a0,a1
 3a0:	00028067          	jr	t0
 3a4:	40a00533          	neg	a0,a0
 3a8:	00b04863          	bgtz	a1,3b8 <__umodsi3+0x24>
 3ac:	40b005b3          	neg	a1,a1
 3b0:	f9dff06f          	j	34c <__hidden___udivsi3>
 3b4:	40b005b3          	neg	a1,a1
 3b8:	00008293          	mv	t0,ra
 3bc:	f91ff0ef          	jal	34c <__hidden___udivsi3>
 3c0:	40a00533          	neg	a0,a0
 3c4:	00028067          	jr	t0

000003c8 <__modsi3>:
 3c8:	00008293          	mv	t0,ra
 3cc:	0005ca63          	bltz	a1,3e0 <__modsi3+0x18>
 3d0:	00054c63          	bltz	a0,3e8 <__modsi3+0x20>
 3d4:	f79ff0ef          	jal	34c <__hidden___udivsi3>
 3d8:	00058513          	mv	a0,a1
 3dc:	00028067          	jr	t0
 3e0:	40b005b3          	neg	a1,a1
 3e4:	fe0558e3          	bgez	a0,3d4 <__modsi3+0xc>
 3e8:	40a00533          	neg	a0,a0
 3ec:	f61ff0ef          	jal	34c <__hidden___udivsi3>
 3f0:	40b00533          	neg	a0,a1
 3f4:	00028067          	jr	t0
