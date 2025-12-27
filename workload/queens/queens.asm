
queens.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	3e4000ef          	jal	3e8 <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <judgeResult+0xff0c>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000107b7          	lui	a5,0x10
  2c:	0d47a703          	lw	a4,212(a5) # 100d4 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000107b7          	lui	a5,0x10
  3c:	0ce7aa23          	sw	a4,212(a5) # 100d4 <judgeResult>
  40:	000107b7          	lui	a5,0x10
  44:	0d47a783          	lw	a5,212(a5) # 100d4 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000107b7          	lui	a5,0x10
  50:	0ce7aa23          	sw	a4,212(a5) # 100d4 <judgeResult>
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
  98:	0d47a783          	lw	a5,212(a5) # 100d4 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000107b7          	lui	a5,0x10
  a4:	0ce7aa23          	sw	a4,212(a5) # 100d4 <judgeResult>
  a8:	000107b7          	lui	a5,0x10
  ac:	0d47a783          	lw	a5,212(a5) # 100d4 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000107b7          	lui	a5,0x10
  b8:	0ce7aa23          	sw	a4,212(a5) # 100d4 <judgeResult>
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

000000ec <printBoard>:
  ec:	fe010113          	addi	sp,sp,-32
  f0:	00112e23          	sw	ra,28(sp)
  f4:	00812c23          	sw	s0,24(sp)
  f8:	02010413          	addi	s0,sp,32
  fc:	fe042623          	sw	zero,-20(s0)
 100:	07c0006f          	j	17c <printBoard+0x90>
 104:	fe042423          	sw	zero,-24(s0)
 108:	04c0006f          	j	154 <printBoard+0x68>
 10c:	000107b7          	lui	a5,0x10
 110:	03478713          	addi	a4,a5,52 # 10034 <col>
 114:	fec42783          	lw	a5,-20(s0)
 118:	00279793          	slli	a5,a5,0x2
 11c:	00f707b3          	add	a5,a4,a5
 120:	0007a783          	lw	a5,0(a5)
 124:	fe842703          	lw	a4,-24(s0)
 128:	00f71a63          	bne	a4,a5,13c <printBoard+0x50>
 12c:	000107b7          	lui	a5,0x10
 130:	00078513          	mv	a0,a5
 134:	f35ff0ef          	jal	68 <printStr>
 138:	0100006f          	j	148 <printBoard+0x5c>
 13c:	000107b7          	lui	a5,0x10
 140:	00478513          	addi	a0,a5,4 # 10004 <__modsi3+0xfb50>
 144:	f25ff0ef          	jal	68 <printStr>
 148:	fe842783          	lw	a5,-24(s0)
 14c:	00178793          	addi	a5,a5,1
 150:	fef42423          	sw	a5,-24(s0)
 154:	000107b7          	lui	a5,0x10
 158:	0107a783          	lw	a5,16(a5) # 10010 <N>
 15c:	fe842703          	lw	a4,-24(s0)
 160:	faf746e3          	blt	a4,a5,10c <printBoard+0x20>
 164:	000107b7          	lui	a5,0x10
 168:	00878513          	addi	a0,a5,8 # 10008 <__modsi3+0xfb54>
 16c:	efdff0ef          	jal	68 <printStr>
 170:	fec42783          	lw	a5,-20(s0)
 174:	00178793          	addi	a5,a5,1
 178:	fef42623          	sw	a5,-20(s0)
 17c:	000107b7          	lui	a5,0x10
 180:	0107a783          	lw	a5,16(a5) # 10010 <N>
 184:	fec42703          	lw	a4,-20(s0)
 188:	f6f74ee3          	blt	a4,a5,104 <printBoard+0x18>
 18c:	000107b7          	lui	a5,0x10
 190:	00878513          	addi	a0,a5,8 # 10008 <__modsi3+0xfb54>
 194:	ed5ff0ef          	jal	68 <printStr>
 198:	00000013          	nop
 19c:	01c12083          	lw	ra,28(sp)
 1a0:	01812403          	lw	s0,24(sp)
 1a4:	02010113          	addi	sp,sp,32
 1a8:	00008067          	ret

