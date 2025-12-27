
hanoi.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	1e4000ef          	jal	1e8 <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <judgeResult+0xffcc>
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

000000ec <cd>:
  ec:	fd010113          	addi	sp,sp,-48
  f0:	02112623          	sw	ra,44(sp)
  f4:	02812423          	sw	s0,40(sp)
  f8:	03010413          	addi	s0,sp,48
  fc:	fea42623          	sw	a0,-20(s0)
 100:	feb42423          	sw	a1,-24(s0)
 104:	fec42223          	sw	a2,-28(s0)
 108:	fed42023          	sw	a3,-32(s0)
 10c:	fce42e23          	sw	a4,-36(s0)
 110:	fec42703          	lw	a4,-20(s0)
 114:	00100793          	li	a5,1
 118:	02f71e63          	bne	a4,a5,154 <cd+0x68>
 11c:	000107b7          	lui	a5,0x10
 120:	00078513          	mv	a0,a5
 124:	f45ff0ef          	jal	68 <printStr>
 128:	fe842503          	lw	a0,-24(s0)
 12c:	f3dff0ef          	jal	68 <printStr>
 130:	000107b7          	lui	a5,0x10
 134:	00878513          	addi	a0,a5,8 # 10008 <__modsi3+0xfd08>
 138:	f31ff0ef          	jal	68 <printStr>
 13c:	fe042503          	lw	a0,-32(s0)
 140:	f29ff0ef          	jal	68 <printStr>
 144:	fdc42783          	lw	a5,-36(s0)
 148:	00178793          	addi	a5,a5,1
 14c:	fcf42e23          	sw	a5,-36(s0)
 150:	0800006f          	j	1d0 <cd+0xe4>
 154:	fec42783          	lw	a5,-20(s0)
 158:	fff78793          	addi	a5,a5,-1
 15c:	fdc42703          	lw	a4,-36(s0)
 160:	fe442683          	lw	a3,-28(s0)
 164:	fe042603          	lw	a2,-32(s0)
 168:	fe842583          	lw	a1,-24(s0)
 16c:	00078513          	mv	a0,a5
 170:	f7dff0ef          	jal	ec <cd>
 174:	fca42e23          	sw	a0,-36(s0)
 178:	000107b7          	lui	a5,0x10
 17c:	00078513          	mv	a0,a5
 180:	ee9ff0ef          	jal	68 <printStr>
 184:	fe842503          	lw	a0,-24(s0)
 188:	ee1ff0ef          	jal	68 <printStr>
 18c:	000107b7          	lui	a5,0x10
 190:	00878513          	addi	a0,a5,8 # 10008 <__modsi3+0xfd08>
 194:	ed5ff0ef          	jal	68 <printStr>
 198:	fe042503          	lw	a0,-32(s0)
 19c:	ecdff0ef          	jal	68 <printStr>
 1a0:	fec42783          	lw	a5,-20(s0)
 1a4:	fff78793          	addi	a5,a5,-1
 1a8:	fdc42703          	lw	a4,-36(s0)
 1ac:	fe042683          	lw	a3,-32(s0)
 1b0:	fe842603          	lw	a2,-24(s0)
 1b4:	fe442583          	lw	a1,-28(s0)
 1b8:	00078513          	mv	a0,a5
 1bc:	f31ff0ef          	jal	ec <cd>
 1c0:	fca42e23          	sw	a0,-36(s0)
 1c4:	fdc42783          	lw	a5,-36(s0)
 1c8:	00178793          	addi	a5,a5,1
 1cc:	fcf42e23          	sw	a5,-36(s0)
 1d0:	fdc42783          	lw	a5,-36(s0)
 1d4:	00078513          	mv	a0,a5
 1d8:	02c12083          	lw	ra,44(sp)
 1dc:	02812403          	lw	s0,40(sp)
 1e0:	03010113          	addi	sp,sp,48
 1e4:	00008067          	ret

