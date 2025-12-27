
statement_test.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	0e8000ef          	jal	ec <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <M+0xff84>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000107b7          	lui	a5,0x10
  2c:	0547a703          	lw	a4,84(a5) # 10054 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000107b7          	lui	a5,0x10
  3c:	04e7aa23          	sw	a4,84(a5) # 10054 <judgeResult>
  40:	000107b7          	lui	a5,0x10
  44:	0547a783          	lw	a5,84(a5) # 10054 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000107b7          	lui	a5,0x10
  50:	04e7aa23          	sw	a4,84(a5) # 10054 <judgeResult>
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
  98:	0547a783          	lw	a5,84(a5) # 10054 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000107b7          	lui	a5,0x10
  a4:	04e7aa23          	sw	a4,84(a5) # 10054 <judgeResult>
  a8:	000107b7          	lui	a5,0x10
  ac:	0547a783          	lw	a5,84(a5) # 10054 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000107b7          	lui	a5,0x10
  b8:	04e7aa23          	sw	a4,84(a5) # 10054 <judgeResult>
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
  ec:	f5010113          	addi	sp,sp,-176
  f0:	0a112623          	sw	ra,172(sp)
  f4:	0a812423          	sw	s0,168(sp)
  f8:	0a912223          	sw	s1,164(sp)
  fc:	0b212023          	sw	s2,160(sp)
 100:	09312e23          	sw	s3,156(sp)
 104:	0b010413          	addi	s0,sp,176
 108:	000107b7          	lui	a5,0x10
 10c:	00a00713          	li	a4,10
 110:	04e7ac23          	sw	a4,88(a5) # 10058 <N>
 114:	fc042e23          	sw	zero,-36(s0)
 118:	0280006f          	j	140 <main+0x54>
 11c:	fdc42783          	lw	a5,-36(s0)
 120:	00178713          	addi	a4,a5,1
 124:	fce42e23          	sw	a4,-36(s0)
 128:	00010737          	lui	a4,0x10
 12c:	00470713          	addi	a4,a4,4 # 10004 <check>
 130:	00279793          	slli	a5,a5,0x2
 134:	00f707b3          	add	a5,a4,a5
 138:	00100713          	li	a4,1
 13c:	00e7a023          	sw	a4,0(a5)
 140:	000107b7          	lui	a5,0x10
 144:	0587a783          	lw	a5,88(a5) # 10058 <N>
 148:	fdc42703          	lw	a4,-36(s0)
 14c:	fce7d8e3          	bge	a5,a4,11c <main+0x30>
 150:	00100793          	li	a5,1
 154:	f8f42c23          	sw	a5,-104(s0)
 158:	00200793          	li	a5,2
 15c:	fcf42e23          	sw	a5,-36(s0)
 160:	000107b7          	lui	a5,0x10
 164:	0587a783          	lw	a5,88(a5) # 10058 <N>
 168:	fdc42703          	lw	a4,-36(s0)
 16c:	24e7c663          	blt	a5,a4,3b8 <main+0x2cc>
 170:	000107b7          	lui	a5,0x10
 174:	00478713          	addi	a4,a5,4 # 10004 <check>
 178:	fdc42783          	lw	a5,-36(s0)
 17c:	00279793          	slli	a5,a5,0x2
 180:	00f707b3          	add	a5,a4,a5
 184:	0007a783          	lw	a5,0(a5)
 188:	04078863          	beqz	a5,1d8 <main+0xec>
 18c:	000107b7          	lui	a5,0x10
 190:	05c7a783          	lw	a5,92(a5) # 1005c <M>
 194:	00178713          	addi	a4,a5,1
 198:	000107b7          	lui	a5,0x10
 19c:	04e7ae23          	sw	a4,92(a5) # 1005c <M>
 1a0:	000107b7          	lui	a5,0x10
 1a4:	05c7a703          	lw	a4,92(a5) # 1005c <M>
 1a8:	f5840793          	addi	a5,s0,-168
 1ac:	00271713          	slli	a4,a4,0x2
 1b0:	00f707b3          	add	a5,a4,a5
 1b4:	fdc42703          	lw	a4,-36(s0)
 1b8:	00e7a023          	sw	a4,0(a5)
 1bc:	fdc42783          	lw	a5,-36(s0)
 1c0:	fff78713          	addi	a4,a5,-1
 1c4:	fdc42683          	lw	a3,-36(s0)
 1c8:	f9440793          	addi	a5,s0,-108
 1cc:	00269693          	slli	a3,a3,0x2
 1d0:	00f687b3          	add	a5,a3,a5
 1d4:	00e7a023          	sw	a4,0(a5)
 1d8:	fdc42783          	lw	a5,-36(s0)
 1dc:	fcf42a23          	sw	a5,-44(s0)
 1e0:	00100793          	li	a5,1
 1e4:	fcf42c23          	sw	a5,-40(s0)
 1e8:	1600006f          	j	348 <main+0x25c>
 1ec:	fd842703          	lw	a4,-40(s0)
 1f0:	f5840793          	addi	a5,s0,-168
 1f4:	00271713          	slli	a4,a4,0x2
 1f8:	00f707b3          	add	a5,a4,a5
 1fc:	0007a783          	lw	a5,0(a5)
 200:	00078593          	mv	a1,a5
 204:	fd442503          	lw	a0,-44(s0)
 208:	1f0000ef          	jal	3f8 <__mulsi3>
 20c:	00050793          	mv	a5,a0
 210:	fcf42823          	sw	a5,-48(s0)
 214:	000107b7          	lui	a5,0x10
 218:	0587a783          	lw	a5,88(a5) # 10058 <N>
 21c:	fd042703          	lw	a4,-48(s0)
 220:	10e7cc63          	blt	a5,a4,338 <main+0x24c>
 224:	000107b7          	lui	a5,0x10
 228:	00478713          	addi	a4,a5,4 # 10004 <check>
 22c:	fd042783          	lw	a5,-48(s0)
 230:	00279793          	slli	a5,a5,0x2
 234:	00f707b3          	add	a5,a4,a5
 238:	0007a023          	sw	zero,0(a5)
 23c:	fd842703          	lw	a4,-40(s0)
 240:	f5840793          	addi	a5,s0,-168
 244:	00271713          	slli	a4,a4,0x2
 248:	00f707b3          	add	a5,a4,a5
 24c:	0007a703          	lw	a4,0(a5)
 250:	fd442783          	lw	a5,-44(s0)
 254:	00070593          	mv	a1,a4
 258:	00078513          	mv	a0,a5
 25c:	244000ef          	jal	4a0 <__modsi3>
 260:	00050793          	mv	a5,a0
 264:	04079c63          	bnez	a5,2bc <main+0x1d0>
 268:	fd442703          	lw	a4,-44(s0)
 26c:	f9440793          	addi	a5,s0,-108
 270:	00271713          	slli	a4,a4,0x2
 274:	00f707b3          	add	a5,a4,a5
 278:	0007a683          	lw	a3,0(a5)
 27c:	fd842703          	lw	a4,-40(s0)
 280:	f5840793          	addi	a5,s0,-168
 284:	00271713          	slli	a4,a4,0x2
 288:	00f707b3          	add	a5,a4,a5
 28c:	0007a783          	lw	a5,0(a5)
 290:	00078593          	mv	a1,a5
 294:	00068513          	mv	a0,a3
 298:	160000ef          	jal	3f8 <__mulsi3>
 29c:	00050793          	mv	a5,a0
 2a0:	00078693          	mv	a3,a5
 2a4:	fd042703          	lw	a4,-48(s0)
 2a8:	f9440793          	addi	a5,s0,-108
 2ac:	00271713          	slli	a4,a4,0x2
 2b0:	00f707b3          	add	a5,a4,a5
 2b4:	00d7a023          	sw	a3,0(a5)
 2b8:	0d40006f          	j	38c <main+0x2a0>
 2bc:	fd442703          	lw	a4,-44(s0)
 2c0:	f9440793          	addi	a5,s0,-108
 2c4:	00271713          	slli	a4,a4,0x2
 2c8:	00f707b3          	add	a5,a4,a5
 2cc:	0007a483          	lw	s1,0(a5)
 2d0:	fd842703          	lw	a4,-40(s0)
 2d4:	f5840793          	addi	a5,s0,-168
 2d8:	00271713          	slli	a4,a4,0x2
 2dc:	00f707b3          	add	a5,a4,a5
 2e0:	0007a783          	lw	a5,0(a5)
 2e4:	fff78913          	addi	s2,a5,-1
 2e8:	fd842703          	lw	a4,-40(s0)
 2ec:	f5840793          	addi	a5,s0,-168
 2f0:	00271713          	slli	a4,a4,0x2
 2f4:	00f707b3          	add	a5,a4,a5
 2f8:	0007a783          	lw	a5,0(a5)
 2fc:	fd442583          	lw	a1,-44(s0)
 300:	00078513          	mv	a0,a5
 304:	0f4000ef          	jal	3f8 <__mulsi3>
 308:	00050793          	mv	a5,a0
 30c:	00078993          	mv	s3,a5
 310:	00090593          	mv	a1,s2
 314:	00048513          	mv	a0,s1
 318:	0e0000ef          	jal	3f8 <__mulsi3>
 31c:	00050793          	mv	a5,a0
 320:	00078693          	mv	a3,a5
 324:	f9440793          	addi	a5,s0,-108
 328:	00299713          	slli	a4,s3,0x2
 32c:	00f707b3          	add	a5,a4,a5
 330:	00d7a023          	sw	a3,0(a5)
 334:	0080006f          	j	33c <main+0x250>
 338:	00000013          	nop
 33c:	fd842783          	lw	a5,-40(s0)
 340:	00178793          	addi	a5,a5,1
 344:	fcf42c23          	sw	a5,-40(s0)
 348:	000107b7          	lui	a5,0x10
 34c:	05c7a783          	lw	a5,92(a5) # 1005c <M>
 350:	fd842703          	lw	a4,-40(s0)
 354:	02e7cc63          	blt	a5,a4,38c <main+0x2a0>
 358:	fd842703          	lw	a4,-40(s0)
 35c:	f5840793          	addi	a5,s0,-168
 360:	00271713          	slli	a4,a4,0x2
 364:	00f707b3          	add	a5,a4,a5
 368:	0007a783          	lw	a5,0(a5)
 36c:	fd442583          	lw	a1,-44(s0)
 370:	00078513          	mv	a0,a5
 374:	084000ef          	jal	3f8 <__mulsi3>
 378:	00050793          	mv	a5,a0
 37c:	00078713          	mv	a4,a5
 380:	000107b7          	lui	a5,0x10
 384:	0587a783          	lw	a5,88(a5) # 10058 <N>
 388:	e6e7d2e3          	bge	a5,a4,1ec <main+0x100>
 38c:	fd442703          	lw	a4,-44(s0)
 390:	f9440793          	addi	a5,s0,-108
 394:	00271713          	slli	a4,a4,0x2
 398:	00f707b3          	add	a5,a4,a5
 39c:	0007a783          	lw	a5,0(a5)
 3a0:	00078513          	mv	a0,a5
 3a4:	c71ff0ef          	jal	14 <printInt>
 3a8:	fdc42783          	lw	a5,-36(s0)
 3ac:	00178793          	addi	a5,a5,1
 3b0:	fcf42e23          	sw	a5,-36(s0)
 3b4:	dadff06f          	j	160 <main+0x74>
 3b8:	00000013          	nop
 3bc:	000107b7          	lui	a5,0x10
 3c0:	0547a783          	lw	a5,84(a5) # 10054 <judgeResult>
 3c4:	0fd00713          	li	a4,253
 3c8:	00070593          	mv	a1,a4
 3cc:	00078513          	mv	a0,a5
 3d0:	0d0000ef          	jal	4a0 <__modsi3>
 3d4:	00050793          	mv	a5,a0
 3d8:	00078513          	mv	a0,a5
 3dc:	0ac12083          	lw	ra,172(sp)
 3e0:	0a812403          	lw	s0,168(sp)
 3e4:	0a412483          	lw	s1,164(sp)
 3e8:	0a012903          	lw	s2,160(sp)
 3ec:	09c12983          	lw	s3,156(sp)
 3f0:	0b010113          	addi	sp,sp,176
 3f4:	00008067          	ret

