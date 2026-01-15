"""
Signed/Unsigned Division (32-bit) with 4-stage Pipeline
========================================================

This is a divider that supports:
1. Both signed (Int) and unsigned (UInt) division
2. Proper handling of negative numbers
3. Correct rounding toward zero (truncation)

Algorithm:
- Convert signed operands to unsigned (absolute values)
- Perform unsigned division using restoring algorithm
- Adjust result signs based on operand signs

Pipeline stages:
- Stage 1: Sign handling + iterations 31-24 (8 iterations)
- Stage 2: Iterations 23-16 (8 iterations)
- Stage 3: Iterations 15-8 (8 iterations)
- Stage 4: Iterations 7-0 (8 iterations) + result sign adjustment

Each stage produces 8 bits of the quotient.
"""

import assassyn
from assassyn import utils
from assassyn.backend import elaborate
from assassyn.frontend import *

from .instruction import *
from .utils import DivLogEnabled, Logger


def div_iteration(r: Value, divisor: Value, q_bit_out: list) -> Value:
    """
    Single iteration of restoring division.
    """
    # Shift R left by 1
    r_shifted = (r << Bits(1)(1)).bitcast(UInt(64))

    # Extract upper 32 bits (partial remainder)
    r_upper = r_shifted[32:63].bitcast(UInt(32))
    r_lower = r_shifted[0:31].bitcast(UInt(32))

    # Extend to 64 bits for safe subtraction
    r_upper_64 = concat(UInt(32)(0), r_upper).bitcast(UInt(64))
    divisor_64 = concat(UInt(32)(0), divisor).bitcast(UInt(64))

    # Subtraction in 64 bits
    diff_64 = r_upper_64 - divisor_64

    # Extract bit 32 as borrow flag as Bits(1)
    borrow = diff_64[32:32]  # This is Bits(1)
    diff = diff_64[0:31].bitcast(UInt(32))

    # When borrow=0 (can subtract): use diff, q=1
    # When borrow=1 (cannot subtract): use r_upper, q=0
    new_upper = borrow.select(r_upper, diff)  # borrow ? r_upper : diff
    q_bit = borrow.select(UInt(1)(0), UInt(1)(1))  # borrow ? 0 : 1
    q_bit_out.append(q_bit)

    # Reconstruct R
    new_r = concat(new_upper, r_lower).bitcast(UInt(64))
    return new_r


