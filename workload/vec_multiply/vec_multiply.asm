
vec_multiply.elf：     文件格式 elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00020137          	lui	sp,0x20
   4:	170000ef          	jal	174 <main>
   8:	0ff57513          	zext.b	a0,a0
   c:	00100073          	ebreak

00000010 <loop>:
  10:	0000006f          	j	10 <loop>

00000014 <printInt>:
  14:	fe010113          	addi	sp,sp,-32 # 1ffe0 <judgeResult+0xfb2c>
  18:	00112e23          	sw	ra,28(sp)
  1c:	00812c23          	sw	s0,24(sp)
  20:	02010413          	addi	s0,sp,32
  24:	fea42623          	sw	a0,-20(s0)
  28:	000107b7          	lui	a5,0x10
  2c:	4b47a703          	lw	a4,1204(a5) # 104b4 <judgeResult>
  30:	fec42783          	lw	a5,-20(s0)
  34:	00f74733          	xor	a4,a4,a5
  38:	000107b7          	lui	a5,0x10
  3c:	4ae7aa23          	sw	a4,1204(a5) # 104b4 <judgeResult>
  40:	000107b7          	lui	a5,0x10
  44:	4b47a783          	lw	a5,1204(a5) # 104b4 <judgeResult>
  48:	0ad78713          	addi	a4,a5,173
  4c:	000107b7          	lui	a5,0x10
  50:	4ae7aa23          	sw	a4,1204(a5) # 104b4 <judgeResult>
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
  98:	4b47a783          	lw	a5,1204(a5) # 104b4 <judgeResult>
  9c:	00f74733          	xor	a4,a4,a5
  a0:	000107b7          	lui	a5,0x10
  a4:	4ae7aa23          	sw	a4,1204(a5) # 104b4 <judgeResult>
  a8:	000107b7          	lui	a5,0x10
  ac:	4b47a783          	lw	a5,1204(a5) # 104b4 <judgeResult>
  b0:	20978713          	addi	a4,a5,521
  b4:	000107b7          	lui	a5,0x10
  b8:	4ae7aa23          	sw	a4,1204(a5) # 104b4 <judgeResult>
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

000000ec <multiply>:
  ec:	fd010113          	addi	sp,sp,-48
  f0:	02112623          	sw	ra,44(sp)
  f4:	02812423          	sw	s0,40(sp)
  f8:	03010413          	addi	s0,sp,48
  fc:	fca42e23          	sw	a0,-36(s0)
 100:	fcb42c23          	sw	a1,-40(s0)
 104:	fe042423          	sw	zero,-24(s0)
 108:	fe042623          	sw	zero,-20(s0)
 10c:	0440006f          	j	150 <multiply+0x64>
 110:	fdc42783          	lw	a5,-36(s0)
 114:	0017f793          	andi	a5,a5,1
 118:	00078a63          	beqz	a5,12c <multiply+0x40>
 11c:	fe842703          	lw	a4,-24(s0)
 120:	fd842783          	lw	a5,-40(s0)
 124:	00f707b3          	add	a5,a4,a5
 128:	fef42423          	sw	a5,-24(s0)
 12c:	fdc42783          	lw	a5,-36(s0)
 130:	4017d793          	srai	a5,a5,0x1
 134:	fcf42e23          	sw	a5,-36(s0)
 138:	fd842783          	lw	a5,-40(s0)
 13c:	00179793          	slli	a5,a5,0x1
 140:	fcf42c23          	sw	a5,-40(s0)
 144:	fec42783          	lw	a5,-20(s0)
 148:	00178793          	addi	a5,a5,1
 14c:	fef42623          	sw	a5,-20(s0)
 150:	fec42703          	lw	a4,-20(s0)
 154:	01f00793          	li	a5,31
 158:	fae7dce3          	bge	a5,a4,110 <multiply+0x24>
 15c:	fe842783          	lw	a5,-24(s0)
 160:	00078513          	mv	a0,a5
 164:	02c12083          	lw	ra,44(sp)
 168:	02812403          	lw	s0,40(sp)
 16c:	03010113          	addi	sp,sp,48
 170:	00008067          	ret

