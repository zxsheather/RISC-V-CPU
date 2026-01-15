"""
Radix-4 Booth Multiplier (32-bit) with 4-stage Pipeline
========================================================

Simplified implementation using basic multiplication approach per partial product,
then using adder tree for accumulation.

Pipeline structure (4 cycles total):
  - Stage 1: Generate 16 partial products with Booth encoding
  - Stage 2: First level compression (16 -> 8)
  - Stage 3: Second level compression (8 -> 2)
  - Stage 4: Final addition
"""

import assassyn
from assassyn import utils
from assassyn.backend import elaborate
from assassyn.frontend import *

from .instruction import *
from .utils import Logger, MulLogEnabled


class BoothEncoder(Module):
    """
    Stage 1: Booth Encoding and Partial Product Generation

    Radix-4 Booth encoding examines 3 bits at a time:
    [b_{2i+1}, b_{2i}, b_{2i-1}]

    Encoding table:
    000 -> 0    001 -> +A   010 -> +A   011 -> +2A
    100 -> -2A  101 -> -A   110 -> -A   111 -> 0
    """

    def __init__(self):
        super().__init__(
            ports={
                "a": Port(Bits(32)),
                "b": Port(Bits(32)),
                "alu": Port(Bits(RV32I_ALU.CNT)),
                "tag": Port(Bits(32)),
                "valid": Port(Bits(1)),
            }
        )
        self.log = Logger(enabled=MulLogEnabled)
        self.name = "BE"

    @module.combinational
    def build(self, stage2: "CompressStage1"):
        a, b, alu, tag, valid = self.pop_all_ports(False)
        with Condition(valid):
            self.log("Booth Encoding: a=0x{:08x}, b=0x{:08x}, alu={}", a, b, alu)

        # Convert to unsigned for bit manipulation
        a_u = a.bitcast(UInt(32))
        b_u = b.bitcast(UInt(32))

        # Determine signedness
        is_mul = alu[RV32I_ALU.ALU_MUL : RV32I_ALU.ALU_MUL]
        is_mulh = alu[RV32I_ALU.ALU_MULH : RV32I_ALU.ALU_MULH]
        is_mulhsu = alu[RV32I_ALU.ALU_MULHSU : RV32I_ALU.ALU_MULHSU]
        is_mulhu = alu[RV32I_ALU.ALU_MULHU : RV32I_ALU.ALU_MULHU]

        is_a_signed = is_mul | is_mulh | is_mulhsu
        is_b_signed = is_mul | is_mulh

        # Sign extend A to 64 bits for safe arithmetic
        a_sign = a_u[31:31] & is_a_signed
        a_ext_hi = a_sign.select(UInt(32)(0xFFFFFFFF), UInt(32)(0))
        a_64 = concat(a_ext_hi, a_u).bitcast(Int(64))

        # 2*A using addition
        a_2x = (a_64 << Bits(1)(1)).bitcast(Int(64))

        # -A and -2A
        neg_a = Int(64)(0) - a_64
        neg_2a = Int(64)(0) - a_2x

        # Prepare B with implicit b_{-1} = 0
        # We need to access bits at positions 2i-1, 2i, 2i+1 for each i
        # b_ext = {b[31], b[31:0], 0} = 34 bits
        b_sign = b_u[31:31]
        eff_b_sign = b_sign & is_b_signed
        b_ext = concat(eff_b_sign, b_u, UInt(1)(0)).bitcast(UInt(34))

        # Correction for unsigned B
        # If B is unsigned and B[31] is 1, we need to add A << 32
        needs_correction = (~is_b_signed) & b_sign
        correction = needs_correction.select((a_64 << Bits(6)(32)).bitcast(Int(64)), Int(64)(0))

        # Generate 16 partial products
        pp_list = []

        for i in range(16):
            # Position in b_ext
            pos = 2 * i

            # Extract 3 bits: b_{2i-1}, b_{2i}, b_{2i+1}
            bit0 = b_ext[pos:pos]  # b_{2i-1}
            bit1 = b_ext[pos + 1 : pos + 1]  # b_{2i}
            bit2 = b_ext[pos + 2 : pos + 2]  # b_{2i+1}

            # Form 3-bit encoding value for easier decoding
            # enc = bit2*4 + bit1*2 + bit0
            enc = concat(bit2, bit1, bit0).bitcast(UInt(3))

            # Booth decoding using select chain
            # 000=0, 001=+A, 010=+A, 011=+2A, 100=-2A, 101=-A, 110=-A, 111=0

            pp = enc.case(
                {
                    UInt(3)(1): a_64,
                    UInt(3)(2): a_64,
                    UInt(3)(3): a_2x,
                    UInt(3)(4): neg_2a,
                    UInt(3)(5): neg_a,
                    UInt(3)(6): neg_a,
                }
                | {None: Int(64)(0)}
            )
            # 000 and 111 remain 0

            # Shift left by 2*i for proper weight
            # shift returns Bits, so we bitcast back to Int
            shift_amt = UInt(6)(2 * i)
            pp_shifted = (pp << shift_amt).bitcast(Int(64))

            pp_list.append(pp_shifted)

        stage2.async_called(
            pp0=pp_list[0],
            pp1=pp_list[1],
            pp2=pp_list[2],
            pp3=pp_list[3],
            pp4=pp_list[4],
            pp5=pp_list[5],
            pp6=pp_list[6],
            pp7=pp_list[7],
            pp8=pp_list[8],
            pp9=pp_list[9],
            pp10=pp_list[10],
            pp11=pp_list[11],
            pp12=pp_list[12],
            pp13=pp_list[13],
            pp14=pp_list[14],
            pp15=pp_list[15],
            alu=alu,
            tag=tag,
            correction=correction,
            valid=valid,
        )


