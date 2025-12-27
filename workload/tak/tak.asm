
tak.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	1a4000ef          	jal	1a8 <main>
   8:	00100073          	ebreak

0000000c <loop>:
   c:	0000006f          	j	c <loop>

00000010 <printInt>:
  10:	fe010113          	addi	sp,sp,-32 # 1ffe0 <judgeResult+0xffdc>
  14:	00112e23          	sw	ra,28(sp)
  18:	00812c23          	sw	s0,24(sp)
  1c:	02010413          	addi	s0,sp,32
  20:	fea42623          	sw	a0,-20(s0)
  24:	000107b7          	lui	a5,0x10
  28:	0047a703          	lw	a4,4(a5) # 10004 <judgeResult>
  2c:	fec42783          	lw	a5,-20(s0)
  30:	00f74733          	xor	a4,a4,a5
  34:	000107b7          	lui	a5,0x10
  38:	00e7a223          	sw	a4,4(a5) # 10004 <judgeResult>
  3c:	000107b7          	lui	a5,0x10
  40:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
  44:	0ad78713          	addi	a4,a5,173
  48:	000107b7          	lui	a5,0x10
  4c:	00e7a223          	sw	a4,4(a5) # 10004 <judgeResult>
  50:	00000013          	nop
  54:	01c12083          	lw	ra,28(sp)
  58:	01812403          	lw	s0,24(sp)
  5c:	02010113          	addi	sp,sp,32
  60:	00008067          	ret

00000064 <printStr>:
  64:	fd010113          	addi	sp,sp,-48
  68:	02112623          	sw	ra,44(sp)
  6c:	02812423          	sw	s0,40(sp)
  70:	03010413          	addi	s0,sp,48
  74:	fca42e23          	sw	a0,-36(s0)
  78:	fdc42783          	lw	a5,-36(s0)
  7c:	fef42623          	sw	a5,-20(s0)
  80:	0440006f          	j	c4 <printStr+0x60>
  84:	fec42783          	lw	a5,-20(s0)
  88:	0007c783          	lbu	a5,0(a5)
  8c:	00078713          	mv	a4,a5
  90:	000107b7          	lui	a5,0x10
  94:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
  98:	00f74733          	xor	a4,a4,a5
  9c:	000107b7          	lui	a5,0x10
  a0:	00e7a223          	sw	a4,4(a5) # 10004 <judgeResult>
  a4:	000107b7          	lui	a5,0x10
  a8:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
  ac:	20978713          	addi	a4,a5,521
  b0:	000107b7          	lui	a5,0x10
  b4:	00e7a223          	sw	a4,4(a5) # 10004 <judgeResult>
  b8:	fec42783          	lw	a5,-20(s0)
  bc:	00178793          	addi	a5,a5,1
  c0:	fef42623          	sw	a5,-20(s0)
  c4:	fec42783          	lw	a5,-20(s0)
  c8:	0007c783          	lbu	a5,0(a5)
  cc:	fa079ce3          	bnez	a5,84 <printStr+0x20>
  d0:	00000013          	nop
  d4:	00000013          	nop
  d8:	02c12083          	lw	ra,44(sp)
  dc:	02812403          	lw	s0,40(sp)
  e0:	03010113          	addi	sp,sp,48
  e4:	00008067          	ret

000000e8 <tak>:
  e8:	fe010113          	addi	sp,sp,-32
  ec:	00112e23          	sw	ra,28(sp)
  f0:	00812c23          	sw	s0,24(sp)
  f4:	00912a23          	sw	s1,20(sp)
  f8:	01212823          	sw	s2,16(sp)
  fc:	02010413          	addi	s0,sp,32
 100:	fea42623          	sw	a0,-20(s0)
 104:	feb42423          	sw	a1,-24(s0)
 108:	fec42223          	sw	a2,-28(s0)
 10c:	fe842703          	lw	a4,-24(s0)
 110:	fec42783          	lw	a5,-20(s0)
 114:	06f75a63          	bge	a4,a5,188 <tak+0xa0>
 118:	fec42783          	lw	a5,-20(s0)
 11c:	fff78793          	addi	a5,a5,-1
 120:	fe442603          	lw	a2,-28(s0)
 124:	fe842583          	lw	a1,-24(s0)
 128:	00078513          	mv	a0,a5
 12c:	fbdff0ef          	jal	e8 <tak>
 130:	00050493          	mv	s1,a0
 134:	fe842783          	lw	a5,-24(s0)
 138:	fff78793          	addi	a5,a5,-1
 13c:	fec42603          	lw	a2,-20(s0)
 140:	fe442583          	lw	a1,-28(s0)
 144:	00078513          	mv	a0,a5
 148:	fa1ff0ef          	jal	e8 <tak>
 14c:	00050913          	mv	s2,a0
 150:	fe442783          	lw	a5,-28(s0)
 154:	fff78793          	addi	a5,a5,-1
 158:	fe842603          	lw	a2,-24(s0)
 15c:	fec42583          	lw	a1,-20(s0)
 160:	00078513          	mv	a0,a5
 164:	f85ff0ef          	jal	e8 <tak>
 168:	00050793          	mv	a5,a0
 16c:	00078613          	mv	a2,a5
 170:	00090593          	mv	a1,s2
 174:	00048513          	mv	a0,s1
 178:	f71ff0ef          	jal	e8 <tak>
 17c:	00050793          	mv	a5,a0
 180:	00178793          	addi	a5,a5,1
 184:	0080006f          	j	18c <tak+0xa4>
 188:	fe442783          	lw	a5,-28(s0)
 18c:	00078513          	mv	a0,a5
 190:	01c12083          	lw	ra,28(sp)
 194:	01812403          	lw	s0,24(sp)
 198:	01412483          	lw	s1,20(sp)
 19c:	01012903          	lw	s2,16(sp)
 1a0:	02010113          	addi	sp,sp,32
 1a4:	00008067          	ret

