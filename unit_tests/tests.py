from .assembler import *

def war_hazard_test():
    """
    WAR Hazard Test (Write-After-Read)
    Instruction 1 reads a register.
    Instruction 2 writes to the same register.
    We want to ensure Instruction 1 reads the OLD value, not the NEW value from Instruction 2.
    """
    return [
        addi(1, 0, 10), # x1 = 10
        addi(3, 0, 20), # x3 = 20
        # Hazard here:
        add(2, 1, 3),   # x2 = x1 + x3 = 10 + 20 = 30. (Reads x1)
        addi(1, 0, 5),  # x1 = 5. (Writes x1)
        nop(),
        nop(),
        nop()
    ]

def waw_hazard_test():
    """
    WAW Hazard Test (Write-After-Write)
    Instruction 1 writes to a register.
    Instruction 2 writes to the same register.
    We want to ensure the final value is from Instruction 2.
    """
    return [
        addi(1, 0, 5),  # x1 = 5
        addi(1, 0, 6),  # x1 = 6
        nop(),
        nop(),
        nop()
    ]

def raw_hazard_test():
    """
    RAW Hazard Test (Read-After-Write)
    Instruction 1 writes to a register.
    Instruction 2 reads from the same register.
    We want to ensure Instruction 2 reads the NEW value from Instruction 1.
    """
    return [
        addi(1, 0, 15), # x1 = 15
        addi(2, 1, 10), # x2 = x1 + 10 = 15 + 10 = 25. (Reads x1)
        nop(),
        nop(),
        nop()
    ]

def load_store_test_1():
    """
    Load/Store Test
    Test sw, lw, lh, lb instructions.
    """
    return [
        addi(1, 0, 64),   # x1 = 64 (Base address)
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
        nop()
    ]

def branch_test():
    """
    Branch Test
    Test beq, bne, blt, bge.
    """
    return [
        addi(1, 0, 10),   # x1 = 10
        addi(2, 0, 10),   # x2 = 10
        
        # Test beq (Taken)
        beq(1, 2, 8),     # if x1 == x2, PC += 8. Skips next instruction.
        addi(3, 0, 0xBAD),# x3 = 0xBAD (Should be skipped)
        addi(3, 0, 1),    # x3 = 1 (Target)
        
        addi(4, 0, 20),   # x4 = 20
        
        # Test bne (Taken)
        bne(1, 4, 8),     # if x1 != x4, PC += 8. Skips next.
        addi(5, 0, 0xBAD),# x5 = 0xBAD (Should be skipped)
        addi(5, 0, 1),    # x5 = 1 (Target)
        
        # Test blt (Taken)
        blt(1, 4, 8),     # if x1 < x4 (10 < 20), PC += 8.
        addi(6, 0, 0xBAD),# x6 = 0xBAD
        addi(6, 0, 1),    # x6 = 1
        
        # Test bge (Taken)
        bge(4, 1, 8),     # if x4 >= x1 (20 >= 10), PC += 8.
        addi(7, 0, 0xBAD),# x7 = 0xBAD
        addi(7, 0, 1),    # x7 = 1

        # Test beq (Not Taken)
        beq(1, 4, 8),     # if x1 == x4 (10 == 20) False.
        addi(8, 0, 1),    # x8 = 1 (Should be executed)
        
        nop(),
        nop(),
        nop()
    ]

def branch_mem_test():
    """
    Branch Memory Test
    Test interaction between branch and load/store instructions.
    """
    return [
        addi(1, 0, 64),   # x1 = 64 (Base address)
        addi(2, 0, 42),   # x2 = 42 (Value to store)
        
        # Store x2 to Mem[64]
        sw(1, 2, 0),
        
        # Load from Mem[64] to x3
        lw(3, 1, 0),      # x3 should be 42
        
        # Branch if x3 == x2 (42 == 42), should be taken. Target is PC + 12.
        beq(3, 2, 12),    
        
        addi(4, 0, 0),    # x4 = 0 (Should be skipped)
        sw(1, 4, 4),      # Store 0 to Mem[68] (Should be skipped)
        
        # Target:
        addi(5, 0, 1),    # x5 = 1
        sw(1, 5, 8),      # Store 1 to Mem[72] indicating success
        
        nop(),
        nop(),
        nop()
    ]