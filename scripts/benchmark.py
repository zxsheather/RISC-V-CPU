import csv
import os
import subprocess
import sys


def run_benchmark():
    predictors = ["tournament", "global", "two_bit", "always_false", "always_true", "tage"]
    # predictors = ["global", "two_bit"] # For quick testing
    output_md = "benchmark_report.md"

    # Data structure: results[workload][predictor] = {stats}
    results = {}
    all_workloads = set()

    print(f"Starting benchmark for predictors: {predictors}")

    for pred in predictors:
        temp_csv = f"stats_{pred}.csv"
        print(f"\nRunning benchmark for predictor: {pred}...")

        cmd = [
            sys.executable,
            "main.py",
            "--stat",
            temp_csv,
            "--predictor",
            pred,
            "--skip-verilator",
        ]

        try:
            subprocess.run(cmd, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error running benchmark for {pred}: {e}")
            continue

        # Read CSV
        if os.path.exists(temp_csv):
            with open(temp_csv, "r") as f:
                reader = csv.DictReader(f)
                for row in reader:
                    workload = row["workload"]
                    all_workloads.add(workload)

                    if workload not in results:
                        results[workload] = {}

                    results[workload][pred] = row

            # Clean up temp file
            os.remove(temp_csv)
        else:
            print(f"Warning: No stats file generated for {pred}")

    # Generate Markdown Report
    print(f"\nGenerating report: {output_md}")

    sorted_workloads = sorted(list(all_workloads))

    with open(output_md, "w") as f:
        f.write("# Branch Predictor Benchmark Report\n\n")

        # 1. Accuracy Comparison
        f.write("## Prediction Accuracy\n\n")
        header = ["Workload"] + predictors
        f.write("| " + " | ".join(header) + " |\n")
        f.write("| " + " | ".join(["---"] * len(header)) + " |\n")

        for wl in sorted_workloads:
            row = [wl]
            for pred in predictors:
                if pred in results[wl]:
                    acc = float(results[wl][pred]["accuracy"])
                    row.append(f"{acc:.4f}")
                else:
                    row.append("N/A")
            f.write("| " + " | ".join(row) + " |\n")

        # 2. Cycles Comparison
        f.write("\n## Total Cycles\n\n")
        f.write("| " + " | ".join(header) + " |\n")
        f.write("| " + " | ".join(["---"] * len(header)) + " |\n")

        for wl in sorted_workloads:
            row = [wl]
            for pred in predictors:
                if pred in results[wl]:
                    cycles = results[wl][pred]["cycles"]
                    row.append(cycles)
                else:
                    row.append("N/A")
            f.write("| " + " | ".join(row) + " |\n")

        # 3. IPC Comparison (Instructions Per Cycle)
        f.write("\n## IPC (Instructions Per Cycle)\n\n")
        f.write("| " + " | ".join(header) + " |\n")
        f.write("| " + " | ".join(["---"] * len(header)) + " |\n")

        for wl in sorted_workloads:
            row = [wl]
            for pred in predictors:
                if pred in results[wl]:
                    cycles = int(results[wl][pred]["cycles"])
                    instr = int(results[wl][pred]["committed_instructions"])
                    if cycles > 0:
                        ipc = instr / cycles
                        row.append(f"{ipc:.4f}")
                    else:
                        row.append("0.0000")
                else:
                    row.append("N/A")
            f.write("| " + " | ".join(row) + " |\n")

    print("Done!")


if __name__ == "__main__":
    run_benchmark()
