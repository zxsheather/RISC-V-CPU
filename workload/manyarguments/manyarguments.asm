
manyarguments.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	1a0000ef          	jal	1a4 <main>
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

000000ec <a>:
  ec:	fd010113          	addi	sp,sp,-48
  f0:	02112623          	sw	ra,44(sp)
  f4:	02812423          	sw	s0,40(sp)
  f8:	03010413          	addi	s0,sp,48
  fc:	fea42623          	sw	a0,-20(s0)
 100:	feb42423          	sw	a1,-24(s0)
 104:	fec42223          	sw	a2,-28(s0)
 108:	fed42023          	sw	a3,-32(s0)
 10c:	fce42e23          	sw	a4,-36(s0)
 110:	fcf42c23          	sw	a5,-40(s0)
 114:	fd042a23          	sw	a6,-44(s0)
 118:	fd142823          	sw	a7,-48(s0)
 11c:	fec42703          	lw	a4,-20(s0)
 120:	fe842783          	lw	a5,-24(s0)
 124:	00f70733          	add	a4,a4,a5
 128:	fe442783          	lw	a5,-28(s0)
 12c:	00f70733          	add	a4,a4,a5
 130:	fe042783          	lw	a5,-32(s0)
 134:	00f70733          	add	a4,a4,a5
 138:	fdc42783          	lw	a5,-36(s0)
 13c:	00f70733          	add	a4,a4,a5
 140:	fd842783          	lw	a5,-40(s0)
 144:	00f70733          	add	a4,a4,a5
 148:	fd442783          	lw	a5,-44(s0)
 14c:	00f70733          	add	a4,a4,a5
 150:	fd042783          	lw	a5,-48(s0)
 154:	00f70733          	add	a4,a4,a5
 158:	00042783          	lw	a5,0(s0)
 15c:	00f70733          	add	a4,a4,a5
 160:	00442783          	lw	a5,4(s0)
 164:	00f70733          	add	a4,a4,a5
 168:	00842783          	lw	a5,8(s0)
 16c:	00f70733          	add	a4,a4,a5
 170:	00c42783          	lw	a5,12(s0)
 174:	00f70733          	add	a4,a4,a5
 178:	01042783          	lw	a5,16(s0)
 17c:	00f70733          	add	a4,a4,a5
 180:	01442783          	lw	a5,20(s0)
 184:	00f70733          	add	a4,a4,a5
 188:	01842783          	lw	a5,24(s0)
 18c:	00f707b3          	add	a5,a4,a5
 190:	00078513          	mv	a0,a5
 194:	02c12083          	lw	ra,44(sp)
 198:	02812403          	lw	s0,40(sp)
 19c:	03010113          	addi	sp,sp,48
 1a0:	00008067          	ret

000001a4 <main>:
 1a4:	fd010113          	addi	sp,sp,-48
 1a8:	02112623          	sw	ra,44(sp)
 1ac:	02812423          	sw	s0,40(sp)
 1b0:	03010413          	addi	s0,sp,48
 1b4:	00f00793          	li	a5,15
 1b8:	00f12c23          	sw	a5,24(sp)
 1bc:	00e00793          	li	a5,14
 1c0:	00f12a23          	sw	a5,20(sp)
 1c4:	00d00793          	li	a5,13
 1c8:	00f12823          	sw	a5,16(sp)
 1cc:	00c00793          	li	a5,12
 1d0:	00f12623          	sw	a5,12(sp)
 1d4:	00b00793          	li	a5,11
 1d8:	00f12423          	sw	a5,8(sp)
 1dc:	00a00793          	li	a5,10
 1e0:	00f12223          	sw	a5,4(sp)
 1e4:	00900793          	li	a5,9
 1e8:	00f12023          	sw	a5,0(sp)
 1ec:	00800893          	li	a7,8
 1f0:	00700813          	li	a6,7
 1f4:	00600793          	li	a5,6
 1f8:	00500713          	li	a4,5
 1fc:	00400693          	li	a3,4
 200:	00300613          	li	a2,3
 204:	00200593          	li	a1,2
 208:	00100513          	li	a0,1
 20c:	ee1ff0ef          	jal	ec <a>
 210:	00050793          	mv	a5,a0
 214:	00078513          	mv	a0,a5
 218:	dfdff0ef          	jal	14 <printInt>
 21c:	000107b7          	lui	a5,0x10
 220:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
 224:	0fd00713          	li	a4,253
 228:	00070593          	mv	a1,a4
 22c:	00078513          	mv	a0,a5
 230:	0a0000ef          	jal	2d0 <__modsi3>
 234:	00050793          	mv	a5,a0
 238:	00078513          	mv	a0,a5
 23c:	02c12083          	lw	ra,44(sp)
 240:	02812403          	lw	s0,40(sp)
 244:	03010113          	addi	sp,sp,48
 248:	00008067          	ret

