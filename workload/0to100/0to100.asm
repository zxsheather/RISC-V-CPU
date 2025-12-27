
0to100.elf：     文件格式 elf32-littleriscv


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
  ec:	fe010113          	addi	sp,sp,-32
  f0:	00112e23          	sw	ra,28(sp)
  f4:	00812c23          	sw	s0,24(sp)
  f8:	02010413          	addi	s0,sp,32
  fc:	fe042623          	sw	zero,-20(s0)
 100:	fe042423          	sw	zero,-24(s0)
 104:	0200006f          	j	124 <main+0x38>
 108:	fec42703          	lw	a4,-20(s0)
 10c:	fe842783          	lw	a5,-24(s0)
 110:	00f707b3          	add	a5,a4,a5
 114:	fef42623          	sw	a5,-20(s0)
 118:	fe842783          	lw	a5,-24(s0)
 11c:	00178793          	addi	a5,a5,1
 120:	fef42423          	sw	a5,-24(s0)
 124:	fe842703          	lw	a4,-24(s0)
 128:	06400793          	li	a5,100
 12c:	fce7dee3          	bge	a5,a4,108 <main+0x1c>
 130:	fec42503          	lw	a0,-20(s0)
 134:	ee1ff0ef          	jal	14 <printInt>
 138:	000107b7          	lui	a5,0x10
 13c:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
 140:	0fd00713          	li	a4,253
 144:	00070593          	mv	a1,a4
 148:	00078513          	mv	a0,a5
 14c:	0a0000ef          	jal	1ec <__modsi3>
 150:	00050793          	mv	a5,a0
 154:	00078513          	mv	a0,a5
 158:	01c12083          	lw	ra,28(sp)
 15c:	01812403          	lw	s0,24(sp)
 160:	02010113          	addi	sp,sp,32
 164:	00008067          	ret

00000168 <__divsi3>:
 168:	06054063          	bltz	a0,1c8 <__umodsi3+0x10>
 16c:	0605c663          	bltz	a1,1d8 <__umodsi3+0x20>

00000170 <__hidden___udivsi3>:
 170:	00058613          	mv	a2,a1
 174:	00050593          	mv	a1,a0
 178:	fff00513          	li	a0,-1
 17c:	02060c63          	beqz	a2,1b4 <__hidden___udivsi3+0x44>
 180:	00100693          	li	a3,1
 184:	00b67a63          	bgeu	a2,a1,198 <__hidden___udivsi3+0x28>
 188:	00c05863          	blez	a2,198 <__hidden___udivsi3+0x28>
 18c:	00161613          	slli	a2,a2,0x1
 190:	00169693          	slli	a3,a3,0x1
 194:	feb66ae3          	bltu	a2,a1,188 <__hidden___udivsi3+0x18>
 198:	00000513          	li	a0,0
 19c:	00c5e663          	bltu	a1,a2,1a8 <__hidden___udivsi3+0x38>
 1a0:	40c585b3          	sub	a1,a1,a2
 1a4:	00d56533          	or	a0,a0,a3
 1a8:	0016d693          	srli	a3,a3,0x1
 1ac:	00165613          	srli	a2,a2,0x1
 1b0:	fe0696e3          	bnez	a3,19c <__hidden___udivsi3+0x2c>
 1b4:	00008067          	ret

000001b8 <__umodsi3>:
 1b8:	00008293          	mv	t0,ra
 1bc:	fb5ff0ef          	jal	170 <__hidden___udivsi3>
 1c0:	00058513          	mv	a0,a1
 1c4:	00028067          	jr	t0
 1c8:	40a00533          	neg	a0,a0
 1cc:	00b04863          	bgtz	a1,1dc <__umodsi3+0x24>
 1d0:	40b005b3          	neg	a1,a1
 1d4:	f9dff06f          	j	170 <__hidden___udivsi3>
 1d8:	40b005b3          	neg	a1,a1
 1dc:	00008293          	mv	t0,ra
 1e0:	f91ff0ef          	jal	170 <__hidden___udivsi3>
 1e4:	40a00533          	neg	a0,a0
 1e8:	00028067          	jr	t0

000001ec <__modsi3>:
 1ec:	00008293          	mv	t0,ra
 1f0:	0005ca63          	bltz	a1,204 <__modsi3+0x18>
 1f4:	00054c63          	bltz	a0,20c <__modsi3+0x20>
 1f8:	f79ff0ef          	jal	170 <__hidden___udivsi3>
 1fc:	00058513          	mv	a0,a1
 200:	00028067          	jr	t0
 204:	40b005b3          	neg	a1,a1
 208:	fe0558e3          	bgez	a0,1f8 <__modsi3+0xc>
 20c:	40a00533          	neg	a0,a0
 210:	f61ff0ef          	jal	170 <__hidden___udivsi3>
 214:	40b00533          	neg	a0,a1
 218:	00028067          	jr	t0
