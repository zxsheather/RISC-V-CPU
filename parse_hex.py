#!/usr/bin/env python3
"""
    Merge every four bytes in a hex file into a single 32-bit word (little-endian).
    Preserves @ segment markers. Accepts bytes with/without spaces. Pads trailing bytes with 0.
"""

import argparse
import sys
from pathlib import Path


def merge_hex_bytes(input_file: str, output_file: str | None = None) -> str:
    lines = Path(input_file).read_text().splitlines()
    out: list[str] = []
    buf: list[str] = []

    def flush():
        nonlocal buf
        while buf:
            chunk, buf = buf[:4], buf[4:]
            while len(chunk) < 4:
                chunk.append("00")
            out.append("".join(reversed(chunk)).upper())

    for raw in lines:
        line = raw.strip()
        if not line:
            continue
        if line.startswith("@"):
            flush()
            addr = int(line[1:], 16)
            assert addr % 4 == 0, "Address in init file must be 4-byte aligned"
            trunc_addr = addr // 4
            line = f"@{trunc_addr:x}"
            out.append(line)
            continue
        parts = line.split()
        for part in parts:
            # allow continuous hex like 37010200
            for i in range(0, len(part), 2):
                byte = part[i:i+2]
                if len(byte) == 2:
                    buf.append(byte)
    flush()

    result = "\n".join(out)
    if output_file:
        Path(output_file).write_text(result + "\n")
    return result


def main():
    p = argparse.ArgumentParser(
        description="Merge every four bytes in a hex file into a 32-bit number (little-endian)"
    )
    p.add_argument("input", help="Input hex file path")
    p.add_argument("-o", "--output",
                   help="Output file (stdout if omitted)")
    args = p.parse_args()

    inp = Path(args.input)
    if not inp.exists():
        print(f"Error: Input file '{inp}' does not exist", file=sys.stderr)
        sys.exit(1)

    try:
        result = merge_hex_bytes(str(inp), args.output)
        if args.output:
            print(
                f"Successfully converted and saved to '{args.output}'", file=sys.stderr)
        else:
            print(result)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