class DivStage1(Module):
    """
    Stage 1: Sign handling + process bits 31-24 (8 iterations)
    Interface similar to BoothEncoder for multiplier.
    """

    def __init__(self):
        super().__init__(
            ports={
                "a": Port(Bits(32)),  # dividend
                "b": Port(Bits(32)),  # divisor
                "alu": Port(Bits(RV32I_ALU.CNT)),
                "tag": Port(Bits(32)),
                "valid": Port(Bits(1)),
            }
        )
        self.log = Logger(enabled=DivLogEnabled)
        self.name = "DIV1"

    @module.combinational
    def build(self, stage2: "DivStage2"):
        a, b, alu, tag, valid = self.pop_all_ports(False)

        with Condition(valid):
            self.log("Div Stage1: a=0x{:08x}, b=0x{:08x}, alu={}", a, b, alu)

        dividend = a.bitcast(Int(32))
        divisor = b.bitcast(Int(32))

        # Determine operation type
        is_div = alu[RV32I_ALU.ALU_DIV : RV32I_ALU.ALU_DIV]
        is_divu = alu[RV32I_ALU.ALU_DIVU : RV32I_ALU.ALU_DIVU]
        is_rem = alu[RV32I_ALU.ALU_REM : RV32I_ALU.ALU_REM]
        is_remu = alu[RV32I_ALU.ALU_REMU : RV32I_ALU.ALU_REMU]

        # Signed operations are DIV and REM
        is_signed = is_div | is_rem
        # Remainder operations are REM and REMU
        is_remainder = is_rem | is_remu

        # Extract sign bits (MSB)
        dividend_sign = dividend[31:31]  # Bits(1)
        divisor_sign = divisor[31:31]  # Bits(1)

        # Compute absolute values for signed division
        dividend_u = dividend.bitcast(UInt(32))
        divisor_u = divisor.bitcast(UInt(32))

        # Negate using subtraction from 0
        dividend_neg = (UInt(32)(0) - dividend_u).bitcast(UInt(32))
        divisor_neg = (UInt(32)(0) - divisor_u).bitcast(UInt(32))

        # Select absolute value based on sign (only for signed mode)
        use_neg_dividend = is_signed & dividend_sign
        use_neg_divisor = is_signed & divisor_sign

        abs_dividend = use_neg_dividend.select(dividend_neg, dividend_u)
        abs_divisor = use_neg_divisor.select(divisor_neg, divisor_u)

        # Compute result signs (XOR of signs, only for signed mode)
        quotient_sign_raw = dividend_sign ^ divisor_sign  # Bits(1)
        quotient_sign = is_signed & quotient_sign_raw
        remainder_sign = is_signed & dividend_sign

        # Initialize working register R: {0, dividend}
        r_init = concat(UInt(32)(0), abs_dividend).bitcast(UInt(64))

        # Perform 8 iterations for bits 31-24
        q_bits = []
        r = r_init
        for _ in range(8):
            r = div_iteration(r, abs_divisor, q_bits)

        # Concatenate quotient bits (MSB first)
        q_hi = q_bits[0]
        for i in range(1, 8):
            q_hi = concat(q_hi, q_bits[i])
        q_hi = q_hi.bitcast(UInt(8))

        stage2.async_called(
            r=r,
            divisor=abs_divisor,
            q_hi=q_hi,
            quotient_sign=quotient_sign,
            remainder_sign=remainder_sign,
            is_remainder=is_remainder,
            alu=alu,
            tag=tag,
            valid=valid,
        )


class DivStage2(Module):
    """Stage 2: Process bits 23-16 (8 iterations)"""

    def __init__(self):
        super().__init__(
            ports={
                "r": Port(UInt(64)),
                "divisor": Port(UInt(32)),
                "q_hi": Port(UInt(8)),
                "quotient_sign": Port(Bits(1)),
                "remainder_sign": Port(Bits(1)),
                "is_remainder": Port(Bits(1)),
                "alu": Port(Bits(RV32I_ALU.CNT)),
                "tag": Port(Bits(32)),
                "valid": Port(Bits(1)),
            }
        )
        self.log = Logger(enabled=DivLogEnabled)
        self.name = "DIV2"

    @module.combinational
    def build(self, stage3: "DivStage3"):
        (r, divisor, q_hi, quotient_sign, remainder_sign, is_remainder, alu, tag, valid) = (
            self.pop_all_ports(True)
        )

        # Perform 8 iterations for bits 23-16
        q_bits = []
        for _ in range(8):
            r = div_iteration(r, divisor, q_bits)

        # Concatenate quotient bits
        q_mid_hi = q_bits[0]
        for i in range(1, 8):
            q_mid_hi = concat(q_mid_hi, q_bits[i])
        q_mid_hi = q_mid_hi.bitcast(UInt(8))

        # Combine with previous quotient bits
        q_upper = concat(q_hi, q_mid_hi).bitcast(UInt(16))

        stage3.async_called(
            r=r,
            divisor=divisor,
            q_upper=q_upper,
            quotient_sign=quotient_sign,
            remainder_sign=remainder_sign,
            is_remainder=is_remainder,
            alu=alu,
            tag=tag,
            valid=valid,
        )


