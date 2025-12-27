
superloop.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	0e8000ef          	jal	ec <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <total+0xffc4>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000107b7          	lui	a5,0x10
  2c:	0147a703          	lw	a4,20(a5) # 10014 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000107b7          	lui	a5,0x10
  3c:	00e7aa23          	sw	a4,20(a5) # 10014 <judgeResult>
  40:	000107b7          	lui	a5,0x10
  44:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000107b7          	lui	a5,0x10
  50:	00e7aa23          	sw	a4,20(a5) # 10014 <judgeResult>
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
  98:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000107b7          	lui	a5,0x10
  a4:	00e7aa23          	sw	a4,20(a5) # 10014 <judgeResult>
  a8:	000107b7          	lui	a5,0x10
  ac:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000107b7          	lui	a5,0x10
  b8:	00e7aa23          	sw	a4,20(a5) # 10014 <judgeResult>
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
  ec:	fd010113          	addi	sp,sp,-48
  f0:	02112623          	sw	ra,44(sp)
  f4:	02812423          	sw	s0,40(sp)
  f8:	03010413          	addi	s0,sp,48
  fc:	000107b7          	lui	a5,0x10
 100:	00600713          	li	a4,6
 104:	00e7ac23          	sw	a4,24(a5) # 10018 <N>
 108:	00100793          	li	a5,1
 10c:	fef42623          	sw	a5,-20(s0)
 110:	3480006f          	j	458 <main+0x36c>
 114:	00100793          	li	a5,1
 118:	fef42423          	sw	a5,-24(s0)
 11c:	3200006f          	j	43c <main+0x350>
 120:	00100793          	li	a5,1
 124:	fef42223          	sw	a5,-28(s0)
 128:	2f80006f          	j	420 <main+0x334>
 12c:	00100793          	li	a5,1
 130:	fef42023          	sw	a5,-32(s0)
 134:	2d00006f          	j	404 <main+0x318>
 138:	00100793          	li	a5,1
 13c:	fcf42e23          	sw	a5,-36(s0)
 140:	2a80006f          	j	3e8 <main+0x2fc>
 144:	00100793          	li	a5,1
 148:	fcf42c23          	sw	a5,-40(s0)
 14c:	2800006f          	j	3cc <main+0x2e0>
 150:	fec42703          	lw	a4,-20(s0)
 154:	fe842783          	lw	a5,-24(s0)
 158:	26f70463          	beq	a4,a5,3c0 <main+0x2d4>
 15c:	fec42703          	lw	a4,-20(s0)
 160:	fe442783          	lw	a5,-28(s0)
 164:	24f70e63          	beq	a4,a5,3c0 <main+0x2d4>
 168:	fec42703          	lw	a4,-20(s0)
 16c:	fe042783          	lw	a5,-32(s0)
 170:	24f70863          	beq	a4,a5,3c0 <main+0x2d4>
 174:	fec42703          	lw	a4,-20(s0)
 178:	fdc42783          	lw	a5,-36(s0)
 17c:	24f70263          	beq	a4,a5,3c0 <main+0x2d4>
 180:	fec42703          	lw	a4,-20(s0)
 184:	fd842783          	lw	a5,-40(s0)
 188:	22f70c63          	beq	a4,a5,3c0 <main+0x2d4>
 18c:	000107b7          	lui	a5,0x10
 190:	0047a783          	lw	a5,4(a5) # 10004 <h>
 194:	fec42703          	lw	a4,-20(s0)
 198:	22f70463          	beq	a4,a5,3c0 <main+0x2d4>
 19c:	000107b7          	lui	a5,0x10
 1a0:	0087a783          	lw	a5,8(a5) # 10008 <i>
 1a4:	fec42703          	lw	a4,-20(s0)
 1a8:	20f70c63          	beq	a4,a5,3c0 <main+0x2d4>
 1ac:	000107b7          	lui	a5,0x10
 1b0:	00c7a783          	lw	a5,12(a5) # 1000c <j>
 1b4:	fec42703          	lw	a4,-20(s0)
 1b8:	20f70463          	beq	a4,a5,3c0 <main+0x2d4>
 1bc:	000107b7          	lui	a5,0x10
 1c0:	0107a783          	lw	a5,16(a5) # 10010 <k>
 1c4:	fec42703          	lw	a4,-20(s0)
 1c8:	1ef70c63          	beq	a4,a5,3c0 <main+0x2d4>
 1cc:	fe842703          	lw	a4,-24(s0)
 1d0:	fe442783          	lw	a5,-28(s0)
 1d4:	1ef70663          	beq	a4,a5,3c0 <main+0x2d4>
 1d8:	fe842703          	lw	a4,-24(s0)
 1dc:	fe042783          	lw	a5,-32(s0)
 1e0:	1ef70063          	beq	a4,a5,3c0 <main+0x2d4>
 1e4:	fe842703          	lw	a4,-24(s0)
 1e8:	fdc42783          	lw	a5,-36(s0)
 1ec:	1cf70a63          	beq	a4,a5,3c0 <main+0x2d4>
 1f0:	fe842703          	lw	a4,-24(s0)
 1f4:	fd842783          	lw	a5,-40(s0)
 1f8:	1cf70463          	beq	a4,a5,3c0 <main+0x2d4>
 1fc:	000107b7          	lui	a5,0x10
 200:	0047a783          	lw	a5,4(a5) # 10004 <h>
 204:	fe842703          	lw	a4,-24(s0)
 208:	1af70c63          	beq	a4,a5,3c0 <main+0x2d4>
 20c:	000107b7          	lui	a5,0x10
 210:	0087a783          	lw	a5,8(a5) # 10008 <i>
 214:	fe842703          	lw	a4,-24(s0)
 218:	1af70463          	beq	a4,a5,3c0 <main+0x2d4>
 21c:	000107b7          	lui	a5,0x10
 220:	00c7a783          	lw	a5,12(a5) # 1000c <j>
 224:	fe842703          	lw	a4,-24(s0)
 228:	18f70c63          	beq	a4,a5,3c0 <main+0x2d4>
 22c:	000107b7          	lui	a5,0x10
 230:	0107a783          	lw	a5,16(a5) # 10010 <k>
 234:	fe842703          	lw	a4,-24(s0)
 238:	18f70463          	beq	a4,a5,3c0 <main+0x2d4>
 23c:	fe442703          	lw	a4,-28(s0)
 240:	fe042783          	lw	a5,-32(s0)
 244:	16f70e63          	beq	a4,a5,3c0 <main+0x2d4>
 248:	fe442703          	lw	a4,-28(s0)
 24c:	fdc42783          	lw	a5,-36(s0)
 250:	16f70863          	beq	a4,a5,3c0 <main+0x2d4>
 254:	fe442703          	lw	a4,-28(s0)
 258:	fd842783          	lw	a5,-40(s0)
 25c:	16f70263          	beq	a4,a5,3c0 <main+0x2d4>
 260:	000107b7          	lui	a5,0x10
 264:	0047a783          	lw	a5,4(a5) # 10004 <h>
 268:	fe442703          	lw	a4,-28(s0)
 26c:	14f70a63          	beq	a4,a5,3c0 <main+0x2d4>
 270:	000107b7          	lui	a5,0x10
 274:	0087a783          	lw	a5,8(a5) # 10008 <i>
 278:	fe442703          	lw	a4,-28(s0)
 27c:	14f70263          	beq	a4,a5,3c0 <main+0x2d4>
 280:	000107b7          	lui	a5,0x10
 284:	00c7a783          	lw	a5,12(a5) # 1000c <j>
 288:	fe442703          	lw	a4,-28(s0)
 28c:	12f70a63          	beq	a4,a5,3c0 <main+0x2d4>
 290:	000107b7          	lui	a5,0x10
 294:	0107a783          	lw	a5,16(a5) # 10010 <k>
 298:	fe442703          	lw	a4,-28(s0)
 29c:	12f70263          	beq	a4,a5,3c0 <main+0x2d4>
 2a0:	fe042703          	lw	a4,-32(s0)
 2a4:	fdc42783          	lw	a5,-36(s0)
 2a8:	10f70c63          	beq	a4,a5,3c0 <main+0x2d4>
 2ac:	fe042703          	lw	a4,-32(s0)
 2b0:	fd842783          	lw	a5,-40(s0)
 2b4:	10f70663          	beq	a4,a5,3c0 <main+0x2d4>
 2b8:	000107b7          	lui	a5,0x10
 2bc:	0047a783          	lw	a5,4(a5) # 10004 <h>
 2c0:	fe042703          	lw	a4,-32(s0)
 2c4:	0ef70e63          	beq	a4,a5,3c0 <main+0x2d4>
 2c8:	000107b7          	lui	a5,0x10
 2cc:	0087a783          	lw	a5,8(a5) # 10008 <i>
 2d0:	fe042703          	lw	a4,-32(s0)
 2d4:	0ef70663          	beq	a4,a5,3c0 <main+0x2d4>
 2d8:	000107b7          	lui	a5,0x10
 2dc:	00c7a783          	lw	a5,12(a5) # 1000c <j>
 2e0:	fe042703          	lw	a4,-32(s0)
 2e4:	0cf70e63          	beq	a4,a5,3c0 <main+0x2d4>
 2e8:	000107b7          	lui	a5,0x10
 2ec:	0107a783          	lw	a5,16(a5) # 10010 <k>
 2f0:	fe042703          	lw	a4,-32(s0)
 2f4:	0cf70663          	beq	a4,a5,3c0 <main+0x2d4>
 2f8:	fdc42703          	lw	a4,-36(s0)
 2fc:	fd842783          	lw	a5,-40(s0)
 300:	0cf70063          	beq	a4,a5,3c0 <main+0x2d4>
 304:	000107b7          	lui	a5,0x10
 308:	0047a783          	lw	a5,4(a5) # 10004 <h>
 30c:	fdc42703          	lw	a4,-36(s0)
 310:	0af70863          	beq	a4,a5,3c0 <main+0x2d4>
 314:	000107b7          	lui	a5,0x10
 318:	0087a783          	lw	a5,8(a5) # 10008 <i>
 31c:	fdc42703          	lw	a4,-36(s0)
 320:	0af70063          	beq	a4,a5,3c0 <main+0x2d4>
 324:	000107b7          	lui	a5,0x10
 328:	00c7a783          	lw	a5,12(a5) # 1000c <j>
 32c:	fdc42703          	lw	a4,-36(s0)
 330:	08f70863          	beq	a4,a5,3c0 <main+0x2d4>
 334:	000107b7          	lui	a5,0x10
 338:	0107a783          	lw	a5,16(a5) # 10010 <k>
 33c:	fdc42703          	lw	a4,-36(s0)
 340:	08f70063          	beq	a4,a5,3c0 <main+0x2d4>
 344:	000107b7          	lui	a5,0x10
 348:	0047a783          	lw	a5,4(a5) # 10004 <h>
 34c:	fd842703          	lw	a4,-40(s0)
 350:	06f70863          	beq	a4,a5,3c0 <main+0x2d4>
 354:	000107b7          	lui	a5,0x10
 358:	0087a783          	lw	a5,8(a5) # 10008 <i>
 35c:	fd842703          	lw	a4,-40(s0)
 360:	06f70063          	beq	a4,a5,3c0 <main+0x2d4>
 364:	000107b7          	lui	a5,0x10
 368:	00c7a783          	lw	a5,12(a5) # 1000c <j>
 36c:	fd842703          	lw	a4,-40(s0)
 370:	04f70863          	beq	a4,a5,3c0 <main+0x2d4>
 374:	000107b7          	lui	a5,0x10
 378:	0107a783          	lw	a5,16(a5) # 10010 <k>
 37c:	fd842703          	lw	a4,-40(s0)
 380:	04f70063          	beq	a4,a5,3c0 <main+0x2d4>
 384:	000107b7          	lui	a5,0x10
 388:	0087a703          	lw	a4,8(a5) # 10008 <i>
 38c:	000107b7          	lui	a5,0x10
 390:	00c7a783          	lw	a5,12(a5) # 1000c <j>
 394:	02f70663          	beq	a4,a5,3c0 <main+0x2d4>
 398:	000107b7          	lui	a5,0x10
 39c:	0047a703          	lw	a4,4(a5) # 10004 <h>
 3a0:	000107b7          	lui	a5,0x10
 3a4:	0107a783          	lw	a5,16(a5) # 10010 <k>
 3a8:	00f70c63          	beq	a4,a5,3c0 <main+0x2d4>
 3ac:	000107b7          	lui	a5,0x10
 3b0:	01c7a783          	lw	a5,28(a5) # 1001c <total>
 3b4:	00178713          	addi	a4,a5,1
 3b8:	000107b7          	lui	a5,0x10
 3bc:	00e7ae23          	sw	a4,28(a5) # 1001c <total>
 3c0:	fd842783          	lw	a5,-40(s0)
 3c4:	00178793          	addi	a5,a5,1
 3c8:	fcf42c23          	sw	a5,-40(s0)
 3cc:	000107b7          	lui	a5,0x10
 3d0:	0187a783          	lw	a5,24(a5) # 10018 <N>
 3d4:	fd842703          	lw	a4,-40(s0)
 3d8:	d6e7dce3          	bge	a5,a4,150 <main+0x64>
 3dc:	fdc42783          	lw	a5,-36(s0)
 3e0:	00178793          	addi	a5,a5,1
 3e4:	fcf42e23          	sw	a5,-36(s0)
 3e8:	000107b7          	lui	a5,0x10
 3ec:	0187a783          	lw	a5,24(a5) # 10018 <N>
 3f0:	fdc42703          	lw	a4,-36(s0)
 3f4:	d4e7d8e3          	bge	a5,a4,144 <main+0x58>
 3f8:	fe042783          	lw	a5,-32(s0)
 3fc:	00178793          	addi	a5,a5,1
 400:	fef42023          	sw	a5,-32(s0)
 404:	000107b7          	lui	a5,0x10
 408:	0187a783          	lw	a5,24(a5) # 10018 <N>
 40c:	fe042703          	lw	a4,-32(s0)
 410:	d2e7d4e3          	bge	a5,a4,138 <main+0x4c>
 414:	fe442783          	lw	a5,-28(s0)
 418:	00178793          	addi	a5,a5,1
 41c:	fef42223          	sw	a5,-28(s0)
 420:	000107b7          	lui	a5,0x10
 424:	0187a783          	lw	a5,24(a5) # 10018 <N>
 428:	fe442703          	lw	a4,-28(s0)
 42c:	d0e7d0e3          	bge	a5,a4,12c <main+0x40>
 430:	fe842783          	lw	a5,-24(s0)
 434:	00178793          	addi	a5,a5,1
 438:	fef42423          	sw	a5,-24(s0)
 43c:	000107b7          	lui	a5,0x10
 440:	0187a783          	lw	a5,24(a5) # 10018 <N>
 444:	fe842703          	lw	a4,-24(s0)
 448:	cce7dce3          	bge	a5,a4,120 <main+0x34>
 44c:	fec42783          	lw	a5,-20(s0)
 450:	00178793          	addi	a5,a5,1
 454:	fef42623          	sw	a5,-20(s0)
 458:	000107b7          	lui	a5,0x10
 45c:	0187a783          	lw	a5,24(a5) # 10018 <N>
 460:	fec42703          	lw	a4,-20(s0)
 464:	cae7d8e3          	bge	a5,a4,114 <main+0x28>
 468:	000107b7          	lui	a5,0x10
 46c:	01c7a783          	lw	a5,28(a5) # 1001c <total>
 470:	00078513          	mv	a0,a5
 474:	ba1ff0ef          	jal	14 <printInt>
 478:	000107b7          	lui	a5,0x10
 47c:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
 480:	0fd00713          	li	a4,253
 484:	00070593          	mv	a1,a4
 488:	00078513          	mv	a0,a5
 48c:	0a0000ef          	jal	52c <__modsi3>
 490:	00050793          	mv	a5,a0
 494:	00078513          	mv	a0,a5
 498:	02c12083          	lw	ra,44(sp)
 49c:	02812403          	lw	s0,40(sp)
 4a0:	03010113          	addi	sp,sp,48
 4a4:	00008067          	ret

