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