000003f8 <__mulsi3>:
 3f8:	00050613          	mv	a2,a0
 3fc:	00000513          	li	a0,0
 400:	0015f693          	andi	a3,a1,1
 404:	00068463          	beqz	a3,40c <__mulsi3+0x14>
 408:	00c50533          	add	a0,a0,a2
 40c:	0015d593          	srli	a1,a1,0x1
 410:	00161613          	slli	a2,a2,0x1
 414:	fe0596e3          	bnez	a1,400 <__mulsi3+0x8>
 418:	00008067          	ret

0000041c <__divsi3>:
 41c:	06054063          	bltz	a0,47c <__umodsi3+0x10>
 420:	0605c663          	bltz	a1,48c <__umodsi3+0x20>

00000424 <__hidden___udivsi3>:
 424:	00058613          	mv	a2,a1
 428:	00050593          	mv	a1,a0
 42c:	fff00513          	li	a0,-1
 430:	02060c63          	beqz	a2,468 <__hidden___udivsi3+0x44>
 434:	00100693          	li	a3,1
 438:	00b67a63          	bgeu	a2,a1,44c <__hidden___udivsi3+0x28>
 43c:	00c05863          	blez	a2,44c <__hidden___udivsi3+0x28>
 440:	00161613          	slli	a2,a2,0x1
 444:	00169693          	slli	a3,a3,0x1
 448:	feb66ae3          	bltu	a2,a1,43c <__hidden___udivsi3+0x18>
 44c:	00000513          	li	a0,0
 450:	00c5e663          	bltu	a1,a2,45c <__hidden___udivsi3+0x38>
 454:	40c585b3          	sub	a1,a1,a2
 458:	00d56533          	or	a0,a0,a3
 45c:	0016d693          	srli	a3,a3,0x1
 460:	00165613          	srli	a2,a2,0x1
 464:	fe0696e3          	bnez	a3,450 <__hidden___udivsi3+0x2c>
 468:	00008067          	ret

