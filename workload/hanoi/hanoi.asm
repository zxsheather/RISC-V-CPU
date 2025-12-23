
hanoi.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	1c0000ef          	jal	1c4 <main>
   8:	00100073          	ebreak

0000000c <loop>:
   c:	0000006f          	j	c <loop>

00000010 <printInt>:
  10:	fe010113          	add	sp,sp,-32 # 1ffe0 <judgeResult+0xffe0>
  14:	00812e23          	sw	s0,28(sp)
  18:	02010413          	add	s0,sp,32
  1c:	fea42623          	sw	a0,-20(s0)
  20:	000107b7          	lui	a5,0x10
  24:	0007a703          	lw	a4,0(a5) # 10000 <judgeResult>
  28:	fec42783          	lw	a5,-20(s0)
  2c:	00f74733          	xor	a4,a4,a5
  30:	000107b7          	lui	a5,0x10
  34:	00e7a023          	sw	a4,0(a5) # 10000 <judgeResult>
  38:	000107b7          	lui	a5,0x10
  3c:	0007a783          	lw	a5,0(a5) # 10000 <judgeResult>
  40:	0ad78713          	add	a4,a5,173
  44:	000107b7          	lui	a5,0x10
  48:	00e7a023          	sw	a4,0(a5) # 10000 <judgeResult>
  4c:	00000013          	nop
  50:	01c12403          	lw	s0,28(sp)
  54:	02010113          	add	sp,sp,32
  58:	00008067          	ret

0000005c <printStr>:
  5c:	fd010113          	add	sp,sp,-48
  60:	02812623          	sw	s0,44(sp)
  64:	03010413          	add	s0,sp,48
  68:	fca42e23          	sw	a0,-36(s0)
  6c:	fdc42783          	lw	a5,-36(s0)
  70:	fef42623          	sw	a5,-20(s0)
  74:	0440006f          	j	b8 <printStr+0x5c>
  78:	fec42783          	lw	a5,-20(s0)
  7c:	0007c783          	lbu	a5,0(a5)
  80:	00078713          	mv	a4,a5
  84:	000107b7          	lui	a5,0x10
  88:	0007a783          	lw	a5,0(a5) # 10000 <judgeResult>
  8c:	00f74733          	xor	a4,a4,a5
  90:	000107b7          	lui	a5,0x10
  94:	00e7a023          	sw	a4,0(a5) # 10000 <judgeResult>
  98:	000107b7          	lui	a5,0x10
  9c:	0007a783          	lw	a5,0(a5) # 10000 <judgeResult>
  a0:	20978713          	add	a4,a5,521
  a4:	000107b7          	lui	a5,0x10
  a8:	00e7a023          	sw	a4,0(a5) # 10000 <judgeResult>
  ac:	fec42783          	lw	a5,-20(s0)
  b0:	00178793          	add	a5,a5,1
  b4:	fef42623          	sw	a5,-20(s0)
  b8:	fec42783          	lw	a5,-20(s0)
  bc:	0007c783          	lbu	a5,0(a5)
  c0:	fa079ce3          	bnez	a5,78 <printStr+0x1c>
  c4:	00000013          	nop
  c8:	00000013          	nop
  cc:	02c12403          	lw	s0,44(sp)
  d0:	03010113          	add	sp,sp,48
  d4:	00008067          	ret

