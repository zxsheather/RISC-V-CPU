
magic.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	081000ef          	jal	884 <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <j+0xff7c>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000107b7          	lui	a5,0x10
  2c:	0587a703          	lw	a4,88(a5) # 10058 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000107b7          	lui	a5,0x10
  3c:	04e7ac23          	sw	a4,88(a5) # 10058 <judgeResult>
  40:	000107b7          	lui	a5,0x10
  44:	0587a783          	lw	a5,88(a5) # 10058 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000107b7          	lui	a5,0x10
  50:	04e7ac23          	sw	a4,88(a5) # 10058 <judgeResult>
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
  98:	0587a783          	lw	a5,88(a5) # 10058 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000107b7          	lui	a5,0x10
  a4:	04e7ac23          	sw	a4,88(a5) # 10058 <judgeResult>
  a8:	000107b7          	lui	a5,0x10
  ac:	0587a783          	lw	a5,88(a5) # 10058 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000107b7          	lui	a5,0x10
  b8:	04e7ac23          	sw	a4,88(a5) # 10058 <judgeResult>
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

000000ec <origin>:
  ec:	fe010113          	addi	sp,sp,-32
  f0:	00112e23          	sw	ra,28(sp)
  f4:	00812c23          	sw	s0,24(sp)
  f8:	02010413          	addi	s0,sp,32
  fc:	fea42623          	sw	a0,-20(s0)
 100:	000107b7          	lui	a5,0x10
 104:	0607a023          	sw	zero,96(a5) # 10060 <i>
 108:	07c0006f          	j	184 <origin+0x98>
 10c:	000107b7          	lui	a5,0x10
 110:	0607a223          	sw	zero,100(a5) # 10064 <j>
 114:	04c0006f          	j	160 <origin+0x74>
 118:	000107b7          	lui	a5,0x10
 11c:	0607a703          	lw	a4,96(a5) # 10060 <i>
 120:	000107b7          	lui	a5,0x10
 124:	0647a603          	lw	a2,100(a5) # 10064 <j>
 128:	000107b7          	lui	a5,0x10
 12c:	00c78693          	addi	a3,a5,12 # 1000c <make>
 130:	00070793          	mv	a5,a4
 134:	00179793          	slli	a5,a5,0x1
 138:	00e787b3          	add	a5,a5,a4
 13c:	00c787b3          	add	a5,a5,a2
 140:	00279793          	slli	a5,a5,0x2
 144:	00f687b3          	add	a5,a3,a5
 148:	0007a023          	sw	zero,0(a5)
 14c:	000107b7          	lui	a5,0x10
 150:	0647a783          	lw	a5,100(a5) # 10064 <j>
 154:	00178713          	addi	a4,a5,1
 158:	000107b7          	lui	a5,0x10
 15c:	06e7a223          	sw	a4,100(a5) # 10064 <j>
 160:	000107b7          	lui	a5,0x10
 164:	0647a783          	lw	a5,100(a5) # 10064 <j>
 168:	fec42703          	lw	a4,-20(s0)
 16c:	fae7c6e3          	blt	a5,a4,118 <origin+0x2c>
 170:	000107b7          	lui	a5,0x10
 174:	0607a783          	lw	a5,96(a5) # 10060 <i>
 178:	00178713          	addi	a4,a5,1
 17c:	000107b7          	lui	a5,0x10
 180:	06e7a023          	sw	a4,96(a5) # 10060 <i>
 184:	000107b7          	lui	a5,0x10
 188:	0607a783          	lw	a5,96(a5) # 10060 <i>
 18c:	fec42703          	lw	a4,-20(s0)
 190:	f6e7cee3          	blt	a5,a4,10c <origin+0x20>
 194:	00000013          	nop
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
 1c0:	fcb42c23          	sw	a1,-40(s0)
 1c4:	fcc42a23          	sw	a2,-44(s0)
 1c8:	fd842783          	lw	a5,-40(s0)
 1cc:	08f04e63          	bgtz	a5,268 <search+0xbc>
 1d0:	fd842783          	lw	a5,-40(s0)
 1d4:	0807ca63          	bltz	a5,268 <search+0xbc>
 1d8:	fdc42783          	lw	a5,-36(s0)
 1dc:	08078663          	beqz	a5,268 <search+0xbc>
 1e0:	fdc42783          	lw	a5,-36(s0)
 1e4:	fff78713          	addi	a4,a5,-1
 1e8:	000107b7          	lui	a5,0x10
 1ec:	00c78693          	addi	a3,a5,12 # 1000c <make>
 1f0:	00070793          	mv	a5,a4
 1f4:	00179793          	slli	a5,a5,0x1
 1f8:	00e787b3          	add	a5,a5,a4
 1fc:	00279793          	slli	a5,a5,0x2
 200:	00f687b3          	add	a5,a3,a5
 204:	0007a683          	lw	a3,0(a5)
 208:	fdc42783          	lw	a5,-36(s0)
 20c:	fff78713          	addi	a4,a5,-1
 210:	000107b7          	lui	a5,0x10
 214:	00c78613          	addi	a2,a5,12 # 1000c <make>
 218:	00070793          	mv	a5,a4
 21c:	00179793          	slli	a5,a5,0x1
 220:	00e787b3          	add	a5,a5,a4
 224:	00279793          	slli	a5,a5,0x2
 228:	00f607b3          	add	a5,a2,a5
 22c:	0047a783          	lw	a5,4(a5)
 230:	00f686b3          	add	a3,a3,a5
 234:	fdc42783          	lw	a5,-36(s0)
 238:	fff78713          	addi	a4,a5,-1
 23c:	000107b7          	lui	a5,0x10
 240:	00c78613          	addi	a2,a5,12 # 1000c <make>
 244:	00070793          	mv	a5,a4
 248:	00179793          	slli	a5,a5,0x1
 24c:	00e787b3          	add	a5,a5,a4
 250:	00279793          	slli	a5,a5,0x2
 254:	00f607b3          	add	a5,a2,a5
 258:	0087a783          	lw	a5,8(a5)
 25c:	00f68733          	add	a4,a3,a5
 260:	00f00793          	li	a5,15
 264:	60f71663          	bne	a4,a5,870 <search+0x6c4>
 268:	fdc42703          	lw	a4,-36(s0)
 26c:	00200793          	li	a5,2
 270:	26f71a63          	bne	a4,a5,4e4 <search+0x338>
 274:	fd842703          	lw	a4,-40(s0)
 278:	00200793          	li	a5,2
 27c:	26f71463          	bne	a4,a5,4e4 <search+0x338>
 280:	02d00713          	li	a4,45
 284:	fd442783          	lw	a5,-44(s0)
 288:	40f70733          	sub	a4,a4,a5
 28c:	000107b7          	lui	a5,0x10
 290:	00c78793          	addi	a5,a5,12 # 1000c <make>
 294:	02e7a023          	sw	a4,32(a5)
 298:	000107b7          	lui	a5,0x10
 29c:	00c78793          	addi	a5,a5,12 # 1000c <make>
 2a0:	0007a703          	lw	a4,0(a5)
 2a4:	000107b7          	lui	a5,0x10
 2a8:	00c78793          	addi	a5,a5,12 # 1000c <make>
 2ac:	0047a783          	lw	a5,4(a5)
 2b0:	00f70733          	add	a4,a4,a5
 2b4:	000107b7          	lui	a5,0x10
 2b8:	00c78793          	addi	a5,a5,12 # 1000c <make>
 2bc:	0087a783          	lw	a5,8(a5)
 2c0:	00f707b3          	add	a5,a4,a5
 2c4:	fef42223          	sw	a5,-28(s0)
 2c8:	000107b7          	lui	a5,0x10
 2cc:	00c78793          	addi	a5,a5,12 # 1000c <make>
 2d0:	00c7a703          	lw	a4,12(a5)
 2d4:	000107b7          	lui	a5,0x10
 2d8:	00c78793          	addi	a5,a5,12 # 1000c <make>
 2dc:	0107a783          	lw	a5,16(a5)
 2e0:	00f70733          	add	a4,a4,a5
 2e4:	000107b7          	lui	a5,0x10
 2e8:	00c78793          	addi	a5,a5,12 # 1000c <make>
 2ec:	0147a783          	lw	a5,20(a5)
 2f0:	00f707b3          	add	a5,a4,a5
 2f4:	fe442703          	lw	a4,-28(s0)
 2f8:	56f71a63          	bne	a4,a5,86c <search+0x6c0>
 2fc:	000107b7          	lui	a5,0x10
 300:	00c78793          	addi	a5,a5,12 # 1000c <make>
 304:	0187a703          	lw	a4,24(a5)
 308:	000107b7          	lui	a5,0x10
 30c:	00c78793          	addi	a5,a5,12 # 1000c <make>
 310:	01c7a783          	lw	a5,28(a5)
 314:	00f70733          	add	a4,a4,a5
 318:	000107b7          	lui	a5,0x10
 31c:	00c78793          	addi	a5,a5,12 # 1000c <make>
 320:	0207a783          	lw	a5,32(a5)
 324:	00f707b3          	add	a5,a4,a5
 328:	fe442703          	lw	a4,-28(s0)
 32c:	54f71063          	bne	a4,a5,86c <search+0x6c0>
 330:	000107b7          	lui	a5,0x10
 334:	00c78793          	addi	a5,a5,12 # 1000c <make>
 338:	0007a703          	lw	a4,0(a5)
 33c:	000107b7          	lui	a5,0x10
 340:	00c78793          	addi	a5,a5,12 # 1000c <make>
 344:	00c7a783          	lw	a5,12(a5)
 348:	00f70733          	add	a4,a4,a5
 34c:	000107b7          	lui	a5,0x10
 350:	00c78793          	addi	a5,a5,12 # 1000c <make>
 354:	0187a783          	lw	a5,24(a5)
 358:	00f707b3          	add	a5,a4,a5
 35c:	fe442703          	lw	a4,-28(s0)
 360:	50f71663          	bne	a4,a5,86c <search+0x6c0>
 364:	000107b7          	lui	a5,0x10
 368:	00c78793          	addi	a5,a5,12 # 1000c <make>
 36c:	0047a703          	lw	a4,4(a5)
 370:	000107b7          	lui	a5,0x10
 374:	00c78793          	addi	a5,a5,12 # 1000c <make>
 378:	0107a783          	lw	a5,16(a5)
 37c:	00f70733          	add	a4,a4,a5
 380:	000107b7          	lui	a5,0x10
 384:	00c78793          	addi	a5,a5,12 # 1000c <make>
 388:	01c7a783          	lw	a5,28(a5)
 38c:	00f707b3          	add	a5,a4,a5
 390:	fe442703          	lw	a4,-28(s0)
 394:	4cf71c63          	bne	a4,a5,86c <search+0x6c0>
 398:	000107b7          	lui	a5,0x10
 39c:	00c78793          	addi	a5,a5,12 # 1000c <make>
 3a0:	0087a703          	lw	a4,8(a5)
 3a4:	000107b7          	lui	a5,0x10
 3a8:	00c78793          	addi	a5,a5,12 # 1000c <make>
 3ac:	0147a783          	lw	a5,20(a5)
 3b0:	00f70733          	add	a4,a4,a5
 3b4:	000107b7          	lui	a5,0x10
 3b8:	00c78793          	addi	a5,a5,12 # 1000c <make>
 3bc:	0207a783          	lw	a5,32(a5)
 3c0:	00f707b3          	add	a5,a4,a5
 3c4:	fe442703          	lw	a4,-28(s0)
 3c8:	4af71263          	bne	a4,a5,86c <search+0x6c0>
 3cc:	000107b7          	lui	a5,0x10
 3d0:	00c78793          	addi	a5,a5,12 # 1000c <make>
 3d4:	0007a703          	lw	a4,0(a5)
 3d8:	000107b7          	lui	a5,0x10
 3dc:	00c78793          	addi	a5,a5,12 # 1000c <make>
 3e0:	0107a783          	lw	a5,16(a5)
 3e4:	00f70733          	add	a4,a4,a5
 3e8:	000107b7          	lui	a5,0x10
 3ec:	00c78793          	addi	a5,a5,12 # 1000c <make>
 3f0:	0207a783          	lw	a5,32(a5)
 3f4:	00f707b3          	add	a5,a4,a5
 3f8:	fe442703          	lw	a4,-28(s0)
 3fc:	46f71863          	bne	a4,a5,86c <search+0x6c0>
 400:	000107b7          	lui	a5,0x10
 404:	00c78793          	addi	a5,a5,12 # 1000c <make>
 408:	0187a703          	lw	a4,24(a5)
 40c:	000107b7          	lui	a5,0x10
 410:	00c78793          	addi	a5,a5,12 # 1000c <make>
 414:	0107a783          	lw	a5,16(a5)
 418:	00f70733          	add	a4,a4,a5
 41c:	000107b7          	lui	a5,0x10
 420:	00c78793          	addi	a5,a5,12 # 1000c <make>
 424:	0087a783          	lw	a5,8(a5)
 428:	00f707b3          	add	a5,a4,a5
 42c:	fe442703          	lw	a4,-28(s0)
 430:	42f71e63          	bne	a4,a5,86c <search+0x6c0>
 434:	000107b7          	lui	a5,0x10
 438:	05c7a783          	lw	a5,92(a5) # 1005c <count>
 43c:	00178713          	addi	a4,a5,1
 440:	000107b7          	lui	a5,0x10
 444:	04e7ae23          	sw	a4,92(a5) # 1005c <count>
 448:	fe042623          	sw	zero,-20(s0)
 44c:	07c0006f          	j	4c8 <search+0x31c>
 450:	fe042423          	sw	zero,-24(s0)
 454:	0500006f          	j	4a4 <search+0x2f8>
 458:	000107b7          	lui	a5,0x10
 45c:	00c78693          	addi	a3,a5,12 # 1000c <make>
 460:	fec42703          	lw	a4,-20(s0)
 464:	00070793          	mv	a5,a4
 468:	00179793          	slli	a5,a5,0x1
 46c:	00e787b3          	add	a5,a5,a4
 470:	fe842703          	lw	a4,-24(s0)
 474:	00e787b3          	add	a5,a5,a4
 478:	00279793          	slli	a5,a5,0x2
 47c:	00f687b3          	add	a5,a3,a5
 480:	0007a783          	lw	a5,0(a5)
 484:	00078513          	mv	a0,a5
 488:	b8dff0ef          	jal	14 <printInt>
 48c:	000107b7          	lui	a5,0x10
 490:	00078513          	mv	a0,a5
 494:	bd5ff0ef          	jal	68 <printStr>
 498:	fe842783          	lw	a5,-24(s0)
 49c:	00178793          	addi	a5,a5,1 # 10001 <__modsi3+0xf691>
 4a0:	fef42423          	sw	a5,-24(s0)
 4a4:	fe842703          	lw	a4,-24(s0)
 4a8:	00200793          	li	a5,2
 4ac:	fae7d6e3          	bge	a5,a4,458 <search+0x2ac>
 4b0:	000107b7          	lui	a5,0x10
 4b4:	00478513          	addi	a0,a5,4 # 10004 <__modsi3+0xf694>
 4b8:	bb1ff0ef          	jal	68 <printStr>
 4bc:	fec42783          	lw	a5,-20(s0)
 4c0:	00178793          	addi	a5,a5,1
 4c4:	fef42623          	sw	a5,-20(s0)
 4c8:	fec42703          	lw	a4,-20(s0)
 4cc:	00200793          	li	a5,2
 4d0:	f8e7d0e3          	bge	a5,a4,450 <search+0x2a4>
 4d4:	000107b7          	lui	a5,0x10
 4d8:	00478513          	addi	a0,a5,4 # 10004 <__modsi3+0xf694>
 4dc:	b8dff0ef          	jal	68 <printStr>
 4e0:	38c0006f          	j	86c <search+0x6c0>
 4e4:	fd842703          	lw	a4,-40(s0)
 4e8:	00200793          	li	a5,2
 4ec:	24f71a63          	bne	a4,a5,740 <search+0x594>
 4f0:	000107b7          	lui	a5,0x10
 4f4:	00c78693          	addi	a3,a5,12 # 1000c <make>
 4f8:	fdc42703          	lw	a4,-36(s0)
 4fc:	00070793          	mv	a5,a4
 500:	00179793          	slli	a5,a5,0x1
 504:	00e787b3          	add	a5,a5,a4
 508:	00279793          	slli	a5,a5,0x2
 50c:	00f687b3          	add	a5,a3,a5
 510:	0007a783          	lw	a5,0(a5)
 514:	00f00713          	li	a4,15
 518:	40f706b3          	sub	a3,a4,a5
 51c:	000107b7          	lui	a5,0x10
 520:	00c78613          	addi	a2,a5,12 # 1000c <make>
 524:	fdc42703          	lw	a4,-36(s0)
 528:	00070793          	mv	a5,a4
 52c:	00179793          	slli	a5,a5,0x1
 530:	00e787b3          	add	a5,a5,a4
 534:	00279793          	slli	a5,a5,0x2
 538:	00f607b3          	add	a5,a2,a5
 53c:	0047a783          	lw	a5,4(a5)
 540:	40f686b3          	sub	a3,a3,a5
 544:	000107b7          	lui	a5,0x10
 548:	00c78613          	addi	a2,a5,12 # 1000c <make>
 54c:	fdc42703          	lw	a4,-36(s0)
 550:	00070793          	mv	a5,a4
 554:	00179793          	slli	a5,a5,0x1
 558:	00e787b3          	add	a5,a5,a4
 55c:	fd842703          	lw	a4,-40(s0)
 560:	00e787b3          	add	a5,a5,a4
 564:	00279793          	slli	a5,a5,0x2
 568:	00f607b3          	add	a5,a2,a5
 56c:	00d7a023          	sw	a3,0(a5)
 570:	000107b7          	lui	a5,0x10
 574:	00c78693          	addi	a3,a5,12 # 1000c <make>
 578:	fdc42703          	lw	a4,-36(s0)
 57c:	00070793          	mv	a5,a4
 580:	00179793          	slli	a5,a5,0x1
 584:	00e787b3          	add	a5,a5,a4
 588:	fd842703          	lw	a4,-40(s0)
 58c:	00e787b3          	add	a5,a5,a4
 590:	00279793          	slli	a5,a5,0x2
 594:	00f687b3          	add	a5,a3,a5
 598:	0007a783          	lw	a5,0(a5)
 59c:	2cf05a63          	blez	a5,870 <search+0x6c4>
 5a0:	000107b7          	lui	a5,0x10
 5a4:	00c78693          	addi	a3,a5,12 # 1000c <make>
 5a8:	fdc42703          	lw	a4,-36(s0)
 5ac:	00070793          	mv	a5,a4
 5b0:	00179793          	slli	a5,a5,0x1
 5b4:	00e787b3          	add	a5,a5,a4
 5b8:	fd842703          	lw	a4,-40(s0)
 5bc:	00e787b3          	add	a5,a5,a4
 5c0:	00279793          	slli	a5,a5,0x2
 5c4:	00f687b3          	add	a5,a3,a5
 5c8:	0007a703          	lw	a4,0(a5)
 5cc:	00900793          	li	a5,9
 5d0:	2ae7c063          	blt	a5,a4,870 <search+0x6c4>
 5d4:	000107b7          	lui	a5,0x10
 5d8:	00c78693          	addi	a3,a5,12 # 1000c <make>
 5dc:	fdc42703          	lw	a4,-36(s0)
 5e0:	00070793          	mv	a5,a4
 5e4:	00179793          	slli	a5,a5,0x1
 5e8:	00e787b3          	add	a5,a5,a4
 5ec:	fd842703          	lw	a4,-40(s0)
 5f0:	00e787b3          	add	a5,a5,a4
 5f4:	00279793          	slli	a5,a5,0x2
 5f8:	00f687b3          	add	a5,a3,a5
 5fc:	0007a783          	lw	a5,0(a5)
 600:	00010737          	lui	a4,0x10
 604:	03070713          	addi	a4,a4,48 # 10030 <color>
 608:	00279793          	slli	a5,a5,0x2
 60c:	00f707b3          	add	a5,a4,a5
 610:	0007a783          	lw	a5,0(a5)
 614:	24079e63          	bnez	a5,870 <search+0x6c4>
 618:	000107b7          	lui	a5,0x10
 61c:	00c78693          	addi	a3,a5,12 # 1000c <make>
 620:	fdc42703          	lw	a4,-36(s0)
 624:	00070793          	mv	a5,a4
 628:	00179793          	slli	a5,a5,0x1
 62c:	00e787b3          	add	a5,a5,a4
 630:	fd842703          	lw	a4,-40(s0)
 634:	00e787b3          	add	a5,a5,a4
 638:	00279793          	slli	a5,a5,0x2
 63c:	00f687b3          	add	a5,a3,a5
 640:	0007a783          	lw	a5,0(a5)
 644:	00010737          	lui	a4,0x10
 648:	03070713          	addi	a4,a4,48 # 10030 <color>
 64c:	00279793          	slli	a5,a5,0x2
 650:	00f707b3          	add	a5,a4,a5
 654:	00100713          	li	a4,1
 658:	00e7a023          	sw	a4,0(a5)
 65c:	fd842703          	lw	a4,-40(s0)
 660:	00200793          	li	a5,2
 664:	04f71863          	bne	a4,a5,6b4 <search+0x508>
 668:	fdc42783          	lw	a5,-36(s0)
 66c:	00178513          	addi	a0,a5,1
 670:	000107b7          	lui	a5,0x10
 674:	00c78693          	addi	a3,a5,12 # 1000c <make>
 678:	fdc42703          	lw	a4,-36(s0)
 67c:	00070793          	mv	a5,a4
 680:	00179793          	slli	a5,a5,0x1
 684:	00e787b3          	add	a5,a5,a4
 688:	fd842703          	lw	a4,-40(s0)
 68c:	00e787b3          	add	a5,a5,a4
 690:	00279793          	slli	a5,a5,0x2
 694:	00f687b3          	add	a5,a3,a5
 698:	0007a703          	lw	a4,0(a5)
 69c:	fd442783          	lw	a5,-44(s0)
 6a0:	00f707b3          	add	a5,a4,a5
 6a4:	00078613          	mv	a2,a5
 6a8:	00000593          	li	a1,0
 6ac:	b01ff0ef          	jal	1ac <search>
 6b0:	04c0006f          	j	6fc <search+0x550>
 6b4:	fd842783          	lw	a5,-40(s0)
 6b8:	00178593          	addi	a1,a5,1
 6bc:	000107b7          	lui	a5,0x10
 6c0:	00c78693          	addi	a3,a5,12 # 1000c <make>
 6c4:	fdc42703          	lw	a4,-36(s0)
 6c8:	00070793          	mv	a5,a4
 6cc:	00179793          	slli	a5,a5,0x1
 6d0:	00e787b3          	add	a5,a5,a4
 6d4:	fd842703          	lw	a4,-40(s0)
 6d8:	00e787b3          	add	a5,a5,a4
 6dc:	00279793          	slli	a5,a5,0x2
 6e0:	00f687b3          	add	a5,a3,a5
 6e4:	0007a703          	lw	a4,0(a5)
 6e8:	fd442783          	lw	a5,-44(s0)
 6ec:	00f707b3          	add	a5,a4,a5
 6f0:	00078613          	mv	a2,a5
 6f4:	fdc42503          	lw	a0,-36(s0)
 6f8:	ab5ff0ef          	jal	1ac <search>
 6fc:	000107b7          	lui	a5,0x10
 700:	00c78693          	addi	a3,a5,12 # 1000c <make>
 704:	fdc42703          	lw	a4,-36(s0)
 708:	00070793          	mv	a5,a4
 70c:	00179793          	slli	a5,a5,0x1
 710:	00e787b3          	add	a5,a5,a4
 714:	fd842703          	lw	a4,-40(s0)
 718:	00e787b3          	add	a5,a5,a4
 71c:	00279793          	slli	a5,a5,0x2
 720:	00f687b3          	add	a5,a3,a5
 724:	0007a783          	lw	a5,0(a5)
 728:	00010737          	lui	a4,0x10
 72c:	03070713          	addi	a4,a4,48 # 10030 <color>
 730:	00279793          	slli	a5,a5,0x2
 734:	00f707b3          	add	a5,a4,a5
 738:	0007a023          	sw	zero,0(a5)
 73c:	1340006f          	j	870 <search+0x6c4>
 740:	00100793          	li	a5,1
 744:	fef42623          	sw	a5,-20(s0)
 748:	1140006f          	j	85c <search+0x6b0>
 74c:	000107b7          	lui	a5,0x10
 750:	03078713          	addi	a4,a5,48 # 10030 <color>
 754:	fec42783          	lw	a5,-20(s0)
 758:	00279793          	slli	a5,a5,0x2
 75c:	00f707b3          	add	a5,a4,a5
 760:	0007a783          	lw	a5,0(a5)
 764:	0e079663          	bnez	a5,850 <search+0x6a4>
 768:	000107b7          	lui	a5,0x10
 76c:	03078713          	addi	a4,a5,48 # 10030 <color>
 770:	fec42783          	lw	a5,-20(s0)
 774:	00279793          	slli	a5,a5,0x2
 778:	00f707b3          	add	a5,a4,a5
 77c:	00100713          	li	a4,1
 780:	00e7a023          	sw	a4,0(a5)
 784:	000107b7          	lui	a5,0x10
 788:	00c78693          	addi	a3,a5,12 # 1000c <make>
 78c:	fdc42703          	lw	a4,-36(s0)
 790:	00070793          	mv	a5,a4
 794:	00179793          	slli	a5,a5,0x1
 798:	00e787b3          	add	a5,a5,a4
 79c:	fd842703          	lw	a4,-40(s0)
 7a0:	00e787b3          	add	a5,a5,a4
 7a4:	00279793          	slli	a5,a5,0x2
 7a8:	00f687b3          	add	a5,a3,a5
 7ac:	fec42703          	lw	a4,-20(s0)
 7b0:	00e7a023          	sw	a4,0(a5)
 7b4:	fd842703          	lw	a4,-40(s0)
 7b8:	00200793          	li	a5,2
 7bc:	02f71663          	bne	a4,a5,7e8 <search+0x63c>
 7c0:	fdc42783          	lw	a5,-36(s0)
 7c4:	00178693          	addi	a3,a5,1
 7c8:	fd442703          	lw	a4,-44(s0)
 7cc:	fec42783          	lw	a5,-20(s0)
 7d0:	00f707b3          	add	a5,a4,a5
 7d4:	00078613          	mv	a2,a5
 7d8:	00000593          	li	a1,0
 7dc:	00068513          	mv	a0,a3
 7e0:	9cdff0ef          	jal	1ac <search>
 7e4:	0280006f          	j	80c <search+0x660>
 7e8:	fd842783          	lw	a5,-40(s0)
 7ec:	00178693          	addi	a3,a5,1
 7f0:	fd442703          	lw	a4,-44(s0)
 7f4:	fec42783          	lw	a5,-20(s0)
 7f8:	00f707b3          	add	a5,a4,a5
 7fc:	00078613          	mv	a2,a5
 800:	00068593          	mv	a1,a3
 804:	fdc42503          	lw	a0,-36(s0)
 808:	9a5ff0ef          	jal	1ac <search>
 80c:	000107b7          	lui	a5,0x10
 810:	00c78693          	addi	a3,a5,12 # 1000c <make>
 814:	fdc42703          	lw	a4,-36(s0)
 818:	00070793          	mv	a5,a4
 81c:	00179793          	slli	a5,a5,0x1
 820:	00e787b3          	add	a5,a5,a4
 824:	fd842703          	lw	a4,-40(s0)
 828:	00e787b3          	add	a5,a5,a4
 82c:	00279793          	slli	a5,a5,0x2
 830:	00f687b3          	add	a5,a3,a5
 834:	0007a023          	sw	zero,0(a5)
 838:	000107b7          	lui	a5,0x10
 83c:	03078713          	addi	a4,a5,48 # 10030 <color>
 840:	fec42783          	lw	a5,-20(s0)
 844:	00279793          	slli	a5,a5,0x2
 848:	00f707b3          	add	a5,a4,a5
 84c:	0007a023          	sw	zero,0(a5)
 850:	fec42783          	lw	a5,-20(s0)
 854:	00178793          	addi	a5,a5,1
 858:	fef42623          	sw	a5,-20(s0)
 85c:	fec42703          	lw	a4,-20(s0)
 860:	00900793          	li	a5,9
 864:	eee7d4e3          	bge	a5,a4,74c <search+0x5a0>
 868:	0080006f          	j	870 <search+0x6c4>
 86c:	00000013          	nop
 870:	00000013          	nop
 874:	02c12083          	lw	ra,44(sp)
 878:	02812403          	lw	s0,40(sp)
 87c:	03010113          	addi	sp,sp,48
 880:	00008067          	ret