000004a8 <__divsi3>:
 4a8:	06054063          	bltz	a0,508 <__umodsi3+0x10>
 4ac:	0605c663          	bltz	a1,518 <__umodsi3+0x20>

000004b0 <__hidden___udivsi3>:
 4b0:	00058613          	mv	a2,a1
 4b4:	00050593          	mv	a1,a0
 4b8:	fff00513          	li	a0,-1
 4bc:	02060c63          	beqz	a2,4f4 <__hidden___udivsi3+0x44>
 4c0:	00100693          	li	a3,1
 4c4:	00b67a63          	bgeu	a2,a1,4d8 <__hidden___udivsi3+0x28>
 4c8:	00c05863          	blez	a2,4d8 <__hidden___udivsi3+0x28>
 4cc:	00161613          	slli	a2,a2,0x1
 4d0:	00169693          	slli	a3,a3,0x1
 4d4:	feb66ae3          	bltu	a2,a1,4c8 <__hidden___udivsi3+0x18>
 4d8:	00000513          	li	a0,0
 4dc:	00c5e663          	bltu	a1,a2,4e8 <__hidden___udivsi3+0x38>
 4e0:	40c585b3          	sub	a1,a1,a2
 4e4:	00d56533          	or	a0,a0,a3
 4e8:	0016d693          	srli	a3,a3,0x1
 4ec:	00165613          	srli	a2,a2,0x1
 4f0:	fe0696e3          	bnez	a3,4dc <__hidden___udivsi3+0x2c>
 4f4:	00008067          	ret

