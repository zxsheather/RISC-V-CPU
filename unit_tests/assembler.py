
def encode_r_type(opcode, funct3, funct7, rd, rs1, rs2):
    return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode

def encode_i_type(opcode, funct3, rd, rs1, imm):
    imm = imm & 0xFFF
    return (imm << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode

def addi(rd, rs1, imm):
    return encode_i_type(0b0010011, 0b000, rd, rs1, imm)

def add(rd, rs1, rs2):
    return encode_r_type(0b0110011, 0b000, 0b0000000, rd, rs1, rs2)

def sub(rd, rs1, rs2):
    return encode_r_type(0b0110011, 0b000, 0b0100000, rd, rs1, rs2)

def nop():
    return addi(0, 0, 0)