00000884 <main>:
 884:	ff010113          	addi	sp,sp,-16
 888:	00112623          	sw	ra,12(sp)
 88c:	00812423          	sw	s0,8(sp)
 890:	01010413          	addi	s0,sp,16
 894:	00300513          	li	a0,3
 898:	855ff0ef          	jal	ec <origin>
 89c:	00000613          	li	a2,0
 8a0:	00000593          	li	a1,0
 8a4:	00000513          	li	a0,0
 8a8:	905ff0ef          	jal	1ac <search>
 8ac:	000107b7          	lui	a5,0x10
 8b0:	05c7a783          	lw	a5,92(a5) # 1005c <count>
 8b4:	00078513          	mv	a0,a5
 8b8:	f5cff0ef          	jal	14 <printInt>
 8bc:	000107b7          	lui	a5,0x10
 8c0:	0587a783          	lw	a5,88(a5) # 10058 <judgeResult>
 8c4:	0fd00713          	li	a4,253
 8c8:	00070593          	mv	a1,a4
 8cc:	00078513          	mv	a0,a5
 8d0:	0a0000ef          	jal	970 <__modsi3>
 8d4:	00050793          	mv	a5,a0
 8d8:	00078513          	mv	a0,a5
 8dc:	00c12083          	lw	ra,12(sp)
 8e0:	00812403          	lw	s0,8(sp)
 8e4:	01010113          	addi	sp,sp,16
 8e8:	00008067          	ret

