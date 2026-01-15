from .assembler import *


def war_hazard_test():
    """
    WAR Hazard Test (Write-After-Read)
    Instruction 1 reads a register.
    Instruction 2 writes to the same register.
    We want to ensure Instruction 1 reads the OLD value, not the NEW value from Instruction 2.
    """
    return [
        addi(1, 0, 10),  # x1 = 10
        addi(3, 0, 20),  # x3 = 20
        # Hazard here:
        add(2, 1, 3),  # x2 = x1 + x3 = 10 + 20 = 30. (Reads x1)
        addi(1, 0, 5),  # x1 = 5. (Writes x1)
        nop(),
        nop(),
        nop(),
    ]


def waw_hazard_test():
    """
    WAW Hazard Test (Write-After-Write)
    Instruction 1 writes to a register.
    Instruction 2 writes to the same register.
    We want to ensure the final value is from Instruction 2.
    """
    return [addi(1, 0, 5), addi(1, 0, 6), nop(), nop(), nop()]  # x1 = 5  # x1 = 6


def raw_hazard_test():
    """
    RAW Hazard Test (Read-After-Write)
    Instruction 1 writes to a register.
    Instruction 2 reads from the same register.
    We want to ensure Instruction 2 reads the NEW value from Instruction 1.
    """
    return [
        addi(1, 0, 15),  # x1 = 15
        addi(2, 1, 10),  # x2 = x1 + 10 = 15 + 10 = 25. (Reads x1)
        nop(),
        nop(),
        nop(),
    ]


def load_store_test_1():
    """
    Load/Store Test
    Test sw, lw, lh, lb instructions.
    """
    return [
        addi(1, 0, 64),  # x1 = 64 (Base address)
        addi(2, 0, 123),  # x2 = 123 (Value to store)
        # Store word: Mem[64] = 123. Base=x1, Src=x2.
        sw(1, 2, 0),
        # Load word: x3 = Mem[64] = 123. Dest=x3, Base=x1.
        lw(3, 1, 0),
        # Load half: x4 = Mem[64]. Dest=x4, Base=x1.
        lh(4, 1, 0),
        # Load byte: x5 = Mem[64]. Dest=x5, Base=x1.
        lb(5, 1, 0),
        # Store word: Mem[68] = 123. Base=x1, Src=x2.
        sw(1, 2, 4),
        nop(),
        nop(),
        nop(),
    ]


def branch_test():
    """
    Branch Test
    Test beq, bne, blt, bge.
    """
    return [
        addi(1, 0, 10),  # x1 = 10
        addi(2, 0, 10),  # x2 = 10
        # Test beq (Taken)
        beq(1, 2, 8),  # if x1 == x2, PC += 8. Skips next instruction.
        addi(3, 0, 0xBAD),  # x3 = 0xBAD (Should be skipped)
        addi(3, 0, 1),  # x3 = 1 (Target)
        addi(4, 0, 20),  # x4 = 20
        # Test bne (Taken)
        bne(1, 4, 8),  # if x1 != x4, PC += 8. Skips next.
        addi(5, 0, 0xBAD),  # x5 = 0xBAD (Should be skipped)
        addi(5, 0, 1),  # x5 = 1 (Target)
        # Test blt (Taken)
        blt(1, 4, 8),  # if x1 < x4 (10 < 20), PC += 8.
        addi(6, 0, 0xBAD),  # x6 = 0xBAD
        addi(6, 0, 1),  # x6 = 1
        # Test bge (Taken)
        bge(4, 1, 8),  # if x4 >= x1 (20 >= 10), PC += 8.
        addi(7, 0, 0xBAD),  # x7 = 0xBAD
        addi(7, 0, 1),  # x7 = 1
        # Test beq (Not Taken)
        beq(1, 4, 8),  # if x1 == x4 (10 == 20) False.
        addi(8, 0, 1),  # x8 = 1 (Should be executed)
        nop(),
        nop(),
        nop(),
    ]