000001ac <search>:
 1ac:	fd010113          	addi	sp,sp,-48
 1b0:	02112623          	sw	ra,44(sp)
 1b4:	02812423          	sw	s0,40(sp)
 1b8:	03010413          	addi	s0,sp,48
 1bc:	fca42e23          	sw	a0,-36(s0)
 1c0:	000107b7          	lui	a5,0x10
 1c4:	0107a783          	lw	a5,16(a5) # 10010 <N>
 1c8:	fdc42703          	lw	a4,-36(s0)
 1cc:	00f71663          	bne	a4,a5,1d8 <search+0x2c>
 1d0:	f1dff0ef          	jal	ec <printBoard>
 1d4:	2000006f          	j	3d4 <search+0x228>
 1d8:	fe042623          	sw	zero,-20(s0)
 1dc:	1e80006f          	j	3c4 <search+0x218>
 1e0:	000107b7          	lui	a5,0x10
 1e4:	01478713          	addi	a4,a5,20 # 10014 <row>
 1e8:	fec42783          	lw	a5,-20(s0)
 1ec:	00279793          	slli	a5,a5,0x2
 1f0:	00f707b3          	add	a5,a4,a5
 1f4:	0007a783          	lw	a5,0(a5)
 1f8:	1c079063          	bnez	a5,3b8 <search+0x20c>
 1fc:	fec42703          	lw	a4,-20(s0)
 200:	fdc42783          	lw	a5,-36(s0)
 204:	00f707b3          	add	a5,a4,a5
 208:	00010737          	lui	a4,0x10
 20c:	05470713          	addi	a4,a4,84 # 10054 <d>
 210:	00279793          	slli	a5,a5,0x2
 214:	00f707b3          	add	a5,a4,a5
 218:	0007a783          	lw	a5,0(a5)
 21c:	18079e63          	bnez	a5,3b8 <search+0x20c>
 220:	000107b7          	lui	a5,0x10
 224:	0107a703          	lw	a4,16(a5) # 10010 <N>
 228:	fec42783          	lw	a5,-20(s0)
 22c:	00f707b3          	add	a5,a4,a5
 230:	fff78713          	addi	a4,a5,-1
 234:	fdc42783          	lw	a5,-36(s0)
 238:	40f707b3          	sub	a5,a4,a5
 23c:	00010737          	lui	a4,0x10
 240:	05470713          	addi	a4,a4,84 # 10054 <d>
 244:	01078793          	addi	a5,a5,16
 248:	00279793          	slli	a5,a5,0x2
 24c:	00f707b3          	add	a5,a4,a5
 250:	0007a783          	lw	a5,0(a5)
 254:	16079263          	bnez	a5,3b8 <search+0x20c>
 258:	000107b7          	lui	a5,0x10
 25c:	0107a703          	lw	a4,16(a5) # 10010 <N>
 260:	fec42783          	lw	a5,-20(s0)
 264:	00f707b3          	add	a5,a4,a5
 268:	fff78713          	addi	a4,a5,-1
 26c:	fdc42783          	lw	a5,-36(s0)
 270:	40f70733          	sub	a4,a4,a5
 274:	000107b7          	lui	a5,0x10
 278:	05478693          	addi	a3,a5,84 # 10054 <d>
 27c:	01070793          	addi	a5,a4,16
 280:	00279793          	slli	a5,a5,0x2
 284:	00f687b3          	add	a5,a3,a5
 288:	00100693          	li	a3,1
 28c:	00d7a023          	sw	a3,0(a5)
 290:	fec42683          	lw	a3,-20(s0)
 294:	fdc42783          	lw	a5,-36(s0)
 298:	00f687b3          	add	a5,a3,a5
 29c:	000106b7          	lui	a3,0x10
 2a0:	05468693          	addi	a3,a3,84 # 10054 <d>
 2a4:	01070713          	addi	a4,a4,16
 2a8:	00271713          	slli	a4,a4,0x2
 2ac:	00e68733          	add	a4,a3,a4
 2b0:	00072683          	lw	a3,0(a4)
 2b4:	00010737          	lui	a4,0x10
 2b8:	05470613          	addi	a2,a4,84 # 10054 <d>
 2bc:	00279713          	slli	a4,a5,0x2
 2c0:	00e60733          	add	a4,a2,a4
 2c4:	00d72023          	sw	a3,0(a4)
 2c8:	00010737          	lui	a4,0x10
 2cc:	05470713          	addi	a4,a4,84 # 10054 <d>
 2d0:	00279793          	slli	a5,a5,0x2
 2d4:	00f707b3          	add	a5,a4,a5
 2d8:	0007a703          	lw	a4,0(a5)
 2dc:	000107b7          	lui	a5,0x10
 2e0:	01478693          	addi	a3,a5,20 # 10014 <row>
 2e4:	fec42783          	lw	a5,-20(s0)
 2e8:	00279793          	slli	a5,a5,0x2
 2ec:	00f687b3          	add	a5,a3,a5
 2f0:	00e7a023          	sw	a4,0(a5)
 2f4:	000107b7          	lui	a5,0x10
 2f8:	03478713          	addi	a4,a5,52 # 10034 <col>
 2fc:	fdc42783          	lw	a5,-36(s0)
 300:	00279793          	slli	a5,a5,0x2
 304:	00f707b3          	add	a5,a4,a5
 308:	fec42703          	lw	a4,-20(s0)
 30c:	00e7a023          	sw	a4,0(a5)
 310:	fdc42783          	lw	a5,-36(s0)
 314:	00178793          	addi	a5,a5,1
 318:	00078513          	mv	a0,a5
 31c:	e91ff0ef          	jal	1ac <search>
 320:	000107b7          	lui	a5,0x10
 324:	0107a703          	lw	a4,16(a5) # 10010 <N>
 328:	fec42783          	lw	a5,-20(s0)
 32c:	00f707b3          	add	a5,a4,a5
 330:	fff78713          	addi	a4,a5,-1
 334:	fdc42783          	lw	a5,-36(s0)
 338:	40f70733          	sub	a4,a4,a5
 33c:	000107b7          	lui	a5,0x10
 340:	05478693          	addi	a3,a5,84 # 10054 <d>
 344:	01070793          	addi	a5,a4,16
 348:	00279793          	slli	a5,a5,0x2
 34c:	00f687b3          	add	a5,a3,a5
 350:	0007a023          	sw	zero,0(a5)
 354:	fec42683          	lw	a3,-20(s0)
 358:	fdc42783          	lw	a5,-36(s0)
 35c:	00f687b3          	add	a5,a3,a5
 360:	000106b7          	lui	a3,0x10
 364:	05468693          	addi	a3,a3,84 # 10054 <d>
 368:	01070713          	addi	a4,a4,16
 36c:	00271713          	slli	a4,a4,0x2
 370:	00e68733          	add	a4,a3,a4
 374:	00072683          	lw	a3,0(a4)
 378:	00010737          	lui	a4,0x10
 37c:	05470613          	addi	a2,a4,84 # 10054 <d>
 380:	00279713          	slli	a4,a5,0x2
 384:	00e60733          	add	a4,a2,a4
 388:	00d72023          	sw	a3,0(a4)
 38c:	00010737          	lui	a4,0x10
 390:	05470713          	addi	a4,a4,84 # 10054 <d>
 394:	00279793          	slli	a5,a5,0x2
 398:	00f707b3          	add	a5,a4,a5
 39c:	0007a703          	lw	a4,0(a5)
 3a0:	000107b7          	lui	a5,0x10
 3a4:	01478693          	addi	a3,a5,20 # 10014 <row>
 3a8:	fec42783          	lw	a5,-20(s0)
 3ac:	00279793          	slli	a5,a5,0x2
 3b0:	00f687b3          	add	a5,a3,a5
 3b4:	00e7a023          	sw	a4,0(a5)
 3b8:	fec42783          	lw	a5,-20(s0)
 3bc:	00178793          	addi	a5,a5,1
 3c0:	fef42623          	sw	a5,-20(s0)
 3c4:	000107b7          	lui	a5,0x10
 3c8:	0107a783          	lw	a5,16(a5) # 10010 <N>
 3cc:	fec42703          	lw	a4,-20(s0)
 3d0:	e0f748e3          	blt	a4,a5,1e0 <search+0x34>
 3d4:	00000013          	nop
 3d8:	02c12083          	lw	ra,44(sp)
 3dc:	02812403          	lw	s0,40(sp)
 3e0:	03010113          	addi	sp,sp,48
 3e4:	00008067          	ret

