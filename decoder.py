from assassyn.frontend import *
from instruction import *


class Decoder(Module):
    def __init__(self):
        super().__init__(
            ports={
                "inst_valid_from_fi": Port(Bits(1)),
                "fetch_pc_from_fi": Port(Bits(32)),
            }
        )
        self.name = "D"

    @module.combinational
    def build(self, inst_from_icache: Array, rs: Module):
        inst_valid_from_fi, fetch_pc_from_fi = self.pop_all_ports(False)

        inst = inst_from_icache[0].bitcast(Bits(32))

        log(
            "valid={}, inst=0x{:08x}, pc=0x{:08x}",
            inst_valid_from_fi.bitcast(UInt(5)),
            inst,
            fetch_pc_from_fi.bitcast(UInt(5)),
        )

        signals = decode_logic(inst=inst)
        log(
            "memory={}, alu={}, cond={}, flip={}, is_branch={}, rs1=x{:02}, rs2=x{:02}, rd=x{:02}, imm=0x{:08x}, is_offset_br={}, link_pc={}, mem_oper_size={}, mem_oper_signed={}, is_pc_calc={}",
            signals.memory.bitcast(UInt(2)),
            signals.alu.bitcast(UInt(RV32I_ALU.CNT)),
            signals.cond.bitcast(UInt(RV32I_ALU.CNT)),
            signals.flip.bitcast(UInt(1)),
            signals.is_branch.bitcast(UInt(1)),
            signals.rs1,
            signals.rs2,
            signals.rd,
            signals.imm,
            signals.is_offset_br.bitcast(UInt(1)),
            signals.link_pc.bitcast(UInt(1)),
            signals.mem_oper_size.bitcast(UInt(2)),
            signals.mem_oper_signed.bitcast(UInt(1)),
            signals.is_pc_calc.bitcast(UInt(1)),
        )

        rs.async_called(
            decode_signals=signals,
            has_entry_from_d=inst_valid_from_fi,
            # alu_from_d=signals.alu,
            # alu_valid_from_d=signals.alu_valid,
            # memory_from_d=signals.memory,
            # memory_oper_size_from_d=signals.mem_oper_size,
            # memory_oper_signed_from_d=signals.mem_oper_signed,
            # rd_from_d=signals.rd,
            # rd_valid_from_d=signals.rd_valid,
            # rs1_from_d=signals.rs1,
            # rs1_valid_from_d=signals.rs1_valid,
            # rs2_from_d=signals.rs2,
            # rs2_valid_from_d=signals.rs2_valid,
            # imm_from_d=signals.imm,
            # imm_valid_from_d=signals.imm_valid,
            pc_from_d=fetch_pc_from_fi,
            jump_from_d=Bits(1)(0),
        )


@rewrite_assign
def decode_logic(inst):
    """Impl decode logic, return decode_signal"""

    views = {i: i(inst) for i in supported_types}
    is_type = {i: Bits(1)(0) for i in supported_types}

    eqs = {}

    rs1_valid = Bits(1)(0)
    rs2_valid = Bits(1)(0)
    rd_valid = Bits(1)(0)
    imm_valid = Bits(1)(0)
    supported = Bits(1)(0)

    alu = Bits(RV32I_ALU.CNT)(0)
    cond = Bits(RV32I_ALU.CNT)(0)
    flip = Bits(1)(0)
    is_branch = Bits(1)(0)

    for name, args, cur_type in supported_opcodes:

        ri = views[cur_type]
        signal = ri.decode(*args)
        eq = signal.eq
        is_type[cur_type] |= eq
        eqs[name] = eq
        supported |= eq

        alu |= signal.alu & eq
        cond |= signal.cond & eq
        flip |= signal.flip & eq

        pad = 6 - len(name)
        pad = " " * pad

        fmt = None
        opcode = args[0]
        str_opcode = bin(opcode)[2:].zfill(7)
        fmt = f"{cur_type.PREFIX}.{name}.{str_opcode}{pad}"

        args = []

        if ri.has_rd:
            fmt += "| rd: x{:02}      "
            args.append(ri.view().rd)
            rd_valid |= eq
        else:
            fmt += "|              "

        if ri.has_rs1:
            fmt += "| rs1: x{:02}     "
            args.append(ri.view().rs1)
            rs1_valid |= eq
        else:
            fmt += "|              "

        if ri.has_rs2:
            fmt += "| rs2: x{:02}     "
            args.append(ri.view().rs2)
            rs2_valid |= eq
        else:
            fmt += "|              "

        imm = ri.imm(False)
        if imm is not None:
            fmt += "| imm: 0x{:08x}  "
            args.append(imm)

        with Condition(eq):
            log(fmt, *args)

    alu_valid = (alu == Bits(RV32I_ALU.CNT)(0)).select(
        Bits(1)(0), Bits(1)(1)
    )

    memory = concat(
        eqs["sb"] | eqs["sh"] | eqs["sw"],
        eqs["lb"] | eqs["lh"] | eqs["lw"] | eqs["lbu"] | eqs["lhu"],
    )

    is_half = eqs["lh"] | eqs["lhu"] | eqs["sh"]
    is_word = eqs["lw"] | eqs["sw"]

    mem_oper_size = Bits(2)(0)
    mem_oper_size = is_half.select(Bits(2)(1), mem_oper_size)
    mem_oper_size = is_word.select(Bits(2)(2), mem_oper_size)

    mem_oper_signed = Bits(1)(0)
    is_unsigned = eqs["lbu"] | eqs["lhu"]
    mem_oper_signed = is_unsigned.select(Bits(1)(1), mem_oper_signed)

    is_branch = is_type[BInst]
    link_pc = eqs["jal"] | eqs["jalr"]
    is_offset_br = is_type[BInst] | eqs["jal"]

    is_pc_calc = eqs["auipc"]

    rd = rd_valid.select(views[RInst].view().rd, Bits(5)(0))
    rs1 = rs1_valid.select(views[RInst].view().rs1, Bits(5)(0))
    rs2 = rs2_valid.select(views[RInst].view().rs2, Bits(5)(0))
    imm_valid = (
        is_type[IInst]
        | is_type[SInst]
        | is_type[BInst]
        | is_type[UInst]
        | is_type[JInst]
    )
    imm = Bits(32)(0)
    for i in supported_types:
        new_imm = views[i].imm(True)
        if new_imm is not None:
            imm = is_type[i].select(new_imm, imm)

    imm = eqs["lui"].select(views[UInst].imm(False).concat(Bits(12)(0)), imm)
    imm = eqs["auipc"].select(views[UInst].imm(False).concat(Bits(12)(0)), imm)

    return DecodeSignals.bundle(
        memory=memory,
        alu=alu,
        alu_valid=alu_valid,
        cond=cond,
        flip=flip,
        is_branch=is_branch,
        rs1=rs1,
        rs1_valid=rs1_valid,
        rs2=rs2,
        rs2_valid=rs2_valid,
        rd=rd,
        rd_valid=rd_valid,
        imm=imm,
        imm_valid=imm_valid,
        is_offset_br=is_offset_br,
        link_pc=link_pc,
        mem_oper_size=mem_oper_size,
        mem_oper_signed=mem_oper_signed,
        is_pc_calc=is_pc_calc,
        is_jal=eqs["jal"],
        is_jalr=eqs["jalr"],
        is_auipc=eqs["auipc"],
        is_lui=eqs["lui"],
        is_branch_inst=is_type[BInst],
    )