000001e8 <main>:
 1e8:	fd010113          	addi	sp,sp,-48
 1ec:	02112623          	sw	ra,44(sp)
 1f0:	02812423          	sw	s0,40(sp)
 1f4:	03010413          	addi	s0,sp,48
 1f8:	04100793          	li	a5,65
 1fc:	fef42023          	sw	a5,-32(s0)
 200:	fe040223          	sb	zero,-28(s0)
 204:	04200793          	li	a5,66
 208:	fcf42c23          	sw	a5,-40(s0)
 20c:	fc040e23          	sb	zero,-36(s0)
 210:	04300793          	li	a5,67
 214:	fcf42823          	sw	a5,-48(s0)
 218:	fc040a23          	sb	zero,-44(s0)
 21c:	00a00793          	li	a5,10
 220:	fef42623          	sw	a5,-20(s0)
 224:	fd040693          	addi	a3,s0,-48
 228:	fd840613          	addi	a2,s0,-40
 22c:	fe040793          	addi	a5,s0,-32
 230:	00000713          	li	a4,0
 234:	00078593          	mv	a1,a5
 238:	fec42503          	lw	a0,-20(s0)
 23c:	eb1ff0ef          	jal	ec <cd>
 240:	fea42423          	sw	a0,-24(s0)
 244:	fe842503          	lw	a0,-24(s0)
 248:	dcdff0ef          	jal	14 <printInt>
 24c:	000107b7          	lui	a5,0x10
 250:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
 254:	0fd00713          	li	a4,253
 258:	00070593          	mv	a1,a4
 25c:	00078513          	mv	a0,a5
 260:	0a0000ef          	jal	300 <__modsi3>
 264:	00050793          	mv	a5,a0
 268:	00078513          	mv	a0,a5
 26c:	02c12083          	lw	ra,44(sp)
 270:	02812403          	lw	s0,40(sp)
 274:	03010113          	addi	sp,sp,48
 278:	00008067          	ret

0000027c <__divsi3>:
 27c:	06054063          	bltz	a0,2dc <__umodsi3+0x10>
 280:	0605c663          	bltz	a1,2ec <__umodsi3+0x20>

00000284 <__hidden___udivsi3>:
 284:	00058613          	mv	a2,a1
 288:	00050593          	mv	a1,a0
 28c:	fff00513          	li	a0,-1
 290:	02060c63          	beqz	a2,2c8 <__hidden___udivsi3+0x44>
 294:	00100693          	li	a3,1
 298:	00b67a63          	bgeu	a2,a1,2ac <__hidden___udivsi3+0x28>
 29c:	00c05863          	blez	a2,2ac <__hidden___udivsi3+0x28>
 2a0:	00161613          	slli	a2,a2,0x1
 2a4:	00169693          	slli	a3,a3,0x1
 2a8:	feb66ae3          	bltu	a2,a1,29c <__hidden___udivsi3+0x18>
 2ac:	00000513          	li	a0,0
 2b0:	00c5e663          	bltu	a1,a2,2bc <__hidden___udivsi3+0x38>
 2b4:	40c585b3          	sub	a1,a1,a2
 2b8:	00d56533          	or	a0,a0,a3
 2bc:	0016d693          	srli	a3,a3,0x1
 2c0:	00165613          	srli	a2,a2,0x1
 2c4:	fe0696e3          	bnez	a3,2b0 <__hidden___udivsi3+0x2c>
 2c8:	00008067          	ret

000002cc <__umodsi3>:
 2cc:	00008293          	mv	t0,ra
 2d0:	fb5ff0ef          	jal	284 <__hidden___udivsi3>
 2d4:	00058513          	mv	a0,a1
 2d8:	00028067          	jr	t0
 2dc:	40a00533          	neg	a0,a0
 2e0:	00b04863          	bgtz	a1,2f0 <__umodsi3+0x24>
 2e4:	40b005b3          	neg	a1,a1
 2e8:	f9dff06f          	j	284 <__hidden___udivsi3>
 2ec:	40b005b3          	neg	a1,a1
 2f0:	00008293          	mv	t0,ra
 2f4:	f91ff0ef          	jal	284 <__hidden___udivsi3>
 2f8:	40a00533          	neg	a0,a0
 2fc:	00028067          	jr	t0

00000300 <__modsi3>:
 300:	00008293          	mv	t0,ra
 304:	0005ca63          	bltz	a1,318 <__modsi3+0x18>
 308:	00054c63          	bltz	a0,320 <__modsi3+0x20>
 30c:	f79ff0ef          	jal	284 <__hidden___udivsi3>
 310:	00058513          	mv	a0,a1
 314:	00028067          	jr	t0
 318:	40b005b3          	neg	a1,a1
 31c:	fe0558e3          	bgez	a0,30c <__modsi3+0xc>
 320:	40a00533          	neg	a0,a0
 324:	f61ff0ef          	jal	284 <__hidden___udivsi3>
 328:	40b00533          	neg	a0,a1
 32c:	00028067          	jr	t0