000004f8 <__umodsi3>:
 4f8:	00008293          	mv	t0,ra
 4fc:	fb5ff0ef          	jal	4b0 <__hidden___udivsi3>
 500:	00058513          	mv	a0,a1
 504:	00028067          	jr	t0
 508:	40a00533          	neg	a0,a0
 50c:	00b04863          	bgtz	a1,51c <__umodsi3+0x24>
 510:	40b005b3          	neg	a1,a1
 514:	f9dff06f          	j	4b0 <__hidden___udivsi3>
 518:	40b005b3          	neg	a1,a1
 51c:	00008293          	mv	t0,ra
 520:	f91ff0ef          	jal	4b0 <__hidden___udivsi3>
 524:	40a00533          	neg	a0,a0
 528:	00028067          	jr	t0

0000052c <__modsi3>:
 52c:	00008293          	mv	t0,ra
 530:	0005ca63          	bltz	a1,544 <__modsi3+0x18>
 534:	00054c63          	bltz	a0,54c <__modsi3+0x20>
 538:	f79ff0ef          	jal	4b0 <__hidden___udivsi3>
 53c:	00058513          	mv	a0,a1
 540:	00028067          	jr	t0
 544:	40b005b3          	neg	a1,a1
 548:	fe0558e3          	bgez	a0,538 <__modsi3+0xc>
 54c:	40a00533          	neg	a0,a0
 550:	f61ff0ef          	jal	4b0 <__hidden___udivsi3>
 554:	40b00533          	neg	a0,a1
 558:	00028067          	jr	t0
