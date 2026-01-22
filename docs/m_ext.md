# RISC-V M Extension: Multiply/Divide Unit Design

This document describes the hardware design of the RISC-V RV32 M extension (multiply/divide instructions) implemented in this CPU.

## 1. Overview

The M extension includes the following instructions:

| Instruction | Function | Description |
|-------------|----------|-------------|
| `MUL` | Low-word multiply | Return low 32 bits of the product |
| `MULH` | Signed × Signed high | Return high 32 bits of signed × signed |
| `MULHSU` | Signed × Unsigned high | Return high 32 bits of signed × unsigned |
| `MULHU` | Unsigned × Unsigned high | Return high 32 bits of unsigned × unsigned |
| `DIV` | Signed division | Return quotient |
| `DIVU` | Unsigned division | Return quotient |
| `REM` | Signed remainder | Return remainder |
| `REMU` | Unsigned remainder | Return remainder |

Both multiplier and divider are implemented as a 4-stage pipeline for a balanced latency/throughput trade-off.

---

## 2. Multiplier (Radix-4 Booth)

### 2.1 Algorithm

We use Radix-4 Booth encoding to halve the number of partial products: from 32 down to 16.

#### Booth encoding table

Radix-4 Booth examines three bits at a time: `[b_{2i+1}, b_{2i}, b_{2i-1}]`.

| Code | Operation |
|------|-----------|
| 000  | +0 |
| 001  | +A |
| 010  | +A |
| 011  | +2A |
| 100  | -2A |
| 101  | -A |
| 110  | -A |
| 111  | +0 |

Here `A` is the multiplicand. Each partial product is shifted left by `2i` bits.

### 2.2 Pipeline architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         4-Stage Booth Multiplier Pipeline                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Stage 1: BoothEncoder                                                      │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  • Sign handling (determine signedness of A/B by opcode)             │   │
│  │  • Generate A, 2A, -A, -2A                                           │   │
│  │  • Booth-encode multiplier B                                         │   │
│  │  • Generate 16 partial products (PP0 ~ PP15)                          │   │
│  │  • Shift each PP by 2i                                                │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  Stage 2: CompressStage1 (16 → 8)                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  S0 = PP0 + PP1     S4 = PP8 + PP9                                   │   │
│  │  S1 = PP2 + PP3     S5 = PP10 + PP11                                 │   │
│  │  S2 = PP4 + PP5     S6 = PP12 + PP13                                 │   │
│  │  S3 = PP6 + PP7     S7 = PP14 + PP15                                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  Stage 3: CompressStage2 (8 → 2)                                           │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  T0 = S0 + S1       T2 = S4 + S5                                     │   │
│  │  T1 = S2 + S3       T3 = S6 + S7                                     │   │
│  │  U0 = T0 + T1                                                        │   │
│  │  U1 = T2 + T3                                                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  Stage 4: FinalAdder                                                      │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  • Result = U0 + U1 + Correction                                     │   │
│  │  • Select low 32 (MUL) or high 32 (MULH/MULHSU/MULHU)                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.3 Signedness handling

Signedness by opcode:

| Instruction | A (multiplicand) | B (multiplier) |
|-------------|-------------------|----------------|
| MUL         | signed            | signed         |
| MULH        | signed            | signed         |
| MULHSU      | signed            | unsigned       |
| MULHU       | unsigned          | unsigned       |

```python
is_a_signed = is_mul | is_mulh | is_mulhsu  # A is signed in MUL/MULH/MULHSU
is_b_signed = is_mul | is_mulh              # B is signed in MUL/MULH
```

#### Unsigned multiplier correction

When B is unsigned and `B[31]=1`, Booth may treat it as negative. We add a correction term:

```
correction = (B is unsigned and B[31]=1) ? (A << 32) : 0
```

### 2.4 Bit widths

- Inputs: 32-bit operands
- Partial products: 64-bit signed
- Final sum: 64-bit
- Output: select low/high 32 bits by opcode

### 2.5 Latency & throughput

- Latency: 4 cycles
- Throughput: 1 instruction per cycle when pipeline is full

---

## 3. Divider (Restoring)

### 3.1 Algorithm

We use the classic Restoring Division algorithm:

1. Convert signed operands to absolute values (unsigned)
2. Perform unsigned division via restoring iterations
3. Apply quotient/remainder signs based on original operand signs

#### Single iteration

