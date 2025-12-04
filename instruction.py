from assassyn.frontend import *


class InstType:

    FIELDS = [
        ((0, 6), "opcode", Bits),
        ((7, 11), "rd", Bits),
        ((15, 19), "rs1", Bits),
        ((20, 24), "rs2", Bits),
        ((12, 14), "funct3", Bits),
        ((25, 31), "funct7", Bits),
    ]

    def __init__(self, rd, rs1, rs2, funct3, funct7, fields, value):
        self.fields = fields.copy()
        for cond, entry in zip([True, rd, rs1, rs2, funct3, funct7], self.FIELDS):
            key, field, ty = entry
            setattr(self, f"has_{field}", cond)
            if cond:
                self.fields[key] = (field, ty)

        self.dtype = Record(self.fields)
        self.value = value

    def view(self):
        return self.dtype.view(self.value)


class InstSignal:

    def __init__(self, eq, alu, cond=None):
        self.eq = eq

        self.alu = Bits(RV32I_ALU.CNT)(0)
        if alu is not None:
            self.alu = Bits(RV32I_ALU.CNT)(1 << alu)

        self.cond = Bits(1)(0)
        self.flip = Bits(1)(0)
        if cond is not None:
            pred, flip = cond
            self.cond = Bits(RV32I_ALU.CNT)(1 << pred)
            self.flip = Bits(1)(flip)


class RInst(InstType):

    PREFIX = "r"

    def __init__(self, value):
        super().__init__(
            rd=True,
            rs1=True,
            rs2=True,
            funct3=True,
            funct7=True,
            fields={},
            value=value,
        )

    def decode(self, opcode, funct3, funct7, alu, ex_code=None):
        view = self.view()
        opcode_valid = view.opcode == Bits(7)(opcode)
        funct3_valid = view.funct3 == Bits(3)(funct3)
        funct7_valid = view.funct7 == Bits(7)(funct7)
        if ex_code is not None:
            ex_valid = view.rs2 == Bits(5)(ex_code)
        else:
            ex_valid = Bits(1)(1)
        eq = opcode_valid & funct3_valid & funct7_valid & ex_valid
        return InstSignal(eq=eq, alu=alu)

    def imm(self, pad):
        return None


class IInst(InstType):

    PREFIX = "i"

    def __init__(self, value):
        super().__init__(
            rd=True,
            rs1=True,
            rs2=False,
            funct3=True,
            funct7=False,
            fields={(20, 31): ("imm", Bits)},
            value=value,
        )

    
    def imm(self, pad):
        raw = self.view().imm
        if pad:
            signal = raw[11:11]
            signal = signal.select(Bits(20)(0xFFFFF), Bits(20)(0))
            raw = concat(signal, raw)
        return raw

    
    def decode(self, opcode, funct3, alu, cond, ex_code, ex_code2):
        view = self.view()
        opcode = view.opcode == Bits(7)(opcode)
        funct3 = view.funct3 == Bits(3)(funct3)
        if ex_code is not None:
            ex = view.imm == Bits(12)(ex_code)
        else:
            ex = Bits(1)(1)

        if ex_code2 is not None:
            ex2 = view.imm[6:11] == Bits(6)(ex_code2)
        else:
            ex2 = Bits(1)(1)

        eq = opcode & funct3 & ex & ex2
        return InstSignal(eq=eq, alu=alu, cond=cond)


class SInst(InstType):

    PREFIX = "s"

    def __init__(self, value):
        fields = {(25, 31): ("imm11_5", Bits), (7, 11): ("imm4_0", Bits)}
        super().__init__(
            rd=False,
            rs1=True,
            rs2=True,
            funct3=True,
            funct7=False,
            fields=fields,
            value=value,
        )

    
    def decode(self, opcode, funct3, alu):
        view = self.view()
        opcode = view.opcode == Bits(7)(opcode)
        funct3 = view.funct3 == Bits(3)(funct3)
        eq = opcode & funct3
        return InstSignal(eq=eq, alu=alu)

    
    def imm(self, pad):
        imm = self.view().imm11_5.concat(self.view().imm4_0)
        if pad:
            msb = imm[11:11]
            msb = msb.select(Bits(20)(0xFFFFF), Bits(20)(0))
            imm = concat(msb, imm)
        return imm


class UInst(InstType):

    PREFIX = "u"

    def __init__(self, value):
        super().__init__(
            rd=True,
            rs1=False,
            rs2=False,
            funct3=False,
            funct7=False,
            fields={(12, 31): ("imm", Bits)},
            value=value,
        )

    
    def decode(self, opcode, alu):
        view = self.view()
        eq = view.opcode == Bits(7)(opcode)
        return InstSignal(eq=eq, alu=alu)

    
    def imm(self, pad):
        raw = self.view().imm
        if pad:
            raw = concat(Bits(12)(0), raw)
        return raw


