
multiarray.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	118000ef          	jal	11c <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <j+0xfefc>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000107b7          	lui	a5,0x10
  2c:	0dc7a703          	lw	a4,220(a5) # 100dc <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000107b7          	lui	a5,0x10
  3c:	0ce7ae23          	sw	a4,220(a5) # 100dc <judgeResult>
  40:	000107b7          	lui	a5,0x10
  44:	0dc7a783          	lw	a5,220(a5) # 100dc <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000107b7          	lui	a5,0x10
  50:	0ce7ae23          	sw	a4,220(a5) # 100dc <judgeResult>
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
  98:	0dc7a783          	lw	a5,220(a5) # 100dc <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000107b7          	lui	a5,0x10
  a4:	0ce7ae23          	sw	a4,220(a5) # 100dc <judgeResult>
  a8:	000107b7          	lui	a5,0x10
  ac:	0dc7a783          	lw	a5,220(a5) # 100dc <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000107b7          	lui	a5,0x10
  b8:	0ce7ae23          	sw	a4,220(a5) # 100dc <judgeResult>
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

000000ec <printNum>:
  ec:	fe010113          	addi	sp,sp,-32
  f0:	00112e23          	sw	ra,28(sp)
  f4:	00812c23          	sw	s0,24(sp)
  f8:	02010413          	addi	s0,sp,32
  fc:	fea42623          	sw	a0,-20(s0)
 100:	fec42503          	lw	a0,-20(s0)
 104:	f11ff0ef          	jal	14 <printInt>
 108:	00000013          	nop
 10c:	01c12083          	lw	ra,28(sp)
 110:	01812403          	lw	s0,24(sp)
 114:	02010113          	addi	sp,sp,32
 118:	00008067          	ret