000003e8 <main>:
 3e8:	ff010113          	addi	sp,sp,-16
 3ec:	00112623          	sw	ra,12(sp)
 3f0:	00812423          	sw	s0,8(sp)
 3f4:	01010413          	addi	s0,sp,16
 3f8:	00000513          	li	a0,0
 3fc:	db1ff0ef          	jal	1ac <search>
 400:	000107b7          	lui	a5,0x10
 404:	0d47a783          	lw	a5,212(a5) # 100d4 <judgeResult>
 408:	0fd00713          	li	a4,253
 40c:	00070593          	mv	a1,a4
 410:	00078513          	mv	a0,a5
 414:	0a0000ef          	jal	4b4 <__modsi3>
 418:	00050793          	mv	a5,a0
 41c:	00078513          	mv	a0,a5
 420:	00c12083          	lw	ra,12(sp)
 424:	00812403          	lw	s0,8(sp)
 428:	01010113          	addi	sp,sp,16
 42c:	00008067          	ret

00000430 <__divsi3>:
 430:	06054063          	bltz	a0,490 <__umodsi3+0x10>
 434:	0605c663          	bltz	a1,4a0 <__umodsi3+0x20>

00000438 <__hidden___udivsi3>:
 438:	00058613          	mv	a2,a1
 43c:	00050593          	mv	a1,a0
 440:	fff00513          	li	a0,-1
 444:	02060c63          	beqz	a2,47c <__hidden___udivsi3+0x44>
 448:	00100693          	li	a3,1
 44c:	00b67a63          	bgeu	a2,a1,460 <__hidden___udivsi3+0x28>
 450:	00c05863          	blez	a2,460 <__hidden___udivsi3+0x28>
 454:	00161613          	slli	a2,a2,0x1
 458:	00169693          	slli	a3,a3,0x1
 45c:	feb66ae3          	bltu	a2,a1,450 <__hidden___udivsi3+0x18>
 460:	00000513          	li	a0,0
 464:	00c5e663          	bltu	a1,a2,470 <__hidden___udivsi3+0x38>
 468:	40c585b3          	sub	a1,a1,a2
 46c:	00d56533          	or	a0,a0,a3
 470:	0016d693          	srli	a3,a3,0x1
 474:	00165613          	srli	a2,a2,0x1
 478:	fe0696e3          	bnez	a3,464 <__hidden___udivsi3+0x2c>
 47c:	00008067          	ret