```
function div_iteration(R, divisor):
    1. R_shifted = R << 1           // shift R left
    2. R_upper = R_shifted[63:32]   // take upper 32 bits
    3. diff = R_upper - divisor     // tentative subtraction
    4. if diff >= 0:                // no borrow
         R_upper = diff             // keep the difference
         q_bit = 1                  // quotient bit is 1
       else:                        // borrow
         // R_upper unchanged (restore)
         q_bit = 0                  // quotient bit is 0
    5. R = {R_upper, R_lower}       // rebuild R
    return R, q_bit
```

### 3.2 Pipeline architecture

Each pipeline stage performs 8 iterations, emitting 8 quotient bits.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       4-Stage Restoring Divider Pipeline                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Stage 1: DivStage1 (signs + bits 31-24)                                    │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  • Determine signed/unsigned op                                      │   │
│  │  • Compute |dividend| and |divisor|                                  │   │
│  │  • Record quotient/remainder signs                                   │   │
│  │  • Init R = {0, |dividend|}                                          │   │
│  │  • 8 iterations produce Q[31:24]                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  Stage 2: DivStage2 (bits 23-16)                                           │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  • 8 iterations produce Q[23:16]                                     │   │
│  │  • Accumulate: Q_upper = {Q[31:24], Q[23:16]}                         │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  Stage 3: DivStage3 (bits 15-8)                                            │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  • 8 iterations produce Q[15:8]                                      │   │
│  │  • Accumulate: Q_upper24 = {Q[31:24], Q[23:16], Q[15:8]}              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  Stage 4: DivStage4 (bits 7-0 + adjust)                                     │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  • 8 iterations produce Q[7:0]                                       │   │
│  │  • Full quotient = {Q[31:24], Q[23:16], Q[15:8], Q[7:0]}             │   │
│  │  • Remainder = R[63:32]                                              │   │
│  │  • Apply signs to quotient/remainder                                 │   │
│  │  • Select quotient (DIV/DIVU) or remainder (REM/REMU)                │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Sign handling

#### Quotient sign
- Same signs: positive
- Different signs: negative
- `quotient_sign = is_signed & (dividend_sign ^ divisor_sign)`

#### Remainder sign
- Remainder sign follows dividend
- `remainder_sign = is_signed & dividend_sign`

### 3.4 Working register

Use a 64-bit register `R`:
- `R[31:0]`: lower half (partial remainder / dividend)
- `R[63:32]`: upper half (partial remainder)

Initialization: `R = {32'b0, |dividend|}`

Final:
- Quotient = concatenate 32 generated quotient bits
- Remainder = `R[63:32]`

### 3.5 Latency & throughput

- Latency: 4 cycles
- Throughput: 1 instruction per cycle (full pipeline)
- Iterations per stage: 8

---

## 4. Pipeline control

### 4.1 Module interface

Multiplier and divider share similar interfaces:

Inputs:
| Signal | Width | Description |
|--------|-------|-------------|
| `a` | 32 | Operand A (multiplicand/dividend) |
| `b` | 32 | Operand B (multiplier/divisor) |
| `alu` | RV32I_ALU.CNT | ALU opcode |
| `tag` | 32 | Instruction tag (for OoO tracking) |
| `valid` | 1 | Valid flag |

Outputs:
| Signal | Width | Description |
|--------|-------|-------------|
| `result` | 32 | Computed result |
| `tag_out` | 32 | Instruction tag |
| `valid_out` | 1 | Result valid |

### 4.2 Inter-stage communication

Stages pass data using `async_called`, forming an asynchronous pipeline.

---

## 5. Design trade-offs

### 5.1 Multiplier

| Aspect | Radix-4 Booth | Shift-add |
|--------|----------------|-----------|
| Partial products | 16 | 32 |
| Encoding complexity | Medium | Low |
| Adder tree depth | 4 | 5 |
| Area | Medium | Higher |

Rationale for Radix-4 Booth:
- Fewer partial products reduce adder-tree complexity
- Maps naturally to a 4-stage pipeline
- Good balance of performance and area

### 5.2 Divider

| Aspect | Restoring | SRT |
|--------|-----------|-----|
| Bits per iteration | 1 | 1–2 |
| Complexity | Low | High |
| Hardware cost | Low | Higher |
| Latency | 32 iterations | 16–32 iterations |

Rationale for Restoring:
- Simple and intuitive
- 8 iterations per stage → 4-stage pipeline
- Lower hardware cost

---

## 6. Summary

This design fully supports the RISC-V M extension:

- Multiplier: Radix-4 Booth, 4-stage pipeline, supports MUL/MULH/MULHSU/MULHU
- Divider: Restoring division, 4-stage pipeline, supports DIV/DIVU/REM/REMU
- Unified latency: 4-cycle latency for both units
- Pipelined: back-to-back issue supported for high throughput