000008ec <__divsi3>:
 8ec:	06054063          	bltz	a0,94c <__umodsi3+0x10>
 8f0:	0605c663          	bltz	a1,95c <__umodsi3+0x20>

000008f4 <__hidden___udivsi3>:
 8f4:	00058613          	mv	a2,a1
 8f8:	00050593          	mv	a1,a0
 8fc:	fff00513          	li	a0,-1
 900:	02060c63          	beqz	a2,938 <__hidden___udivsi3+0x44>
 904:	00100693          	li	a3,1
 908:	00b67a63          	bgeu	a2,a1,91c <__hidden___udivsi3+0x28>
 90c:	00c05863          	blez	a2,91c <__hidden___udivsi3+0x28>
 910:	00161613          	slli	a2,a2,0x1
 914:	00169693          	slli	a3,a3,0x1
 918:	feb66ae3          	bltu	a2,a1,90c <__hidden___udivsi3+0x18>
 91c:	00000513          	li	a0,0
 920:	00c5e663          	bltu	a1,a2,92c <__hidden___udivsi3+0x38>
 924:	40c585b3          	sub	a1,a1,a2
 928:	00d56533          	or	a0,a0,a3
 92c:	0016d693          	srli	a3,a3,0x1
 930:	00165613          	srli	a2,a2,0x1
 934:	fe0696e3          	bnez	a3,920 <__hidden___udivsi3+0x2c>
 938:	00008067          	ret

