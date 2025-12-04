# Details
This document provides detailed information about why the architecture is designed the way it is, along with explanations of specific modules and components used in the implementation.

## FetcherImpl Downstream
### Why FetcherImpl uses Downstream?
Downstream, in short, is designed to write combinational logic between modules in pipeline. The FetcherImpl module uses Downstream to connect the fetch stage with the decode stage, allowing some information to be passed directly without going through registers. Think about
branch instructions. When confronted with a branch instruction, common practice works like this:

- Cycle 1: Fetch the branch instruction
- Cycle 2: Decode the branch instruction. Now decoder
knows it is a branch instruction, but fetcher does not know it yet. So fetcher still fetches the next sequential instruction and sends it to decoder.
- Cycle 3: fetcher receives the branch target, stoping fetching sequential instructions and waiting for the new PC. But decoder has already received the next sequential instruction in cycle 2, and this instruction is possibly wrong. We should specifically handle this case in decoder and there is a bubble.

But with Downstream, fetcher can directly receive the information that "it is a branch instruction" from decoder in the same cycle (cycle 2). So fetcher can stop immediately.

## Write Ports
Assassyn has strictly limited the number of write ports of a module writing to the same RegArray to 1. However, in some cases, we need multiple write ports. For example, in ROB, we may need one write port for committing instructions; another write port for receiving results from ALU, and etc. To solve this problem, we can create a new module for a new write port,
like:
```python
class ROBWritePort(Module):
    def __init__(self):
        super().__init__(ports={})
```
This module does not execute any logic, but just provides an additional write port to ROB. In this way, we can have multiple write ports to the same RegArray.
Like this:
```python
write_port_2 = ROBWritePort()
```
Use it by '&' operator:
```python
with Condition(alu_valid_from_alu[0]):
    alu_idx = rob_index_from_alu[0]
    (ready_array & write_port_2)[alu_idx] = Bits(1)(1)
    (value_array & write_port_2)[alu_idx] = alu_value_from_alu[0]
    log(
        "ROB: Received from ALU idx={}, value=0x{:08x}",
        alu_idx,
        alu_value_from_alu[0],
    )
```