00000174 <main>:
 174:	fe010113          	addi	sp,sp,-32
 178:	00112e23          	sw	ra,28(sp)
 17c:	00812c23          	sw	s0,24(sp)
 180:	02010413          	addi	s0,sp,32
 184:	fe042423          	sw	zero,-24(s0)
 188:	fe042623          	sw	zero,-20(s0)
 18c:	0580006f          	j	1e4 <main+0x70>
 190:	000107b7          	lui	a5,0x10
 194:	00478713          	addi	a4,a5,4 # 10004 <input_data1>
 198:	fec42783          	lw	a5,-20(s0)
 19c:	00279793          	slli	a5,a5,0x2
 1a0:	00f707b3          	add	a5,a4,a5
 1a4:	0007a683          	lw	a3,0(a5)
 1a8:	000107b7          	lui	a5,0x10
 1ac:	19478713          	addi	a4,a5,404 # 10194 <input_data2>
 1b0:	fec42783          	lw	a5,-20(s0)
 1b4:	00279793          	slli	a5,a5,0x2
 1b8:	00f707b3          	add	a5,a4,a5
 1bc:	0007a783          	lw	a5,0(a5)
 1c0:	00078593          	mv	a1,a5
 1c4:	00068513          	mv	a0,a3
 1c8:	f25ff0ef          	jal	ec <multiply>
 1cc:	fea42223          	sw	a0,-28(s0)
 1d0:	fe442503          	lw	a0,-28(s0)
 1d4:	e41ff0ef          	jal	14 <printInt>
 1d8:	fec42783          	lw	a5,-20(s0)
 1dc:	00178793          	addi	a5,a5,1
 1e0:	fef42623          	sw	a5,-20(s0)
 1e4:	fec42703          	lw	a4,-20(s0)
 1e8:	06300793          	li	a5,99
 1ec:	fae7d2e3          	bge	a5,a4,190 <main+0x1c>
 1f0:	000107b7          	lui	a5,0x10
 1f4:	4b47a783          	lw	a5,1204(a5) # 104b4 <judgeResult>
 1f8:	0fd00713          	li	a4,253
 1fc:	00070593          	mv	a1,a4
 200:	00078513          	mv	a0,a5
 204:	0a0000ef          	jal	2a4 <__modsi3>
 208:	00050793          	mv	a5,a0
 20c:	00078513          	mv	a0,a5
 210:	01c12083          	lw	ra,28(sp)
 214:	01812403          	lw	s0,24(sp)
 218:	02010113          	addi	sp,sp,32
 21c:	00008067          	ret

00000220 <__divsi3>:
 220:	06054063          	bltz	a0,280 <__umodsi3+0x10>
 224:	0605c663          	bltz	a1,290 <__umodsi3+0x20>

00000228 <__hidden___udivsi3>:
 228:	00058613          	mv	a2,a1
 22c:	00050593          	mv	a1,a0
 230:	fff00513          	li	a0,-1
 234:	02060c63          	beqz	a2,26c <__hidden___udivsi3+0x44>
 238:	00100693          	li	a3,1
 23c:	00b67a63          	bgeu	a2,a1,250 <__hidden___udivsi3+0x28>
 240:	00c05863          	blez	a2,250 <__hidden___udivsi3+0x28>
 244:	00161613          	slli	a2,a2,0x1
 248:	00169693          	slli	a3,a3,0x1
 24c:	feb66ae3          	bltu	a2,a1,240 <__hidden___udivsi3+0x18>
 250:	00000513          	li	a0,0
 254:	00c5e663          	bltu	a1,a2,260 <__hidden___udivsi3+0x38>
 258:	40c585b3          	sub	a1,a1,a2
 25c:	00d56533          	or	a0,a0,a3
 260:	0016d693          	srli	a3,a3,0x1
 264:	00165613          	srli	a2,a2,0x1
 268:	fe0696e3          	bnez	a3,254 <__hidden___udivsi3+0x2c>
 26c:	00008067          	ret

00000270 <__umodsi3>:
 270:	00008293          	mv	t0,ra
 274:	fb5ff0ef          	jal	228 <__hidden___udivsi3>
 278:	00058513          	mv	a0,a1
 27c:	00028067          	jr	t0
 280:	40a00533          	neg	a0,a0
 284:	00b04863          	bgtz	a1,294 <__umodsi3+0x24>
 288:	40b005b3          	neg	a1,a1
 28c:	f9dff06f          	j	228 <__hidden___udivsi3>
 290:	40b005b3          	neg	a1,a1
 294:	00008293          	mv	t0,ra
 298:	f91ff0ef          	jal	228 <__hidden___udivsi3>
 29c:	40a00533          	neg	a0,a0
 2a0:	00028067          	jr	t0

000002a4 <__modsi3>:
 2a4:	00008293          	mv	t0,ra
 2a8:	0005ca63          	bltz	a1,2bc <__modsi3+0x18>
 2ac:	00054c63          	bltz	a0,2c4 <__modsi3+0x20>
 2b0:	f79ff0ef          	jal	228 <__hidden___udivsi3>
 2b4:	00058513          	mv	a0,a1
 2b8:	00028067          	jr	t0
 2bc:	40b005b3          	neg	a1,a1
 2c0:	fe0558e3          	bgez	a0,2b0 <__modsi3+0xc>
 2c4:	40a00533          	neg	a0,a0
 2c8:	f61ff0ef          	jal	228 <__hidden___udivsi3>
 2cc:	40b00533          	neg	a0,a1
 2d0:	00028067          	jr	t0