class CompressStage1(Module):
    """Stage 2: 16 -> 8 compression"""

    def __init__(self):
        super().__init__(
            ports={
                "pp0": Port(Int(64)),
                "pp1": Port(Int(64)),
                "pp2": Port(Int(64)),
                "pp3": Port(Int(64)),
                "pp4": Port(Int(64)),
                "pp5": Port(Int(64)),
                "pp6": Port(Int(64)),
                "pp7": Port(Int(64)),
                "pp8": Port(Int(64)),
                "pp9": Port(Int(64)),
                "pp10": Port(Int(64)),
                "pp11": Port(Int(64)),
                "pp12": Port(Int(64)),
                "pp13": Port(Int(64)),
                "pp14": Port(Int(64)),
                "pp15": Port(Int(64)),
                "alu": Port(Bits(RV32I_ALU.CNT)),
                "tag": Port(Bits(32)),
                "correction": Port(Int(64)),
                "valid": Port(Bits(1)),
            }
        )

    @module.combinational
    def build(self, stage3: "CompressStage2"):
        (
            pp0,
            pp1,
            pp2,
            pp3,
            pp4,
            pp5,
            pp6,
            pp7,
            pp8,
            pp9,
            pp10,
            pp11,
            pp12,
            pp13,
            pp14,
            pp15,
            alu,
            tag,
            correction,
            valid,
        ) = self.pop_all_ports(True)

        s0 = pp0 + pp1
        s1 = pp2 + pp3
        s2 = pp4 + pp5
        s3 = pp6 + pp7
        s4 = pp8 + pp9
        s5 = pp10 + pp11
        s6 = pp12 + pp13
        s7 = pp14 + pp15

        stage3.async_called(
            s0=s0,
            s1=s1,
            s2=s2,
            s3=s3,
            s4=s4,
            s5=s5,
            s6=s6,
            s7=s7,
            alu=alu,
            tag=tag,
            correction=correction,
            valid=valid,
        )


class CompressStage2(Module):
    """Stage 3: 8 -> 2 compression"""

    def __init__(self):
        super().__init__(
            ports={
                "s0": Port(Int(64)),
                "s1": Port(Int(64)),
                "s2": Port(Int(64)),
                "s3": Port(Int(64)),
                "s4": Port(Int(64)),
                "s5": Port(Int(64)),
                "s6": Port(Int(64)),
                "s7": Port(Int(64)),
                "alu": Port(Bits(RV32I_ALU.CNT)),
                "tag": Port(Bits(32)),
                "correction": Port(Int(64)),
                "valid": Port(Bits(1)),
            }
        )

    @module.combinational
    def build(self, stage4: "FinalAdder"):
        s0, s1, s2, s3, s4, s5, s6, s7, alu, tag, correction, valid = self.pop_all_ports(True)

        t0 = s0 + s1
        t1 = s2 + s3
        t2 = s4 + s5
        t3 = s6 + s7

        u0 = t0 + t1
        u1 = t2 + t3

        stage4.async_called(u0=u0, u1=u1, alu=alu, tag=tag, correction=correction, valid=valid)


class FinalAdder(Module):
    """Stage 4: Final addition"""

    def __init__(self):
        super().__init__(
            ports={
                "u0": Port(Int(64)),
                "u1": Port(Int(64)),
                "alu": Port(Bits(RV32I_ALU.CNT)),
                "tag": Port(Bits(32)),
                "correction": Port(Int(64)),
                "valid": Port(Bits(1)),
            }
        )
        self.log = Logger(enabled=MulLogEnabled)
        self.name = "FA"

    @module.combinational
    def build(self, result: Array, tag_out: Array, valid_out: Array):
        u0, u1, alu, tag, correction, valid = self.pop_all_ports(True)

        with Condition(valid):
            self.log(
                "Final Addition: u0=0x{:016x}, u1=0x{:016x}, correction=0x{:016x}, alu={}",
                u0,
                u1,
                correction,
                alu,
            )

        # Final addition including correction for unsigned multiplication
        raw_result = u0 + u1 + correction

        # Extract lower and upper 32 bits
        res_lo = raw_result[0:31].bitcast(Bits(32))
        res_hi = raw_result[32:63].bitcast(Bits(32))

        # Select result based on ALU opcode
        is_mul = alu[RV32I_ALU.ALU_MUL : RV32I_ALU.ALU_MUL]

        final_val = is_mul.select(res_lo, res_hi)

        result[0] = final_val
        tag_out[0] = tag
        valid_out[0] = valid

        with Condition(valid):
            self.log(
                "Result: tag={}, val=0x{:08x}, valid={}, is_mul={}", tag, final_val, valid, is_mul
            )