0000046c <__umodsi3>:
 46c:	00008293          	mv	t0,ra
 470:	fb5ff0ef          	jal	424 <__hidden___udivsi3>
 474:	00058513          	mv	a0,a1
 478:	00028067          	jr	t0
 47c:	40a00533          	neg	a0,a0
 480:	00b04863          	bgtz	a1,490 <__umodsi3+0x24>
 484:	40b005b3          	neg	a1,a1
 488:	f9dff06f          	j	424 <__hidden___udivsi3>
 48c:	40b005b3          	neg	a1,a1
 490:	00008293          	mv	t0,ra
 494:	f91ff0ef          	jal	424 <__hidden___udivsi3>
 498:	40a00533          	neg	a0,a0
 49c:	00028067          	jr	t0

000004a0 <__modsi3>:
 4a0:	00008293          	mv	t0,ra
 4a4:	0005ca63          	bltz	a1,4b8 <__modsi3+0x18>
 4a8:	00054c63          	bltz	a0,4c0 <__modsi3+0x20>
 4ac:	f79ff0ef          	jal	424 <__hidden___udivsi3>
 4b0:	00058513          	mv	a0,a1
 4b4:	00028067          	jr	t0
 4b8:	40b005b3          	neg	a1,a1
 4bc:	fe0558e3          	bgez	a0,4ac <__modsi3+0xc>
 4c0:	40a00533          	neg	a0,a0
 4c4:	f61ff0ef          	jal	424 <__hidden___udivsi3>
 4c8:	40b00533          	neg	a0,a1
 4cc:	00028067          	jr	t0