000000d8 <cd>:
  d8:	fd010113          	add	sp,sp,-48
  dc:	02112623          	sw	ra,44(sp)
  e0:	02812423          	sw	s0,40(sp)
  e4:	03010413          	add	s0,sp,48
  e8:	fea42623          	sw	a0,-20(s0)
  ec:	feb42423          	sw	a1,-24(s0)
  f0:	fec42223          	sw	a2,-28(s0)
  f4:	fed42023          	sw	a3,-32(s0)
  f8:	fce42e23          	sw	a4,-36(s0)
  fc:	fec42703          	lw	a4,-20(s0)
 100:	00100793          	li	a5,1
 104:	02f71a63          	bne	a4,a5,138 <cd+0x60>
 108:	31000513          	li	a0,784
 10c:	f51ff0ef          	jal	5c <printStr>
 110:	fe842503          	lw	a0,-24(s0)
 114:	f49ff0ef          	jal	5c <printStr>
 118:	31800513          	li	a0,792
 11c:	f41ff0ef          	jal	5c <printStr>
 120:	fe042503          	lw	a0,-32(s0)
 124:	f39ff0ef          	jal	5c <printStr>
 128:	fdc42783          	lw	a5,-36(s0)
 12c:	00178793          	add	a5,a5,1
 130:	fcf42e23          	sw	a5,-36(s0)
 134:	0780006f          	j	1ac <cd+0xd4>
 138:	fec42783          	lw	a5,-20(s0)
 13c:	fff78793          	add	a5,a5,-1
 140:	fdc42703          	lw	a4,-36(s0)
 144:	fe442683          	lw	a3,-28(s0)
 148:	fe042603          	lw	a2,-32(s0)
 14c:	fe842583          	lw	a1,-24(s0)
 150:	00078513          	mv	a0,a5
 154:	f85ff0ef          	jal	d8 <cd>
 158:	fca42e23          	sw	a0,-36(s0)
 15c:	31000513          	li	a0,784
 160:	efdff0ef          	jal	5c <printStr>
 164:	fe842503          	lw	a0,-24(s0)
 168:	ef5ff0ef          	jal	5c <printStr>
 16c:	31800513          	li	a0,792
 170:	eedff0ef          	jal	5c <printStr>
 174:	fe042503          	lw	a0,-32(s0)
 178:	ee5ff0ef          	jal	5c <printStr>
 17c:	fec42783          	lw	a5,-20(s0)
 180:	fff78793          	add	a5,a5,-1
 184:	fdc42703          	lw	a4,-36(s0)
 188:	fe042683          	lw	a3,-32(s0)
 18c:	fe842603          	lw	a2,-24(s0)
 190:	fe442583          	lw	a1,-28(s0)
 194:	00078513          	mv	a0,a5
 198:	f41ff0ef          	jal	d8 <cd>
 19c:	fca42e23          	sw	a0,-36(s0)
 1a0:	fdc42783          	lw	a5,-36(s0)
 1a4:	00178793          	add	a5,a5,1
 1a8:	fcf42e23          	sw	a5,-36(s0)
 1ac:	fdc42783          	lw	a5,-36(s0)
 1b0:	00078513          	mv	a0,a5
 1b4:	02c12083          	lw	ra,44(sp)
 1b8:	02812403          	lw	s0,40(sp)
 1bc:	03010113          	add	sp,sp,48
 1c0:	00008067          	ret

000001c4 <main>:
 1c4:	fd010113          	add	sp,sp,-48
 1c8:	02112623          	sw	ra,44(sp)
 1cc:	02812423          	sw	s0,40(sp)
 1d0:	03010413          	add	s0,sp,48
 1d4:	fe040793          	add	a5,s0,-32
 1d8:	04100713          	li	a4,65
 1dc:	00e7a023          	sw	a4,0(a5)
 1e0:	fd840793          	add	a5,s0,-40
 1e4:	04200713          	li	a4,66
 1e8:	00e7a023          	sw	a4,0(a5)
 1ec:	fd040793          	add	a5,s0,-48
 1f0:	04300713          	li	a4,67
 1f4:	00e7a023          	sw	a4,0(a5)
 1f8:	00a00793          	li	a5,10
 1fc:	fef42623          	sw	a5,-20(s0)
 200:	fd040693          	add	a3,s0,-48
 204:	fd840613          	add	a2,s0,-40
 208:	fe040793          	add	a5,s0,-32
 20c:	00000713          	li	a4,0
 210:	00078593          	mv	a1,a5
 214:	fec42503          	lw	a0,-20(s0)
 218:	ec1ff0ef          	jal	d8 <cd>
 21c:	fea42423          	sw	a0,-24(s0)
 220:	fe842503          	lw	a0,-24(s0)
 224:	dedff0ef          	jal	10 <printInt>
 228:	000107b7          	lui	a5,0x10
 22c:	0007a783          	lw	a5,0(a5) # 10000 <judgeResult>
 230:	0fd00713          	li	a4,253
 234:	00070593          	mv	a1,a4
 238:	00078513          	mv	a0,a5
 23c:	0a0000ef          	jal	2dc <__modsi3>
 240:	00050793          	mv	a5,a0
 244:	00078513          	mv	a0,a5
 248:	02c12083          	lw	ra,44(sp)
 24c:	02812403          	lw	s0,40(sp)
 250:	03010113          	add	sp,sp,48
 254:	00008067          	ret

