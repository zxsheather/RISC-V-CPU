from assassyn.frontend import *
from instruction import *


class ALU(Module):
    def __init__(self):
        super().__init__(
            ports={
                "op_from_rs": Port(Bits(RV32I_ALU.CNT)),
                "alu_valid_from_rs": Port(Bits(1)),
                "alu_a_from_rs": Port(Bits(32)),
                "alu_b_from_rs": Port(Bits(32)),
                "rob_idx_from_rs": Port(Bits(32)),
            }
        )
        self.name = "ALU"

    @module.combinational
    def build(self, value_to_rob: Array, index_to_rob: Array, valid_to_rob: Array):
        op_from_rob, alu_valid_from_rob, alu_a, alu_b, rob_idx_from_rob = (
            self.pop_all_ports(False)
        )

        results = [Bits(32)(0)] * RV32I_ALU.CNT

        results[RV32I_ALU.ALU_ADD] = (
            alu_a.bitcast(Int(32)) + alu_b.bitcast(Int(32))
        ).bitcast(Bits(32))
        results[RV32I_ALU.ALU_SUB] = (
            alu_a.bitcast(Int(32)) - alu_b.bitcast(Int(32))
        ).bitcast(Bits(32))
        results[RV32I_ALU.ALU_SLL] = alu_a << alu_b[0:4]
        results[RV32I_ALU.ALU_SRA] = (
            alu_a.bitcast(Int(32)) >> alu_b[0:4].bitcast(Int(5))
        ).bitcast(Bits(32))
        results[RV32I_ALU.ALU_SRL] = alu_a >> alu_b[0:4]
        results[RV32I_ALU.ALU_AND] = alu_a & alu_b
        results[RV32I_ALU.ALU_OR] = alu_a | alu_b
        results[RV32I_ALU.ALU_XOR] = alu_a ^ alu_b
        results[RV32I_ALU.ALU_TRUE] = Bits(32)(1)
        results[RV32I_ALU.ALU_NONE] = Bits(32)(0)
        results[RV32I_ALU.ALU_CMP_EQ] = (alu_a == alu_b).select(
            Bits(32)(1), Bits(32)(0)
        )
        results[RV32I_ALU.ALU_CMP_LT] = (
            alu_a.bitcast(Int(32)) < alu_b.bitcast(Int(32))
        ).select(Bits(32)(1), Bits(32)(0))
        results[RV32I_ALU.ALU_CMP_LTU] = (alu_a < alu_b).select(
            Bits(32)(1), Bits(32)(0)
        )

        # It's a hack to avoid invalid selct1hot behavior when alu_valid_from_rob is 0
        safe_op = alu_valid_from_rob.select(op_from_rob, Bits(RV32I_ALU.CNT)(1))

        alu_result = safe_op.select1hot(*results)

        alu_result = alu_valid_from_rob.select(alu_result, Bits(32)(0))
        with Condition(alu_valid_from_rob):
            log(
                "ALU alu={}, a=0x{:08x}, b=0x{:08x} => result=0x{:08x}",
                op_from_rob.bitcast(UInt(RV32I_ALU.CNT)),
                alu_a,
                alu_b,
                alu_result,
            )

        valid_to_rob[0] = alu_valid_from_rob
        value_to_rob[0] = alu_result
        index_to_rob[0] = rob_idx_from_rob
