# Tomasulo CPU Architecture

This project implements a RISC-V CPU simulator using the Tomasulo algorithm for out-of-order execution. The simulator is written in Python using the `assassyn` framework.

## System Overview

The CPU consists of the following main stages and components:

1.  **Instruction Fetch (Fetcher)**
2.  **Instruction Decode (Decoder)**
3.  **Reservation Station (RS)**
4.  **Reorder Buffer (ROB)**
5.  **Execution Units (ALU, LSQ, Multiplier, Divider)**
6.  **Branch Prediction Unit (BPU)**

## Component Details

### 1. Fetcher (`fetcher.py`)
The Fetcher is responsible for retrieving instructions from the Instruction Cache (`icache`).
-   **PC Management**: Maintains the Program Counter (PC).
-   **Next PC Logic**: Determines the next PC based on:
    -   Sequential execution (PC + 4).
    -   Branch prediction results from the BPU.
    -   Redirect signals from the ROB (in case of branch misprediction or exceptions).
-   **Interface**: Sends the fetched instruction and PC to the Decoder.

### 2. Decoder (`decoder.py`)
The Decoder processes the 32-bit RISC-V instructions fetched by the Fetcher.
-   **Decoding**: Extracts instruction fields (opcode, rd, rs1, rs2, immediate) and generates control signals (ALU operation, memory operation type, etc.).
-   **Branch Detection**: Identifies JAL and Branch instructions.
-   **Interface**:
    -   Sends decoded signals and operands to the Reservation Station (RS).
    -   Sends branch information to the BPU.

### 3. Reservation Station (RS) (`rs.py`)
The Reservation Station manages the scheduling of instructions.
-   **Capacity**: `RS_SIZE` (default 16) entries.
-   **Register Renaming**: Renames architectural registers to ROB entries to handle data dependencies (RAW, WAW, WAR).
-   **Operand Tracking**: Tracks the availability of source operands. If an operand is not available (produced by an in-flight instruction), the RS listens to the Common Data Bus (CDB) / ROB updates to capture the value when it becomes available.
-   **Dispatch**: When all operands for an instruction are ready, the RS dispatches the instruction to the appropriate execution unit (ALU or LSQ) for execution and ROB for commit tracking.

### 4. Reorder Buffer (ROB) (`rob.py`)
The ROB ensures instructions are committed in program order, preserving the sequential consistency of the execution.
-   **Capacity**: `ROB_SIZE` (default 16) entries.
-   **State Management**: Holds the status (Issued, Executing, Finished, Committed) and result of every in-flight instruction.
-   **Commit**: Commits the instruction at the head of the buffer if it has finished execution. This involves updating the architectural Register File and performing memory writes.
-   **Recovery**: Handles branch mispredictions. If a misprediction is detected at commit time, the ROB flushes the pipeline (RS, LSQ, Fetcher) and redirects the Fetcher to the correct PC.

### 5. Load/Store Queue (LSQ) (`lsq.py`)
The LSQ handles all memory access operations.
-   **Capacity**: `LSQ_SIZE` (default 8) entries.
-   **Queues**: Maintains a Load Queue (LQ) and a Store Queue (SQ).
-   **Execution**: Executes load and store instructions.
-   **Consistency**: Ensures memory consistency, potentially checking for dependencies between loads and stores.
-   **Commit**: Writes data to the Data Cache (`dcache`) only when the store instruction is committed by the ROB.

### 6. Arithmetic Logic Unit (ALU) (`alu.py`)
The ALU performs arithmetic and logical operations.
-   **Operations**: Supports standard RISC-V integer operations (ADD, SUB, SLL, SRA, SRL, AND, OR, XOR, comparisons).
-   **Execution**: Receives operands from the RS, executes the operation, and broadcasts the result (Write Back) to the ROB.

### 7. Branch Prediction Unit (BPU) (`bpu.py`)
The BPU predicts the outcome of branch instructions to minimize pipeline stalls.
-   **Strategies**: The codebase includes implementations for several branch prediction strategies:
    -   Always Taken
    -   Always Not Taken
    -   2-bit Saturating Counter
    -   Global History Predictor
    -   Tournament Predictor
    -   TAGE Predictor
-   **Update**: Receives actual branch outcomes from the ROB to update its prediction state.

## Execution Flow

1.  **Fetch**: `Fetcher` retrieves an instruction using the current PC.
2.  **Decode**: `Decoder` parses the instruction.
3.  **Issue**: `RS` allocates an entry and a ROB entry. Operands are renamed.
4.  **Execute**: Instructions wait in `RS` until operands are ready. Then they are sent to `ALU` or `LSQ` and `ROB`.
5.  **Commit**: `ROB` retires instructions in order, updating the architectural state and handling traps/exceptions. If a branch misprediction is detected, the pipeline is flushed and redirected.
6.  **Write Back**: Results are broadcasted to `RS` and `LSQ`(for store).