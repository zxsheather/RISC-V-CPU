
vec_plus.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	0e8000ef          	jal	ec <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <judgeResult+0xf1cc>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000117b7          	lui	a5,0x11
  2c:	e147a703          	lw	a4,-492(a5) # 10e14 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000117b7          	lui	a5,0x11
  3c:	e0e7aa23          	sw	a4,-492(a5) # 10e14 <judgeResult>
  40:	000117b7          	lui	a5,0x11
  44:	e147a783          	lw	a5,-492(a5) # 10e14 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000117b7          	lui	a5,0x11
  50:	e0e7aa23          	sw	a4,-492(a5) # 10e14 <judgeResult>
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
  94:	000117b7          	lui	a5,0x11
  98:	e147a783          	lw	a5,-492(a5) # 10e14 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000117b7          	lui	a5,0x11
  a4:	e0e7aa23          	sw	a4,-492(a5) # 10e14 <judgeResult>
  a8:	000117b7          	lui	a5,0x11
  ac:	e147a783          	lw	a5,-492(a5) # 10e14 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000117b7          	lui	a5,0x11
  b8:	e0e7aa23          	sw	a4,-492(a5) # 10e14 <judgeResult>
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
  fc:	fe042423          	sw	zero,-24(s0)
 100:	fe042623          	sw	zero,-20(s0)
 104:	0500006f          	j	154 <main+0x68>
 108:	000107b7          	lui	a5,0x10
 10c:	00478713          	addi	a4,a5,4 # 10004 <input1_data>
 110:	fec42783          	lw	a5,-20(s0)
 114:	00279793          	slli	a5,a5,0x2
 118:	00f707b3          	add	a5,a4,a5
 11c:	0007a703          	lw	a4,0(a5)
 120:	000107b7          	lui	a5,0x10
 124:	4b478693          	addi	a3,a5,1204 # 104b4 <input2_data>
 128:	fec42783          	lw	a5,-20(s0)
 12c:	00279793          	slli	a5,a5,0x2
 130:	00f687b3          	add	a5,a3,a5
 134:	0007a783          	lw	a5,0(a5)
 138:	00f707b3          	add	a5,a4,a5
 13c:	fef42223          	sw	a5,-28(s0)
 140:	fe442503          	lw	a0,-28(s0)
 144:	ed1ff0ef          	jal	14 <printInt>
 148:	fec42783          	lw	a5,-20(s0)
 14c:	00178793          	addi	a5,a5,1
 150:	fef42623          	sw	a5,-20(s0)
 154:	fec42703          	lw	a4,-20(s0)
 158:	12b00793          	li	a5,299
 15c:	fae7d6e3          	bge	a5,a4,108 <main+0x1c>
 160:	000117b7          	lui	a5,0x11
 164:	e147a783          	lw	a5,-492(a5) # 10e14 <judgeResult>
 168:	0fd00713          	li	a4,253
 16c:	00070593          	mv	a1,a4
 170:	00078513          	mv	a0,a5
 174:	0a0000ef          	jal	214 <__modsi3>
 178:	00050793          	mv	a5,a0
 17c:	00078513          	mv	a0,a5
 180:	01c12083          	lw	ra,28(sp)
 184:	01812403          	lw	s0,24(sp)
 188:	02010113          	addi	sp,sp,32
 18c:	00008067          	ret

00000190 <__divsi3>:
 190:	06054063          	bltz	a0,1f0 <__umodsi3+0x10>
 194:	0605c663          	bltz	a1,200 <__umodsi3+0x20>

00000198 <__hidden___udivsi3>:
 198:	00058613          	mv	a2,a1
 19c:	00050593          	mv	a1,a0
 1a0:	fff00513          	li	a0,-1
 1a4:	02060c63          	beqz	a2,1dc <__hidden___udivsi3+0x44>
 1a8:	00100693          	li	a3,1
 1ac:	00b67a63          	bgeu	a2,a1,1c0 <__hidden___udivsi3+0x28>
 1b0:	00c05863          	blez	a2,1c0 <__hidden___udivsi3+0x28>
 1b4:	00161613          	slli	a2,a2,0x1
 1b8:	00169693          	slli	a3,a3,0x1
 1bc:	feb66ae3          	bltu	a2,a1,1b0 <__hidden___udivsi3+0x18>
 1c0:	00000513          	li	a0,0
 1c4:	00c5e663          	bltu	a1,a2,1d0 <__hidden___udivsi3+0x38>
 1c8:	40c585b3          	sub	a1,a1,a2
 1cc:	00d56533          	or	a0,a0,a3
 1d0:	0016d693          	srli	a3,a3,0x1
 1d4:	00165613          	srli	a2,a2,0x1
 1d8:	fe0696e3          	bnez	a3,1c4 <__hidden___udivsi3+0x2c>
 1dc:	00008067          	ret

000001e0 <__umodsi3>:
 1e0:	00008293          	mv	t0,ra
 1e4:	fb5ff0ef          	jal	198 <__hidden___udivsi3>
 1e8:	00058513          	mv	a0,a1
 1ec:	00028067          	jr	t0
 1f0:	40a00533          	neg	a0,a0
 1f4:	00b04863          	bgtz	a1,204 <__umodsi3+0x24>
 1f8:	40b005b3          	neg	a1,a1
 1fc:	f9dff06f          	j	198 <__hidden___udivsi3>
 200:	40b005b3          	neg	a1,a1
 204:	00008293          	mv	t0,ra
 208:	f91ff0ef          	jal	198 <__hidden___udivsi3>
 20c:	40a00533          	neg	a0,a0
 210:	00028067          	jr	t0

00000214 <__modsi3>:
 214:	00008293          	mv	t0,ra
 218:	0005ca63          	bltz	a1,22c <__modsi3+0x18>
 21c:	00054c63          	bltz	a0,234 <__modsi3+0x20>
 220:	f79ff0ef          	jal	198 <__hidden___udivsi3>
 224:	00058513          	mv	a0,a1
 228:	00028067          	jr	t0
 22c:	40b005b3          	neg	a1,a1
 230:	fe0558e3          	bgez	a0,220 <__modsi3+0xc>
 234:	40a00533          	neg	a0,a0
 238:	f61ff0ef          	jal	198 <__hidden___udivsi3>
 23c:	40b00533          	neg	a0,a1
 240:	00028067          	jr	t0