0000093c <__umodsi3>:
 93c:	00008293          	mv	t0,ra
 940:	fb5ff0ef          	jal	8f4 <__hidden___udivsi3>
 944:	00058513          	mv	a0,a1
 948:	00028067          	jr	t0
 94c:	40a00533          	neg	a0,a0
 950:	00b04863          	bgtz	a1,960 <__umodsi3+0x24>
 954:	40b005b3          	neg	a1,a1
 958:	f9dff06f          	j	8f4 <__hidden___udivsi3>
 95c:	40b005b3          	neg	a1,a1
 960:	00008293          	mv	t0,ra
 964:	f91ff0ef          	jal	8f4 <__hidden___udivsi3>
 968:	40a00533          	neg	a0,a0
 96c:	00028067          	jr	t0

00000970 <__modsi3>:
 970:	00008293          	mv	t0,ra
 974:	0005ca63          	bltz	a1,988 <__modsi3+0x18>
 978:	00054c63          	bltz	a0,990 <__modsi3+0x20>
 97c:	f79ff0ef          	jal	8f4 <__hidden___udivsi3>
 980:	00058513          	mv	a0,a1
 984:	00028067          	jr	t0
 988:	40b005b3          	neg	a1,a1
 98c:	fe0558e3          	bgez	a0,97c <__modsi3+0xc>
 990:	40a00533          	neg	a0,a0
 994:	f61ff0ef          	jal	8f4 <__hidden___udivsi3>
 998:	40b00533          	neg	a0,a1
 99c:	00028067          	jr	t0