class JInst(InstType):

    PREFIX = "j"

    def __init__(self, value):
        fields = {
            (12, 19): ("imm19_12", Bits),
            (20, 20): ("imm11", Bits),
            (21, 30): ("imm10_1", Bits),
            (31, 31): ("imm20", Bits),
        }
        super().__init__(
            rd=True,
            rs1=False,
            rs2=False,
            funct3=False,
            funct7=False,
            fields=fields,
            value=value,
        )

    
    def decode(self, opcode, alu, cond):
        view = self.view()
        eq = view.opcode == Bits(7)(opcode)
        return InstSignal(eq=eq, alu=alu, cond=cond)

    
    def imm(self, pad):
        view = self.view()
        imm = concat(view.imm20, view.imm19_12, view.imm11, view.imm10_1, Bits(1)(0))
        if pad:
            signal = imm[20:20]
            signal = signal.select(Bits(11)(0x7FF), Bits(11)(0))
            imm = concat(signal, imm)
        return imm


class BInst(InstType):

    PREFIX = "b"

    def __init__(self, value):
        fields = {
            (7, 7): ("imm11", Bits),
            (8, 11): ("imm4_1", Bits),
            (25, 30): ("imm10_5", Bits),
            (31, 31): ("imm12", Bits),
        }
        super().__init__(
            rd=False,
            rs1=True,
            rs2=True,
            funct3=True,
            funct7=False,
            fields=fields,
            value=value,
        )

    
    def decode(self, opcode, funct3, cmp, flip):
        view = self.view()
        opcode = view.opcode == Bits(7)(opcode)
        funct3 = view.funct3 == Bits(3)(funct3)
        eq = opcode & funct3
        return InstSignal(eq, alu=0, cond=(cmp, flip))
    
    
    def imm(self, pad):
        imm = concat(self.view().imm12, self.view().imm11, self.view().imm10_5, self.view().imm4_1)
        imm = imm.concat(Bits(1)(0))
        if pad:
            signal = imm[12:12]
            signal = signal.select(Bits(19)(0x7ffff), Bits(19)(0))
            imm = concat(signal, imm)
        return imm

class RV32I_ALU:

    ALU_ADD = 0
    ALU_SUB = 1

    ALU_AND = 2
    ALU_OR = 3
    ALU_XOR = 4

    ALU_SLL = 5
    ALU_SRL = 6
    ALU_SRA = 7

    ALU_CMP_EQ = 8
    ALU_CMP_LT = 9
    ALU_CMP_LTU = 10

    ALU_TRUE = 11
    ALU_NONE = 12

    CNT = 13


DecodeSignals = Record(
    rs1=Bits(5),
    rs1_valid=Bits(1),
    rs2=Bits(5),
    rs2_valid=Bits(1),
    rd=Bits(5),
    rd_valid=Bits(1),
    imm=Bits(32),
    imm_valid=Bits(1),
    # bit vector of alu operand
    alu_valid=Bits(1),
    alu=Bits(RV32I_ALU.CNT),
    # bit vector of branch
    cond=Bits(RV32I_ALU.CNT),
    flip=Bits(1),
    is_branch=Bits(1),
    # memory[0:0] is read, memory[1:1] is write
    memory=Bits(2),

    is_offset_br=Bits(1),
    link_pc=Bits(1),

    # memory operation size: 0 - byte, 1 - half, 2 - word
    mem_oper_size=Bits(2),
    # memory operation signedness: 0 - signed, 1 - unsigned
    mem_oper_signed=Bits(1),
    is_pc_calc=Bits(1),
    is_jal=Bits(1),
    is_jalr=Bits(1),
    is_auipc=Bits(1),
    is_lui=Bits(1),
    is_branch_inst=Bits(1),
)

decoder_signal_default = DecodeSignals.bundle(
    rs1=Bits(5)(0),
    rs1_valid=Bits(1)(0),
    rs2=Bits(5)(0),
    rs2_valid=Bits(1)(0),
    rd=Bits(5)(0),
    rd_valid=Bits(1)(0),
    imm=Bits(32)(0),
    imm_valid=Bits(1)(0),
    alu=Bits(RV32I_ALU.CNT)(0),
    alu_valid=Bits(1)(0),
    cond=Bits(RV32I_ALU.CNT)(0),
    flip=Bits(1)(0),
    is_branch=Bits(1)(0),
    memory=Bits(2)(0),
    is_offset_br=Bits(1)(0),
    link_pc=Bits(1)(0),
    mem_oper_size=Bits(2)(0),
    mem_oper_signed=Bits(1)(0),
    is_pc_calc=Bits(1)(0),
    is_jal=Bits(1)(0),
    is_jalr=Bits(1)(0),
    is_auipc=Bits(1)(0),
    is_lui=Bits(1)(0),
    is_branch_inst=Bits(1)(0),
)

