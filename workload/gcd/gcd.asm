
gcd.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	158000ef          	jal	15c <main>
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

000000ec <gcd>:
  ec:	fe010113          	addi	sp,sp,-32
  f0:	00112e23          	sw	ra,28(sp)
  f4:	00812c23          	sw	s0,24(sp)
  f8:	02010413          	addi	s0,sp,32
  fc:	fea42623          	sw	a0,-20(s0)
 100:	feb42423          	sw	a1,-24(s0)
 104:	fec42783          	lw	a5,-20(s0)
 108:	fe842583          	lw	a1,-24(s0)
 10c:	00078513          	mv	a0,a5
 110:	164000ef          	jal	274 <__modsi3>
 114:	00050793          	mv	a5,a0
 118:	00079663          	bnez	a5,124 <gcd+0x38>
 11c:	fe842783          	lw	a5,-24(s0)
 120:	0280006f          	j	148 <gcd+0x5c>
 124:	fec42783          	lw	a5,-20(s0)
 128:	fe842583          	lw	a1,-24(s0)
 12c:	00078513          	mv	a0,a5
 130:	144000ef          	jal	274 <__modsi3>
 134:	00050793          	mv	a5,a0
 138:	00078593          	mv	a1,a5
 13c:	fe842503          	lw	a0,-24(s0)
 140:	fadff0ef          	jal	ec <gcd>
 144:	00050793          	mv	a5,a0
 148:	00078513          	mv	a0,a5
 14c:	01c12083          	lw	ra,28(sp)
 150:	01812403          	lw	s0,24(sp)
 154:	02010113          	addi	sp,sp,32
 158:	00008067          	ret

0000015c <main>:
 15c:	ff010113          	addi	sp,sp,-16
 160:	00112623          	sw	ra,12(sp)
 164:	00812423          	sw	s0,8(sp)
 168:	01010413          	addi	s0,sp,16
 16c:	00100593          	li	a1,1
 170:	00a00513          	li	a0,10
 174:	f79ff0ef          	jal	ec <gcd>
 178:	00050793          	mv	a5,a0
 17c:	00078513          	mv	a0,a5
 180:	e95ff0ef          	jal	14 <printInt>
 184:	000017b7          	lui	a5,0x1
 188:	c0f78593          	addi	a1,a5,-1009 # c0f <__modsi3+0x99b>
 18c:	000097b7          	lui	a5,0x9
 190:	8aa78513          	addi	a0,a5,-1878 # 88aa <__modsi3+0x8636>
 194:	f59ff0ef          	jal	ec <gcd>
 198:	00050793          	mv	a5,a0
 19c:	00078513          	mv	a0,a5
 1a0:	e75ff0ef          	jal	14 <printInt>
 1a4:	60300593          	li	a1,1539
 1a8:	000017b7          	lui	a5,0x1
 1ac:	b5b78513          	addi	a0,a5,-1189 # b5b <__modsi3+0x8e7>
 1b0:	f3dff0ef          	jal	ec <gcd>
 1b4:	00050793          	mv	a5,a0
 1b8:	00078513          	mv	a0,a5
 1bc:	e59ff0ef          	jal	14 <printInt>
 1c0:	000107b7          	lui	a5,0x10
 1c4:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
 1c8:	0fd00713          	li	a4,253
 1cc:	00070593          	mv	a1,a4
 1d0:	00078513          	mv	a0,a5
 1d4:	0a0000ef          	jal	274 <__modsi3>
 1d8:	00050793          	mv	a5,a0
 1dc:	00078513          	mv	a0,a5
 1e0:	00c12083          	lw	ra,12(sp)
 1e4:	00812403          	lw	s0,8(sp)
 1e8:	01010113          	addi	sp,sp,16
 1ec:	00008067          	ret

000001f0 <__divsi3>:
 1f0:	06054063          	bltz	a0,250 <__umodsi3+0x10>
 1f4:	0605c663          	bltz	a1,260 <__umodsi3+0x20>

000001f8 <__hidden___udivsi3>:
 1f8:	00058613          	mv	a2,a1
 1fc:	00050593          	mv	a1,a0
 200:	fff00513          	li	a0,-1
 204:	02060c63          	beqz	a2,23c <__hidden___udivsi3+0x44>
 208:	00100693          	li	a3,1
 20c:	00b67a63          	bgeu	a2,a1,220 <__hidden___udivsi3+0x28>
 210:	00c05863          	blez	a2,220 <__hidden___udivsi3+0x28>
 214:	00161613          	slli	a2,a2,0x1
 218:	00169693          	slli	a3,a3,0x1
 21c:	feb66ae3          	bltu	a2,a1,210 <__hidden___udivsi3+0x18>
 220:	00000513          	li	a0,0
 224:	00c5e663          	bltu	a1,a2,230 <__hidden___udivsi3+0x38>
 228:	40c585b3          	sub	a1,a1,a2
 22c:	00d56533          	or	a0,a0,a3
 230:	0016d693          	srli	a3,a3,0x1
 234:	00165613          	srli	a2,a2,0x1
 238:	fe0696e3          	bnez	a3,224 <__hidden___udivsi3+0x2c>
 23c:	00008067          	ret

00000240 <__umodsi3>:
 240:	00008293          	mv	t0,ra
 244:	fb5ff0ef          	jal	1f8 <__hidden___udivsi3>
 248:	00058513          	mv	a0,a1
 24c:	00028067          	jr	t0
 250:	40a00533          	neg	a0,a0
 254:	00b04863          	bgtz	a1,264 <__umodsi3+0x24>
 258:	40b005b3          	neg	a1,a1
 25c:	f9dff06f          	j	1f8 <__hidden___udivsi3>
 260:	40b005b3          	neg	a1,a1
 264:	00008293          	mv	t0,ra
 268:	f91ff0ef          	jal	1f8 <__hidden___udivsi3>
 26c:	40a00533          	neg	a0,a0
 270:	00028067          	jr	t0

00000274 <__modsi3>:
 274:	00008293          	mv	t0,ra
 278:	0005ca63          	bltz	a1,28c <__modsi3+0x18>
 27c:	00054c63          	bltz	a0,294 <__modsi3+0x20>
 280:	f79ff0ef          	jal	1f8 <__hidden___udivsi3>
 284:	00058513          	mv	a0,a1
 288:	00028067          	jr	t0
 28c:	40b005b3          	neg	a1,a1
 290:	fe0558e3          	bgez	a0,280 <__modsi3+0xc>
 294:	40a00533          	neg	a0,a0
 298:	f61ff0ef          	jal	1f8 <__hidden___udivsi3>
 29c:	40b00533          	neg	a0,a1
 2a0:	00028067          	jr	t0