0000011c <main>:
 11c:	ff010113          	addi	sp,sp,-16
 120:	00112623          	sw	ra,12(sp)
 124:	00812423          	sw	s0,8(sp)
 128:	01010413          	addi	s0,sp,16
 12c:	000107b7          	lui	a5,0x10
 130:	0e07a023          	sw	zero,224(a5) # 100e0 <i>
 134:	0880006f          	j	1bc <main+0xa0>
 138:	000107b7          	lui	a5,0x10
 13c:	0e07a223          	sw	zero,228(a5) # 100e4 <j>
 140:	0580006f          	j	198 <main+0x7c>
 144:	000107b7          	lui	a5,0x10
 148:	0e07a703          	lw	a4,224(a5) # 100e0 <i>
 14c:	000107b7          	lui	a5,0x10
 150:	0e47a603          	lw	a2,228(a5) # 100e4 <j>
 154:	000107b7          	lui	a5,0x10
 158:	00478693          	addi	a3,a5,4 # 10004 <a>
 15c:	00070793          	mv	a5,a4
 160:	00179793          	slli	a5,a5,0x1
 164:	00e787b3          	add	a5,a5,a4
 168:	00279793          	slli	a5,a5,0x2
 16c:	40e787b3          	sub	a5,a5,a4
 170:	00c787b3          	add	a5,a5,a2
 174:	00279793          	slli	a5,a5,0x2
 178:	00f687b3          	add	a5,a3,a5
 17c:	37800713          	li	a4,888
 180:	00e7a023          	sw	a4,0(a5)
 184:	000107b7          	lui	a5,0x10
 188:	0e47a783          	lw	a5,228(a5) # 100e4 <j>
 18c:	00178713          	addi	a4,a5,1
 190:	000107b7          	lui	a5,0x10
 194:	0ee7a223          	sw	a4,228(a5) # 100e4 <j>
 198:	000107b7          	lui	a5,0x10
 19c:	0e47a703          	lw	a4,228(a5) # 100e4 <j>
 1a0:	00900793          	li	a5,9
 1a4:	fae7d0e3          	bge	a5,a4,144 <main+0x28>
 1a8:	000107b7          	lui	a5,0x10
 1ac:	0e07a783          	lw	a5,224(a5) # 100e0 <i>
 1b0:	00178713          	addi	a4,a5,1
 1b4:	000107b7          	lui	a5,0x10
 1b8:	0ee7a023          	sw	a4,224(a5) # 100e0 <i>
 1bc:	000107b7          	lui	a5,0x10
 1c0:	0e07a703          	lw	a4,224(a5) # 100e0 <i>
 1c4:	00300793          	li	a5,3
 1c8:	f6e7d8e3          	bge	a5,a4,138 <main+0x1c>
 1cc:	000107b7          	lui	a5,0x10
 1d0:	0e07a023          	sw	zero,224(a5) # 100e0 <i>
 1d4:	0380006f          	j	20c <main+0xf0>
 1d8:	000107b7          	lui	a5,0x10
 1dc:	0e07a783          	lw	a5,224(a5) # 100e0 <i>
 1e0:	00010737          	lui	a4,0x10
 1e4:	0b470713          	addi	a4,a4,180 # 100b4 <b>
 1e8:	00379793          	slli	a5,a5,0x3
 1ec:	00f707b3          	add	a5,a4,a5
 1f0:	fff00713          	li	a4,-1
 1f4:	00e7a023          	sw	a4,0(a5)
 1f8:	000107b7          	lui	a5,0x10
 1fc:	0e07a783          	lw	a5,224(a5) # 100e0 <i>
 200:	00178713          	addi	a4,a5,1
 204:	000107b7          	lui	a5,0x10
 208:	0ee7a023          	sw	a4,224(a5) # 100e0 <i>
 20c:	000107b7          	lui	a5,0x10
 210:	0e07a703          	lw	a4,224(a5) # 100e0 <i>
 214:	00400793          	li	a5,4
 218:	fce7d0e3          	bge	a5,a4,1d8 <main+0xbc>
 21c:	000107b7          	lui	a5,0x10
 220:	00478793          	addi	a5,a5,4 # 10004 <a>
 224:	0a87a783          	lw	a5,168(a5)
 228:	00078513          	mv	a0,a5
 22c:	ec1ff0ef          	jal	ec <printNum>
 230:	000107b7          	lui	a5,0x10
 234:	0e07a023          	sw	zero,224(a5) # 100e0 <i>
 238:	0ac0006f          	j	2e4 <main+0x1c8>
 23c:	000107b7          	lui	a5,0x10
 240:	0e07a223          	sw	zero,228(a5) # 100e4 <j>
 244:	07c0006f          	j	2c0 <main+0x1a4>
 248:	000107b7          	lui	a5,0x10
 24c:	0e07a703          	lw	a4,224(a5) # 100e0 <i>
 250:	00070793          	mv	a5,a4
 254:	00279793          	slli	a5,a5,0x2
 258:	00e787b3          	add	a5,a5,a4
 25c:	00179793          	slli	a5,a5,0x1
 260:	00078613          	mv	a2,a5
 264:	000107b7          	lui	a5,0x10
 268:	0e47a783          	lw	a5,228(a5) # 100e4 <j>
 26c:	00010737          	lui	a4,0x10
 270:	0e072703          	lw	a4,224(a4) # 100e0 <i>
 274:	000106b7          	lui	a3,0x10
 278:	0e46a583          	lw	a1,228(a3) # 100e4 <j>
 27c:	00f606b3          	add	a3,a2,a5
 280:	000107b7          	lui	a5,0x10
 284:	00478613          	addi	a2,a5,4 # 10004 <a>
 288:	00070793          	mv	a5,a4
 28c:	00179793          	slli	a5,a5,0x1
 290:	00e787b3          	add	a5,a5,a4
 294:	00279793          	slli	a5,a5,0x2
 298:	40e787b3          	sub	a5,a5,a4
 29c:	00b787b3          	add	a5,a5,a1
 2a0:	00279793          	slli	a5,a5,0x2
 2a4:	00f607b3          	add	a5,a2,a5
 2a8:	00d7a023          	sw	a3,0(a5)
 2ac:	000107b7          	lui	a5,0x10
 2b0:	0e47a783          	lw	a5,228(a5) # 100e4 <j>
 2b4:	00178713          	addi	a4,a5,1
 2b8:	000107b7          	lui	a5,0x10
 2bc:	0ee7a223          	sw	a4,228(a5) # 100e4 <j>
 2c0:	000107b7          	lui	a5,0x10
 2c4:	0e47a703          	lw	a4,228(a5) # 100e4 <j>
 2c8:	00900793          	li	a5,9
 2cc:	f6e7dee3          	bge	a5,a4,248 <main+0x12c>
 2d0:	000107b7          	lui	a5,0x10
 2d4:	0e07a783          	lw	a5,224(a5) # 100e0 <i>
 2d8:	00178713          	addi	a4,a5,1
 2dc:	000107b7          	lui	a5,0x10
 2e0:	0ee7a023          	sw	a4,224(a5) # 100e0 <i>
 2e4:	000107b7          	lui	a5,0x10
 2e8:	0e07a703          	lw	a4,224(a5) # 100e0 <i>
 2ec:	00300793          	li	a5,3
 2f0:	f4e7d6e3          	bge	a5,a4,23c <main+0x120>
 2f4:	000107b7          	lui	a5,0x10
 2f8:	0e07a023          	sw	zero,224(a5) # 100e0 <i>
 2fc:	08c0006f          	j	388 <main+0x26c>
 300:	000107b7          	lui	a5,0x10
 304:	0e07a223          	sw	zero,228(a5) # 100e4 <j>
 308:	05c0006f          	j	364 <main+0x248>
 30c:	000107b7          	lui	a5,0x10
 310:	0e07a703          	lw	a4,224(a5) # 100e0 <i>
 314:	000107b7          	lui	a5,0x10
 318:	0e47a603          	lw	a2,228(a5) # 100e4 <j>
 31c:	000107b7          	lui	a5,0x10
 320:	00478693          	addi	a3,a5,4 # 10004 <a>
 324:	00070793          	mv	a5,a4
 328:	00179793          	slli	a5,a5,0x1
 32c:	00e787b3          	add	a5,a5,a4
 330:	00279793          	slli	a5,a5,0x2
 334:	40e787b3          	sub	a5,a5,a4
 338:	00c787b3          	add	a5,a5,a2
 33c:	00279793          	slli	a5,a5,0x2
 340:	00f687b3          	add	a5,a3,a5
 344:	0007a783          	lw	a5,0(a5)
 348:	00078513          	mv	a0,a5
 34c:	da1ff0ef          	jal	ec <printNum>
 350:	000107b7          	lui	a5,0x10
 354:	0e47a783          	lw	a5,228(a5) # 100e4 <j>
 358:	00178713          	addi	a4,a5,1
 35c:	000107b7          	lui	a5,0x10
 360:	0ee7a223          	sw	a4,228(a5) # 100e4 <j>
 364:	000107b7          	lui	a5,0x10
 368:	0e47a703          	lw	a4,228(a5) # 100e4 <j>
 36c:	00900793          	li	a5,9
 370:	f8e7dee3          	bge	a5,a4,30c <main+0x1f0>
 374:	000107b7          	lui	a5,0x10
 378:	0e07a783          	lw	a5,224(a5) # 100e0 <i>
 37c:	00178713          	addi	a4,a5,1
 380:	000107b7          	lui	a5,0x10
 384:	0ee7a023          	sw	a4,224(a5) # 100e0 <i>
 388:	000107b7          	lui	a5,0x10
 38c:	0e07a703          	lw	a4,224(a5) # 100e0 <i>
 390:	00300793          	li	a5,3
 394:	f6e7d6e3          	bge	a5,a4,300 <main+0x1e4>
 398:	000107b7          	lui	a5,0x10
 39c:	00478793          	addi	a5,a5,4 # 10004 <a>
 3a0:	0807a023          	sw	zero,128(a5)
 3a4:	000107b7          	lui	a5,0x10
 3a8:	00478793          	addi	a5,a5,4 # 10004 <a>
 3ac:	0807a783          	lw	a5,128(a5)
 3b0:	00078513          	mv	a0,a5
 3b4:	d39ff0ef          	jal	ec <printNum>
 3b8:	000107b7          	lui	a5,0x10
 3bc:	0b478793          	addi	a5,a5,180 # 100b4 <b>
 3c0:	ffe00713          	li	a4,-2
 3c4:	00e7a023          	sw	a4,0(a5)
 3c8:	000107b7          	lui	a5,0x10
 3cc:	00478793          	addi	a5,a5,4 # 10004 <a>
 3d0:	0807a783          	lw	a5,128(a5)
 3d4:	00010737          	lui	a4,0x10
 3d8:	0b470713          	addi	a4,a4,180 # 100b4 <b>
 3dc:	00379793          	slli	a5,a5,0x3
 3e0:	00f707b3          	add	a5,a4,a5
 3e4:	ff600713          	li	a4,-10
 3e8:	00e7a023          	sw	a4,0(a5)
 3ec:	000107b7          	lui	a5,0x10
 3f0:	0b478793          	addi	a5,a5,180 # 100b4 <b>
 3f4:	0007a783          	lw	a5,0(a5)
 3f8:	00078513          	mv	a0,a5
 3fc:	cf1ff0ef          	jal	ec <printNum>
 400:	000107b7          	lui	a5,0x10
 404:	0b478793          	addi	a5,a5,180 # 100b4 <b>
 408:	0087a783          	lw	a5,8(a5)
 40c:	00078513          	mv	a0,a5
 410:	cddff0ef          	jal	ec <printNum>
 414:	000107b7          	lui	a5,0x10
 418:	0dc7a783          	lw	a5,220(a5) # 100dc <judgeResult>
 41c:	0fd00713          	li	a4,253
 420:	00070593          	mv	a1,a4
 424:	00078513          	mv	a0,a5
 428:	0a0000ef          	jal	4c8 <__modsi3>
 42c:	00050793          	mv	a5,a0
 430:	00078513          	mv	a0,a5
 434:	00c12083          	lw	ra,12(sp)
 438:	00812403          	lw	s0,8(sp)
 43c:	01010113          	addi	sp,sp,16
 440:	00008067          	ret