def branch_mem_test():
    """
    Branch Memory Test
    Test interaction between branch and load/store instructions.
    """
    return [
        addi(1, 0, 64),  # x1 = 64 (Base address)
        addi(2, 0, 42),  # x2 = 42 (Value to store)
        # Store x2 to Mem[64]
        sw(1, 2, 0),
        # Load from Mem[64] to x3
        lw(3, 1, 0),  # x3 should be 42
        # Branch if x3 == x2 (42 == 42), should be taken. Target is PC + 12.
        beq(3, 2, 12),
        addi(4, 0, 0),  # x4 = 0 (Should be skipped)
        sw(1, 4, 4),  # Store 0 to Mem[68] (Should be skipped)
        # Target:
        addi(5, 0, 1),  # x5 = 1
        sw(1, 5, 8),  # Store 1 to Mem[72] indicating success
        nop(),
        nop(),
        nop(),
    ]


def lui_auipc_test():
    """
    LUI and AUIPC Test
    """
    return [
        # LUI: x1 = 0x12345 << 12 = 0x12345000
        lui(1, 0x12345),
        # AUIPC: x2 = PC + (0x10000 << 12).
        # Assuming PC starts at 4 (since it's the second instruction),
        # x2 = 4 + 0x10000000 = 0x10000004
        auipc(2, 0x10000),
        nop(),
        nop(),
        nop(),
    ]


def jal_test():
    """
    JAL Test (Jump and Link)
    Test JAL instruction for unconditional jumps and return address storage.
    """
    return [
        addi(1, 0, 0),  # x1 = 0 (Initialize)
        # JAL: Jump to offset 16 (skip next 3 instructions), save PC+4 in x2
        jal(2, 16),  # x2 = PC + 4 (return address)
        addi(1, 0, 0xBAD),  # x1 = 0xBAD (Should be skipped)
        addi(3, 0, 0xBAD),  # x3 = 0xBAD (Should be skipped)
        addi(4, 0, 0xBAD),  # x4 = 0xBAD (Should be skipped)
        # Target: PC + 16
        addi(1, 0, 42),  # x1 = 42 (Should execute)
        # Test return address: x2 should contain the address of the skipped instruction
        addi(5, 2, 0),  # x5 = x2 (copy return address)
        nop(),
        nop(),
        nop(),
    ]


def jalr_test():
    """
    JALR Test (Jump and Link Register)
    Test JALR instruction for computed jumps and function returns.
    """
    return [
        addi(1, 0, 0),  # x1 = 0 (Initialize)
        # Set up target address in x3 (PC of instruction at offset 20)
        auipc(3, 0),  # x3 = current PC
        addi(3, 3, 20),  # x3 = PC + 20 (target address)
        # JALR: Jump to address in x3, save return address in x2
        jalr(2, 3, 0),  # PC = x3 + 0, x2 = PC + 4
        addi(1, 0, 0xBAD),  # x1 = 0xBAD (Should be skipped)
        addi(4, 0, 0xBAD),  # x4 = 0xBAD (Should be skipped)
        # Target address
        addi(1, 0, 99),  # x1 = 99 (Should execute)
        # Use return address
        addi(5, 2, 0),  # x5 = x2 (copy return address)
        nop(),
        nop(),
        nop(),
    ]


def jal_jalr_combined_test():
    """
    JAL and JALR Combined Test
    Test function call and return simulation using JAL and JALR.
    """
    return [
        addi(10, 0, 5),  # x10 = 5 (argument)
        # Call "function" using JAL
        jal(1, 12),  # Jump to function, x1 = return address
        # Return point
        addi(11, 10, 0),  # x11 = x10 (result)
        jal(0, 20),  # Jump to end
        # "Function" code: multiply x10 by 2
        addi(10, 10, 0),  # x10 = x10 (load argument)
        add(10, 10, 10),  # x10 = x10 + x10 = x10 * 2
        # Return using JALR
        jalr(0, 1, 0),  # Jump to address in x1 (return address)
        # End
        nop(),
        nop(),
        nop(),
    ]