class DivStage3(Module):
    """Stage 3: Process bits 15-8 (8 iterations)"""

    def __init__(self):
        super().__init__(
            ports={
                "r": Port(UInt(64)),
                "divisor": Port(UInt(32)),
                "q_upper": Port(UInt(16)),
                "quotient_sign": Port(Bits(1)),
                "remainder_sign": Port(Bits(1)),
                "is_remainder": Port(Bits(1)),
                "alu": Port(Bits(RV32I_ALU.CNT)),
                "tag": Port(Bits(32)),
                "valid": Port(Bits(1)),
            }
        )
        self.log = Logger(enabled=DivLogEnabled)
        self.name = "DIV3"

    @module.combinational
    def build(self, stage4: "DivStage4"):
        (r, divisor, q_upper, quotient_sign, remainder_sign, is_remainder, alu, tag, valid) = (
            self.pop_all_ports(True)
        )

        # Perform 8 iterations for bits 15-8
        q_bits = []
        for _ in range(8):
            r = div_iteration(r, divisor, q_bits)

        # Concatenate quotient bits
        q_mid_lo = q_bits[0]
        for i in range(1, 8):
            q_mid_lo = concat(q_mid_lo, q_bits[i])
        q_mid_lo = q_mid_lo.bitcast(UInt(8))

        # Combine with previous quotient bits
        q_upper24 = concat(q_upper, q_mid_lo).bitcast(UInt(24))

        stage4.async_called(
            r=r,
            divisor=divisor,
            q_upper24=q_upper24,
            quotient_sign=quotient_sign,
            remainder_sign=remainder_sign,
            is_remainder=is_remainder,
            alu=alu,
            tag=tag,
            valid=valid,
        )


class DivStage4(Module):
    """Stage 4: Process bits 7-0 (8 iterations) + sign adjustment + output"""

    def __init__(self):
        super().__init__(
            ports={
                "r": Port(UInt(64)),
                "divisor": Port(UInt(32)),
                "q_upper24": Port(UInt(24)),
                "quotient_sign": Port(Bits(1)),
                "remainder_sign": Port(Bits(1)),
                "is_remainder": Port(Bits(1)),
                "alu": Port(Bits(RV32I_ALU.CNT)),
                "tag": Port(Bits(32)),
                "valid": Port(Bits(1)),
            }
        )
        self.log = Logger(enabled=DivLogEnabled)
        self.name = "DIV4"

    @module.combinational
    def build(self, div_result: Array, div_tag_out: Array, div_valid_out: Array):
        (r, divisor, q_upper24, quotient_sign, remainder_sign, is_remainder, alu, tag, valid) = (
            self.pop_all_ports(True)
        )

        # Perform 8 iterations for bits 7-0
        q_bits = []
        for _ in range(8):
            r = div_iteration(r, divisor, q_bits)

        # Concatenate quotient bits
        q_lo = q_bits[0]
        for i in range(1, 8):
            q_lo = concat(q_lo, q_bits[i])
        q_lo = q_lo.bitcast(UInt(8))

        # Final quotient (32 bits)
        quotient_u = concat(q_upper24, q_lo).bitcast(UInt(32))

        # Final remainder (upper 32 bits of R after all iterations)
        remainder_u = r[32:63].bitcast(UInt(32))

        # Apply signs for signed division using subtraction from 0
        quotient_neg = (UInt(32)(0) - quotient_u).bitcast(UInt(32))
        quotient_final = quotient_sign.select(quotient_neg, quotient_u)

        remainder_neg = (UInt(32)(0) - remainder_u).bitcast(UInt(32))
        remainder_final = remainder_sign.select(remainder_neg, remainder_u)

        # Select result based on operation type (quotient vs remainder)
        final_val = is_remainder.select(
            remainder_final.bitcast(Bits(32)), quotient_final.bitcast(Bits(32))
        )

        div_result[0] = final_val
        div_tag_out[0] = tag
        div_valid_out[0] = valid

        with Condition(valid):
            self.log("Div Result: tag={}, val=0x{:08x}, is_rem={}", tag, final_val, is_remainder)