supported_opcodes = [
    # J type (opcode, alu, cond)
    ('jal'  ,   (0b1101111, RV32I_ALU.ALU_ADD, (RV32I_ALU.ALU_TRUE, False)), JInst),

    # U type (opcode, alu)
    ('lui'  ,   (0b0110111, RV32I_ALU.ALU_ADD), UInst),
    ('auipc',   (0b0010111, RV32I_ALU.ALU_ADD), UInst),

    # I type (opcode, funct3, alu, cond, ex_code, ex_code2)
    ('jalr' ,   (0b1100111, 0b000, RV32I_ALU.ALU_ADD, (RV32I_ALU.ALU_TRUE, False), None, None), IInst),
    ('lb'   ,   (0b0000011, 0b000, RV32I_ALU.ALU_ADD, None, None, None), IInst),
    ('lh'   ,   (0b0000011, 0b001, RV32I_ALU.ALU_ADD, None, None, None), IInst),
    ('lw'   ,   (0b0000011, 0b010, RV32I_ALU.ALU_ADD, None, None, None), IInst),
    ('lbu'  ,   (0b0000011, 0b100, RV32I_ALU.ALU_ADD, None, None, None), IInst),
    ('lhu'  ,   (0b0000011, 0b101, RV32I_ALU.ALU_ADD, None, None, None), IInst),
    ('addi' ,   (0b0010011, 0b000, RV32I_ALU.ALU_ADD, None, None, None), IInst),
    ('andi' ,   (0b0010011, 0b111, RV32I_ALU.ALU_AND, None, None, None), IInst),
    ('ori'  ,   (0b0010011, 0b110, RV32I_ALU.ALU_OR, None, None, None), IInst),
    ('xori' ,   (0b0010011, 0b100, RV32I_ALU.ALU_XOR, None, None, None), IInst),
    ('slti' ,   (0b0010011, 0b010, RV32I_ALU.ALU_CMP_LT, None, None, None), IInst),
    ('sltiu',   (0b0010011, 0b011, RV32I_ALU.ALU_CMP_LTU, None, None, None), IInst),
    ('slli' ,   (0b0010011, 0b001, RV32I_ALU.ALU_SLL, None, None, 0b000000), IInst),
    ('srli' ,   (0b0010011, 0b101, RV32I_ALU.ALU_SRL, None, None, 0b000000), IInst),
    ('srai' ,   (0b0010011, 0b101, RV32I_ALU.ALU_SRA, None, None, 0b0100000), IInst),
    
    # R type (opcode, funct3, funct7, alu)
    ('add'  ,   (0b0110011, 0b000, 0b0000000, RV32I_ALU.ALU_ADD), RInst),
    ('sub'  ,   (0b0110011, 0b000, 0b0100000, RV32I_ALU.ALU_SUB), RInst),
    ('and'  ,   (0b0110011, 0b111, 0b0000000, RV32I_ALU.ALU_AND), RInst),
    ('or'   ,   (0b0110011, 0b110, 0b0000000, RV32I_ALU.ALU_OR), RInst),
    ('xor'  ,   (0b0110011, 0b100, 0b0000000, RV32I_ALU.ALU_XOR), RInst),
    ('sll'  ,   (0b0110011, 0b001, 0b0000000, RV32I_ALU.ALU_SLL), RInst),
    ('srl'  ,   (0b0110011, 0b101, 0b0000000, RV32I_ALU.ALU_SRL), RInst),
    ('sra'  ,   (0b0110011, 0b101, 0b0100000, RV32I_ALU.ALU_SRA), RInst),
    ('slt'  ,   (0b0110011, 0b010, 0b0000000, RV32I_ALU.ALU_CMP_LT), RInst),
    ('sltu' ,   (0b0110011, 0b011, 0b0000000, RV32I_ALU.ALU_CMP_LTU), RInst),

    # S type (opcode, funct3, alu)
    ('sb'   ,   (0b0100011, 0b000, RV32I_ALU.ALU_ADD), SInst),
    ('sh'   ,   (0b0100011, 0b001, RV32I_ALU.ALU_ADD), SInst),
    ('sw'   ,   (0b0100011, 0b010, RV32I_ALU.ALU_ADD), SInst),

    # B type (opcode, funct3, cmp, flip)
    ('beq'  ,   (0b1100011, 0b000, RV32I_ALU.ALU_CMP_EQ, False), BInst),
    ('bne'  ,   (0b1100011, 0b001, RV32I_ALU.ALU_CMP_EQ, True), BInst),
    ('blt'  ,   (0b1100011, 0b100, RV32I_ALU.ALU_CMP_LT, False), BInst),
    ('bge'  ,   (0b1100011, 0b101, RV32I_ALU.ALU_CMP_LT, True), BInst),
    ('bltu' ,   (0b1100011, 0b110, RV32I_ALU.ALU_CMP_LTU, False), BInst),
    ('bgeu' ,   (0b1100011, 0b111, RV32I_ALU.ALU_CMP_LTU, True), BInst),

]

supported_types = [RInst, IInst, SInst, UInst, JInst, BInst]
