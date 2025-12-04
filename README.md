# RISC-V-CPU
Final project of CS2967
A RISC-V CPU simulator implemented in Python using [assassyn](https://github.com/Synthesys-Lab/assassyn.git). To use this project, you should
configure assassyn environment first.
## Currently work
Currently working on tomasulo algorithm

### Current module list:
- Fetch: Fetches instructions from instruction memory
- Decode: Decodes instructions and reads registers
- RS: Reservation Stations for holding instructions before execution
- ROB: Reorder Buffer for in-order commit
- ALU: Arithmetic Logic Unit for executing instructions

Only supports alu instructions right now.
## Tests
Unit tests are in the unit_tests/ directory. To run tests, execute main.py
For example:
```
python main.py --test raw
```
You could see log in the .workaspace/ directory.