00000258 <__divsi3>:
 258:	06054063          	bltz	a0,2b8 <__umodsi3+0x10>
 25c:	0605c663          	bltz	a1,2c8 <__umodsi3+0x20>

00000260 <__hidden___udivsi3>:
 260:	00058613          	mv	a2,a1
 264:	00050593          	mv	a1,a0
 268:	fff00513          	li	a0,-1
 26c:	02060c63          	beqz	a2,2a4 <__hidden___udivsi3+0x44>
 270:	00100693          	li	a3,1
 274:	00b67a63          	bgeu	a2,a1,288 <__hidden___udivsi3+0x28>
 278:	00c05863          	blez	a2,288 <__hidden___udivsi3+0x28>
 27c:	00161613          	sll	a2,a2,0x1
 280:	00169693          	sll	a3,a3,0x1
 284:	feb66ae3          	bltu	a2,a1,278 <__hidden___udivsi3+0x18>
 288:	00000513          	li	a0,0
 28c:	00c5e663          	bltu	a1,a2,298 <__hidden___udivsi3+0x38>
 290:	40c585b3          	sub	a1,a1,a2
 294:	00d56533          	or	a0,a0,a3
 298:	0016d693          	srl	a3,a3,0x1
 29c:	00165613          	srl	a2,a2,0x1
 2a0:	fe0696e3          	bnez	a3,28c <__hidden___udivsi3+0x2c>
 2a4:	00008067          	ret

000002a8 <__umodsi3>:
 2a8:	00008293          	mv	t0,ra
 2ac:	fb5ff0ef          	jal	260 <__hidden___udivsi3>
 2b0:	00058513          	mv	a0,a1
 2b4:	00028067          	jr	t0
 2b8:	40a00533          	neg	a0,a0
 2bc:	00b04863          	bgtz	a1,2cc <__umodsi3+0x24>
 2c0:	40b005b3          	neg	a1,a1
 2c4:	f9dff06f          	j	260 <__hidden___udivsi3>
 2c8:	40b005b3          	neg	a1,a1
 2cc:	00008293          	mv	t0,ra
 2d0:	f91ff0ef          	jal	260 <__hidden___udivsi3>
 2d4:	40a00533          	neg	a0,a0
 2d8:	00028067          	jr	t0

000002dc <__modsi3>:
 2dc:	00008293          	mv	t0,ra
 2e0:	0005ca63          	bltz	a1,2f4 <__modsi3+0x18>
 2e4:	00054c63          	bltz	a0,2fc <__modsi3+0x20>
 2e8:	f79ff0ef          	jal	260 <__hidden___udivsi3>
 2ec:	00058513          	mv	a0,a1
 2f0:	00028067          	jr	t0
 2f4:	40b005b3          	neg	a1,a1
 2f8:	fe0558e3          	bgez	a0,2e8 <__modsi3+0xc>
 2fc:	40a00533          	neg	a0,a0
 300:	f61ff0ef          	jal	260 <__hidden___udivsi3>
 304:	40b00533          	neg	a0,a1
 308:	00028067          	jr	t0