000001a8 <main>:
 1a8:	fe010113          	addi	sp,sp,-32
 1ac:	00112e23          	sw	ra,28(sp)
 1b0:	00812c23          	sw	s0,24(sp)
 1b4:	02010413          	addi	s0,sp,32
 1b8:	01200793          	li	a5,18
 1bc:	fef42623          	sw	a5,-20(s0)
 1c0:	00c00793          	li	a5,12
 1c4:	fef42423          	sw	a5,-24(s0)
 1c8:	00600793          	li	a5,6
 1cc:	fef42223          	sw	a5,-28(s0)
 1d0:	fe442603          	lw	a2,-28(s0)
 1d4:	fe842583          	lw	a1,-24(s0)
 1d8:	fec42503          	lw	a0,-20(s0)
 1dc:	f0dff0ef          	jal	e8 <tak>
 1e0:	00050793          	mv	a5,a0
 1e4:	00078513          	mv	a0,a5
 1e8:	e29ff0ef          	jal	10 <printInt>
 1ec:	000107b7          	lui	a5,0x10
 1f0:	0047a783          	lw	a5,4(a5) # 10004 <judgeResult>
 1f4:	0fd00713          	li	a4,253
 1f8:	00070593          	mv	a1,a4
 1fc:	00078513          	mv	a0,a5
 200:	0a0000ef          	jal	2a0 <__modsi3>
 204:	00050793          	mv	a5,a0
 208:	00078513          	mv	a0,a5
 20c:	01c12083          	lw	ra,28(sp)
 210:	01812403          	lw	s0,24(sp)
 214:	02010113          	addi	sp,sp,32
 218:	00008067          	ret

0000021c <__divsi3>:
 21c:	06054063          	bltz	a0,27c <__umodsi3+0x10>
 220:	0605c663          	bltz	a1,28c <__umodsi3+0x20>

00000224 <__hidden___udivsi3>:
 224:	00058613          	mv	a2,a1
 228:	00050593          	mv	a1,a0
 22c:	fff00513          	li	a0,-1
 230:	02060c63          	beqz	a2,268 <__hidden___udivsi3+0x44>
 234:	00100693          	li	a3,1
 238:	00b67a63          	bgeu	a2,a1,24c <__hidden___udivsi3+0x28>
 23c:	00c05863          	blez	a2,24c <__hidden___udivsi3+0x28>
 240:	00161613          	slli	a2,a2,0x1
 244:	00169693          	slli	a3,a3,0x1
 248:	feb66ae3          	bltu	a2,a1,23c <__hidden___udivsi3+0x18>
 24c:	00000513          	li	a0,0
 250:	00c5e663          	bltu	a1,a2,25c <__hidden___udivsi3+0x38>
 254:	40c585b3          	sub	a1,a1,a2
 258:	00d56533          	or	a0,a0,a3
 25c:	0016d693          	srli	a3,a3,0x1
 260:	00165613          	srli	a2,a2,0x1
 264:	fe0696e3          	bnez	a3,250 <__hidden___udivsi3+0x2c>
 268:	00008067          	ret

0000026c <__umodsi3>:
 26c:	00008293          	mv	t0,ra
 270:	fb5ff0ef          	jal	224 <__hidden___udivsi3>
 274:	00058513          	mv	a0,a1
 278:	00028067          	jr	t0
 27c:	40a00533          	neg	a0,a0
 280:	00b04863          	bgtz	a1,290 <__umodsi3+0x24>
 284:	40b005b3          	neg	a1,a1
 288:	f9dff06f          	j	224 <__hidden___udivsi3>
 28c:	40b005b3          	neg	a1,a1
 290:	00008293          	mv	t0,ra
 294:	f91ff0ef          	jal	224 <__hidden___udivsi3>
 298:	40a00533          	neg	a0,a0
 29c:	00028067          	jr	t0

000002a0 <__modsi3>:
 2a0:	00008293          	mv	t0,ra
 2a4:	0005ca63          	bltz	a1,2b8 <__modsi3+0x18>
 2a8:	00054c63          	bltz	a0,2c0 <__modsi3+0x20>
 2ac:	f79ff0ef          	jal	224 <__hidden___udivsi3>
 2b0:	00058513          	mv	a0,a1
 2b4:	00028067          	jr	t0
 2b8:	40b005b3          	neg	a1,a1
 2bc:	fe0558e3          	bgez	a0,2ac <__modsi3+0xc>
 2c0:	40a00533          	neg	a0,a0
 2c4:	f61ff0ef          	jal	224 <__hidden___udivsi3>
 2c8:	40b00533          	neg	a0,a1
 2cc:	00028067          	jr	t0