00000480 <__umodsi3>:
 480:	00008293          	mv	t0,ra
 484:	fb5ff0ef          	jal	438 <__hidden___udivsi3>
 488:	00058513          	mv	a0,a1
 48c:	00028067          	jr	t0
 490:	40a00533          	neg	a0,a0
 494:	00b04863          	bgtz	a1,4a4 <__umodsi3+0x24>
 498:	40b005b3          	neg	a1,a1
 49c:	f9dff06f          	j	438 <__hidden___udivsi3>
 4a0:	40b005b3          	neg	a1,a1
 4a4:	00008293          	mv	t0,ra
 4a8:	f91ff0ef          	jal	438 <__hidden___udivsi3>
 4ac:	40a00533          	neg	a0,a0
 4b0:	00028067          	jr	t0

000004b4 <__modsi3>:
 4b4:	00008293          	mv	t0,ra
 4b8:	0005ca63          	bltz	a1,4cc <__modsi3+0x18>
 4bc:	00054c63          	bltz	a0,4d4 <__modsi3+0x20>
 4c0:	f79ff0ef          	jal	438 <__hidden___udivsi3>
 4c4:	00058513          	mv	a0,a1
 4c8:	00028067          	jr	t0
 4cc:	40b005b3          	neg	a1,a1
 4d0:	fe0558e3          	bgez	a0,4c0 <__modsi3+0xc>
 4d4:	40a00533          	neg	a0,a0
 4d8:	f61ff0ef          	jal	438 <__hidden___udivsi3>
 4dc:	40b00533          	neg	a0,a1
 4e0:	00028067          	jr	t0