def sum_0_to_100_test():
    """
    Sum 0 to 100 Test
    Calculate sum = 0 + 1 + 2 + ... + 100 = 5050
    Result stored in x10
    """
    return [
        addi(13, 0, 0),  # x13 = 0 (sum accumulator)
        addi(11, 0, 0),  # x11 = 0 (counter, starts from 0)
        addi(12, 0, 100),  # x12 = 100 (loop limit)
        # Loop start (offset 12)
        add(13, 13, 11),  # x13 = x13 + x11 (sum += counter)
        addi(11, 11, 1),  # x11 = x11 + 1 (counter++)
        # Check if counter <= 100
        bge(12, 11, -8),  # if x12 >= x11 (100 >= counter), jump back to loop start
        # Loop end - result in x10 should be 5050
        addi(10, 13, 0),  # x10 = x13 (move result to x10)
        addi(10, 0, 255),
        nop(),
        nop(),
        nop(),
        nop(),
        nop(),
        nop(),
    ]


def store_byte_halfword_test():
    """
    Store Byte and Halfword Test
    Test sb (store byte), sh (store halfword), and sw (store word) instructions.
    Data segment starts at 0x10000.
    """
    return [
        # Set up base address 0x10000
        lui(1, 0x10),  # x1 = 0x10000 (base address for data segment)
        # Test value: 0x12345678
        lui(2, 0x12345),  # x2 = 0x12345000
        addi(2, 2, 0x678),  # x2 = 0x12345678
        # Store word at 0x10000: Mem[0x10000] = 0x12345678
        sw(1, 2, 0),
        # Store byte (lowest byte) at 0x10004: Mem[0x10004] = 0x78
        sb(1, 2, 4),
        # Store halfword (lowest 2 bytes) at 0x10008: Mem[0x10008] = 0x5678
        sh(1, 2, 8),
        # Load word from 0x10000 to verify
        lw(3, 1, 0),  # x3 = Mem[0x10000] = 0x12345678
        # Load byte from 0x10004 to verify
        lb(4, 1, 4),  # x4 = Mem[0x10004] = 0x78 (sign-extended)
        # Load halfword from 0x10008 to verify
        lh(5, 1, 8),  # x5 = Mem[0x10008] = 0x5678 (sign-extended)
        # Test storing different bytes
        addi(6, 0, 0xAB),  # x6 = 0xAB
        sb(1, 6, 12),  # Mem[0x1000C] = 0xAB
        addi(7, 0, 0xCD),  # x7 = 0xCD
        sb(1, 7, 13),  # Mem[0x1000D] = 0xCD
        addi(8, 0, 0xEF),  # x8 = 0xEF
        sb(1, 8, 14),  # Mem[0x1000E] = 0xEF
        # Load word to see combined result: 0x00EFCDAB (little-endian)
        lw(9, 1, 12),  # x9 = Mem[0x1000C]
        # Test storing halfwords
        lui(10, 0xBEEF),  # x10 = 0xBEEF0000
        addi(10, 10, -81),  # x10 = 0xBEEFFFAF
        sh(1, 10, 16),  # Mem[0x10010] = 0xFFAF
        # Load halfword back
        lh(11, 1, 16),  # x11 = Mem[0x10010] = 0xFFFFFFAF (sign-extended)
        nop(),
        nop(),
        nop(),
    ]


def store_byte_halfword_test_2():
    return [
        # Set up base address 0x10000
        lui(1, 0x10),  # x1 = 0x10000 (base address for data segment)
        # Test value: 0x12345678
        lui(2, 0x12345),  # x2 = 0x12345000
        addi(3, 0, 0x54),  # x3 = 0x54
        addi(2, 2, 0x678),  # x2 = 0x12345678
        # Store word at 0x10000: Mem[0x10000] = 0x12345678
        sw(1, 2, 0),
        # Store byte (lowest byte) at 0x10000: Mem[0x10000] = 0x54
        sb(1, 3, 0),
        # Load word from 0x10000 to verify
        lw(4, 1, 0),  # x4 = Mem[0x10000] = 0x12345654
        nop(),
        nop(),
        nop(),
    ]
