# RISC-V-CPU

Final project of CS2967

A RISC-V CPU simulator implemented in Python using [assassyn](https://github.com/Synthesys-Lab/assassyn.git). To use this project, you should configure assassyn environment first.

## Project Structure

```
RISC-V-CPU/
├── cpu/                    # CPU core modules
│   ├── __init__.py         # Package initialization and exports
│   ├── alu.py              # Arithmetic Logic Unit
│   ├── bpu.py              # Branch Prediction Unit
│   ├── decoder.py          # Instruction Decoder
│   ├── divider.py          # Divider (pipeline)
│   ├── fetcher.py          # Instruction Fetcher
│   ├── instruction.py      # Instruction Definitions
│   ├── lsq.py              # Load/Store Queue
│   ├── multiplier.py       # Multiplier (Booth encoding)
│   ├── rob.py              # Reorder Buffer
│   ├── rs.py               # Reservation Station
│   └── utils.py            # Utility functions
├── scripts/                # Utility scripts
│   ├── parse_hex.py        # Hex file parsing tool
│   └── benchmark.py        # Performance benchmark
├── unit_tests/             # Unit tests
├── workload/               # Test programs
├── playground/             # Temporary debug programs
├── compilation/            # Compilation scripts
├── docs/                   # Documentation
└── main.py                 # Main entry point
```

## Current Work

Currently working on tomasulo algorithm. Architecture is in docs/arch.md, details in docs/details.md.

## Usage

### Run All Workload Tests

```bash
python main.py                                    # Run all workload tests
python main.py --all-workloads --max-cycles 100000000
```

### Run Specific Test

```bash
python main.py --test raw --max-cycles 100        # Run unit tests
python main.py --workload 0to100 --max-cycles 10000  # Run workload
```

### Run with Init File

If you already have a unified init image (one word per line hex), you can run it directly:

```bash
python main.py --init-file workload/0to100/0to100.txt --max-cycles 100000
```

### Branch Predictor

Choose the branch predictor via `--predictor`:

```bash
python main.py --test br1 --predictor global
# Supports: tournament, global, two_bit, always_false, always_true, tage
```

### Playground Mode

For quick iteration during development:
First create `playground` folder with `playground.txt` or `playground.data` inside.

Then run:
```bash
# First-time compilation (only execute once)
python main.py --playground-build --max-cycles 100000

# Run directly after modifying playground/playground.data or playground.txt (no recompilation needed)
python main.py --playground-run
```

Playground supports two file formats:
- `playground.data`: hex byte format (auto-converted to txt)
- `playground.txt`: 32-bit word format

## Prediction Statistics

The CPU supports collecting branch prediction statistics. Use `--stat` option to save statistics to CSV:

```bash
python main.py --stat                             # Default save to .workspace/stats.csv
python main.py --stat my_stats.csv                # Specify file path
```

Statistics include: total committed instructions, total branches, correctly predicted branches, prediction accuracy.

## Code Style

This project uses Black and isort for consistent code formatting. Configuration is in `pyproject.toml`:

```bash
# Format imports and code (if installed)
python -m isort *.py cpu/*.py scripts/*.py unit_tests/*.py
python -m black *.py cpu/*.py scripts/*.py unit_tests/*.py
```

Line length is set to 100 characters.