00000444 <__divsi3>:
 444:	06054063          	bltz	a0,4a4 <__umodsi3+0x10>
 448:	0605c663          	bltz	a1,4b4 <__umodsi3+0x20>

0000044c <__hidden___udivsi3>:
 44c:	00058613          	mv	a2,a1
 450:	00050593          	mv	a1,a0
 454:	fff00513          	li	a0,-1
 458:	02060c63          	beqz	a2,490 <__hidden___udivsi3+0x44>
 45c:	00100693          	li	a3,1
 460:	00b67a63          	bgeu	a2,a1,474 <__hidden___udivsi3+0x28>
 464:	00c05863          	blez	a2,474 <__hidden___udivsi3+0x28>
 468:	00161613          	slli	a2,a2,0x1
 46c:	00169693          	slli	a3,a3,0x1
 470:	feb66ae3          	bltu	a2,a1,464 <__hidden___udivsi3+0x18>
 474:	00000513          	li	a0,0
 478:	00c5e663          	bltu	a1,a2,484 <__hidden___udivsi3+0x38>
 47c:	40c585b3          	sub	a1,a1,a2
 480:	00d56533          	or	a0,a0,a3
 484:	0016d693          	srli	a3,a3,0x1
 488:	00165613          	srli	a2,a2,0x1
 48c:	fe0696e3          	bnez	a3,478 <__hidden___udivsi3+0x2c>
 490:	00008067          	ret

