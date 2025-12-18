## Compilation
This directory contains files related to the compilation process from C source code to RISC-V machine code used in this CPU.
To use these files, you will need a RISC-V toolchain installed on your system.
### How to Compile C Code to RISC-V Machine Code
- Create your C source file (e.g., `program.c`) in this directory.
- Use the provided `compile.sh` script to compile your C code into RISC-V machine code, e.g.:
  ```bash
  ./compile.sh program
  ```
- Then you can find the generated files in the `program` directory.
