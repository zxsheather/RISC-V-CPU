
lvalue2.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	0e8000ef          	jal	ec <main>
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

000000ec <main>:
  ec:	fd010113          	addi	sp,sp,-48
  f0:	02112623          	sw	ra,44(sp)
  f4:	02812423          	sw	s0,40(sp)
  f8:	03010413          	addi	s0,sp,48
  fc:	00200793          	li	a5,2
 100:	fef42223          	sw	a5,-28(s0)
 104:	fdc40793          	addi	a5,s0,-36
 108:	fef42623          	sw	a5,-20(s0)
 10c:	fec42783          	lw	a5,-20(s0)
 110:	00878793          	addi	a5,a5,8
 114:	0007a783          	lw	a5,0(a5)
 118:	00078513          	mv	a0,a5
 11c:	ef9ff0ef          	jal	14 <printInt>
 120:	000107b7          	lui	a5,0x10
 124:	0147a783          	lw	a5,20(a5) # 10014 <judgeResult>
 128:	0fd00713          	li	a4,253
 12c:	00070593          	mv	a1,a4
 130:	00078513          	mv	a0,a5
 134:	0a0000ef          	jal	1d4 <__modsi3>
 138:	00050793          	mv	a5,a0
 13c:	00078513          	mv	a0,a5
 140:	02c12083          	lw	ra,44(sp)
 144:	02812403          	lw	s0,40(sp)
 148:	03010113          	addi	sp,sp,48
 14c:	00008067          	ret

00000150 <__divsi3>:
 150:	06054063          	bltz	a0,1b0 <__umodsi3+0x10>
 154:	0605c663          	bltz	a1,1c0 <__umodsi3+0x20>

00000158 <__hidden___udivsi3>:
 158:	00058613          	mv	a2,a1
 15c:	00050593          	mv	a1,a0
 160:	fff00513          	li	a0,-1
 164:	02060c63          	beqz	a2,19c <__hidden___udivsi3+0x44>
 168:	00100693          	li	a3,1
 16c:	00b67a63          	bgeu	a2,a1,180 <__hidden___udivsi3+0x28>
 170:	00c05863          	blez	a2,180 <__hidden___udivsi3+0x28>
 174:	00161613          	slli	a2,a2,0x1
 178:	00169693          	slli	a3,a3,0x1
 17c:	feb66ae3          	bltu	a2,a1,170 <__hidden___udivsi3+0x18>
 180:	00000513          	li	a0,0
 184:	00c5e663          	bltu	a1,a2,190 <__hidden___udivsi3+0x38>
 188:	40c585b3          	sub	a1,a1,a2
 18c:	00d56533          	or	a0,a0,a3
 190:	0016d693          	srli	a3,a3,0x1
 194:	00165613          	srli	a2,a2,0x1
 198:	fe0696e3          	bnez	a3,184 <__hidden___udivsi3+0x2c>
 19c:	00008067          	ret

000001a0 <__umodsi3>:
 1a0:	00008293          	mv	t0,ra
 1a4:	fb5ff0ef          	jal	158 <__hidden___udivsi3>
 1a8:	00058513          	mv	a0,a1
 1ac:	00028067          	jr	t0
 1b0:	40a00533          	neg	a0,a0
 1b4:	00b04863          	bgtz	a1,1c4 <__umodsi3+0x24>
 1b8:	40b005b3          	neg	a1,a1
 1bc:	f9dff06f          	j	158 <__hidden___udivsi3>
 1c0:	40b005b3          	neg	a1,a1
 1c4:	00008293          	mv	t0,ra
 1c8:	f91ff0ef          	jal	158 <__hidden___udivsi3>
 1cc:	40a00533          	neg	a0,a0
 1d0:	00028067          	jr	t0

000001d4 <__modsi3>:
 1d4:	00008293          	mv	t0,ra
 1d8:	0005ca63          	bltz	a1,1ec <__modsi3+0x18>
 1dc:	00054c63          	bltz	a0,1f4 <__modsi3+0x20>
 1e0:	f79ff0ef          	jal	158 <__hidden___udivsi3>
 1e4:	00058513          	mv	a0,a1
 1e8:	00028067          	jr	t0
 1ec:	40b005b3          	neg	a1,a1
 1f0:	fe0558e3          	bgez	a0,1e0 <__modsi3+0xc>
 1f4:	40a00533          	neg	a0,a0
 1f8:	f61ff0ef          	jal	158 <__hidden___udivsi3>
 1fc:	40b00533          	neg	a0,a1
 200:	00028067          	jr	t0