00000494 <__umodsi3>:
 494:	00008293          	mv	t0,ra
 498:	fb5ff0ef          	jal	44c <__hidden___udivsi3>
 49c:	00058513          	mv	a0,a1
 4a0:	00028067          	jr	t0
 4a4:	40a00533          	neg	a0,a0
 4a8:	00b04863          	bgtz	a1,4b8 <__umodsi3+0x24>
 4ac:	40b005b3          	neg	a1,a1
 4b0:	f9dff06f          	j	44c <__hidden___udivsi3>
 4b4:	40b005b3          	neg	a1,a1
 4b8:	00008293          	mv	t0,ra
 4bc:	f91ff0ef          	jal	44c <__hidden___udivsi3>
 4c0:	40a00533          	neg	a0,a0
 4c4:	00028067          	jr	t0

000004c8 <__modsi3>:
 4c8:	00008293          	mv	t0,ra
 4cc:	0005ca63          	bltz	a1,4e0 <__modsi3+0x18>
 4d0:	00054c63          	bltz	a0,4e8 <__modsi3+0x20>
 4d4:	f79ff0ef          	jal	44c <__hidden___udivsi3>
 4d8:	00058513          	mv	a0,a1
 4dc:	00028067          	jr	t0
 4e0:	40b005b3          	neg	a1,a1
 4e4:	fe0558e3          	bgez	a0,4d4 <__modsi3+0xc>
 4e8:	40a00533          	neg	a0,a0
 4ec:	f61ff0ef          	jal	44c <__hidden___udivsi3>
 4f0:	40b00533          	neg	a0,a1
 4f4:	00028067          	jr	t0