0000024c <__divsi3>:
 24c:	06054063          	bltz	a0,2ac <__umodsi3+0x10>
 250:	0605c663          	bltz	a1,2bc <__umodsi3+0x20>

00000254 <__hidden___udivsi3>:
 254:	00058613          	mv	a2,a1
 258:	00050593          	mv	a1,a0
 25c:	fff00513          	li	a0,-1
 260:	02060c63          	beqz	a2,298 <__hidden___udivsi3+0x44>
 264:	00100693          	li	a3,1
 268:	00b67a63          	bgeu	a2,a1,27c <__hidden___udivsi3+0x28>
 26c:	00c05863          	blez	a2,27c <__hidden___udivsi3+0x28>
 270:	00161613          	slli	a2,a2,0x1
 274:	00169693          	slli	a3,a3,0x1
 278:	feb66ae3          	bltu	a2,a1,26c <__hidden___udivsi3+0x18>
 27c:	00000513          	li	a0,0
 280:	00c5e663          	bltu	a1,a2,28c <__hidden___udivsi3+0x38>
 284:	40c585b3          	sub	a1,a1,a2
 288:	00d56533          	or	a0,a0,a3
 28c:	0016d693          	srli	a3,a3,0x1
 290:	00165613          	srli	a2,a2,0x1
 294:	fe0696e3          	bnez	a3,280 <__hidden___udivsi3+0x2c>
 298:	00008067          	ret

0000029c <__umodsi3>:
 29c:	00008293          	mv	t0,ra
 2a0:	fb5ff0ef          	jal	254 <__hidden___udivsi3>
 2a4:	00058513          	mv	a0,a1
 2a8:	00028067          	jr	t0
 2ac:	40a00533          	neg	a0,a0
 2b0:	00b04863          	bgtz	a1,2c0 <__umodsi3+0x24>
 2b4:	40b005b3          	neg	a1,a1
 2b8:	f9dff06f          	j	254 <__hidden___udivsi3>
 2bc:	40b005b3          	neg	a1,a1
 2c0:	00008293          	mv	t0,ra
 2c4:	f91ff0ef          	jal	254 <__hidden___udivsi3>
 2c8:	40a00533          	neg	a0,a0
 2cc:	00028067          	jr	t0

000002d0 <__modsi3>:
 2d0:	00008293          	mv	t0,ra
 2d4:	0005ca63          	bltz	a1,2e8 <__modsi3+0x18>
 2d8:	00054c63          	bltz	a0,2f0 <__modsi3+0x20>
 2dc:	f79ff0ef          	jal	254 <__hidden___udivsi3>
 2e0:	00058513          	mv	a0,a1
 2e4:	00028067          	jr	t0
 2e8:	40b005b3          	neg	a1,a1
 2ec:	fe0558e3          	bgez	a0,2dc <__modsi3+0xc>
 2f0:	40a00533          	neg	a0,a0
 2f4:	f61ff0ef          	jal	254 <__hidden___udivsi3>
 2f8:	40b00533          	neg	a0,a1
 2fc:	00028067          	jr	t0
