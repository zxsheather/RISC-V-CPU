from dataclasses import dataclass
import re
from unit_tests.tests import *
import argparse
from lsq import LSQ
from rob import ROB
from alu import ALU
from rs import ReservationStation
from decoder import Decoder
from fetcher import Fetcher, FetcherImpl
from assassyn.frontend import *
from assassyn.backend import *
from assassyn import utils
import os
import sys
import struct
import subprocess
from contextlib import redirect_stdout, redirect_stderr
from bpu import *
from multiplier import BoothEncoder, CompressStage1, CompressStage2, FinalAdder
from divider import DivStage1, DivStage2, DivStage3, DivStage4

current_path = os.path.dirname(os.path.abspath(__file__))
workspace = f"{current_path}/.workspace/"
os.makedirs(workspace, exist_ok=True)

sys.path.insert(0, current_path)


def _append_env_flag(env_key: str, flag: str) -> None:
    current = os.environ.get(env_key, "").strip()
    if not current:
        os.environ[env_key] = flag
        return
    parts = current.split()
    if flag in parts:
        return
    os.environ[env_key] = f"{current} {flag}".strip()


def _suppress_rust_warnings_for_cargo_build() -> None:
    # Cargo 会透传 RUSTFLAGS 给 rustc；这里用 -Awarnings 统一屏蔽编译 warning。
    _append_env_flag("RUSTFLAGS", "-Awarnings")


def _is_verbose() -> bool:
    return os.environ.get("CPU_VERBOSE", "0") not in ("0", "", "false", "False")


def _build_log_path() -> str:
    return f"{workspace}/build_simulator.log"


def _run_quiet_to_log(fn, *, log_path: str):
    with open(log_path, "a") as f, redirect_stdout(f), redirect_stderr(f):
        return fn()


class Driver(Module):
    def __init__(self):
        super().__init__(ports={})

    @module.combinational
    def build(self, fetcher: Module):
        fetcher.async_called()


DCACHE_DEPTH_LOG = 16


def make_bpu(kind: str):
    name = kind.replace("-", "_").lower()
    if name in ("tournament"):
        return TournamentBPU()
    if name in ("global"):
        return GlobalHistoryBPU()
    if name in ("two_bit"):
        return TwoBitBPU()
    if name in ("always_false"):
        return AlwaysFalseBPU()
    if name in ("always_true"):
        return AlwaysTakenBPU()
    if name in ("tage"):
        return TageBPU()
    raise ValueError(f"Unsupported BPU kind: {kind}")


def create_test_program(instructions=None):
    """创建测试程序 - 包含多种类型的指令"""
    if instructions is None:
        instructions = [
            0x00000013,  # nop (addi x0, x0, 0)
            0x00100093,  # addi x1, x0, 1
            0x00001137,  # lui x2, 1
            0x00002197,  # auipc x3, 2
            0x00400233,  # add x4, x0, x4 (R-type)
            0x00002283,  # lw x5, 0(x0) (I-type load)
            0x00502023,  # sw x5, 0(x0) (S-type store)
            0x00000063,  # beq x0, x0, 0 (B-type branch)
            0x0000006F,  # jal x0, 0 (J-type jump)
        ]
    num_instructions = len(instructions)

    workload_path = f"{workspace}/workload.exe"

    # 生成十六进制文本格式（每行一条指令，32位）
    with open(workload_path, "w") as f:
        f.write("@00000000\n")  # 起始地址
        for inst in instructions:
            # 直接写入32位十六进制值
            f.write(f"{inst:08x}\n")

    print(f"✓ 测试程序已生成: {workload_path}")
    return num_instructions


def _write_workload_exe_from_hex_list(instructions, out_path: str):
    with open(out_path, "w") as f:
        f.write("@00000000\n")
        for inst in instructions:
            f.write(f"{inst:08x}\n")


def _ensure_file(path: str, *, default_content: str = ""):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if not os.path.exists(path):
        with open(path, "w") as f:
            f.write(default_content)


@dataclass(frozen=True)
class WorkloadCase:
    name: str
    txt_path: str
    ans_path: str | None


def discover_workload_cases() -> list[WorkloadCase]:
    base = os.path.join(current_path, "workload")
    cases: list[WorkloadCase] = []
    if not os.path.isdir(base):
        return cases

    for entry in sorted(os.listdir(base)):
        folder = os.path.join(base, entry)
        if not os.path.isdir(folder):
            continue

        txt_path = os.path.join(folder, f"{entry}.txt")
        if not os.path.exists(txt_path):
            continue

        ans_path = os.path.join(folder, f"{entry}.ans")
        if not os.path.exists(ans_path):
            ans_path = None

        cases.append(
            WorkloadCase(
                name=entry,
                txt_path=txt_path,
                ans_path=ans_path,
            )
        )

    return cases


def parse_last_cycle_from_log(log_path: str) -> int:
    last_cycle = None
    pat = re.compile(r"Cycle\s*@\s*([0-9]+)(?:\.\d+)?")
    with open(log_path, "r") as f:
        for line in f:
            m = pat.search(line)
            if m:
                last_cycle = int(m.group(1))
    if last_cycle is None:
        raise ValueError(f"no Cycle tag found in {log_path}")
    return last_cycle


def parse_last_rs_value_from_log(log_path: str) -> int:
    if not os.path.exists(log_path):
        raise FileNotFoundError(f"找不到日志文件: {log_path}")

    last_line = ""
    with open(log_path, "r") as f:
        for line in f:
            if line.strip():
                last_line = line.rstrip("\n")

    if not last_line:
        raise ValueError(f"日志为空: {log_path}")

    # 典型示例: "@line:786   Cycle @38177.00: [RS]\t0"
    m = re.search(r"\[RS\]\s*(-?\d+)\s*$", last_line)
    if m:
        return int(m.group(1))

    # 兜底：取最后一个整数
    m = re.search(r"(-?\d+)\s*$", last_line)
    if m:
        return int(m.group(1))

    raise ValueError(f"无法从日志最后一行解析数值: {last_line}")


def parse_stats_from_log(log_path: str) -> dict:
    stats = {
        "committed_instructions": 0,
        "total_branches": 0,
        "correctly_predicted_branches": 0,
        "accuracy": 0.0
    }

    if not os.path.exists(log_path):
        return stats

    with open(log_path, "r") as f:
        content = f.read()

    m = re.search(r"Committed Instructions:\s*(\d+)", content)
    if m:
        stats["committed_instructions"] = int(m.group(1))

    m = re.search(r"Total Branches:\s*(\d+)", content)
    if m:
        stats["total_branches"] = int(m.group(1))

    m = re.search(r"Correctly Predicted Branches:\s*(\d+)", content)
    if m:
        stats["correctly_predicted_branches"] = int(m.group(1))

    if stats["total_branches"] > 0:
        stats["accuracy"] = stats["correctly_predicted_branches"] / \
            stats["total_branches"]

    return stats


def read_expected_from_ans(ans_path: str) -> int:
    with open(ans_path, "r") as f:
        content = f.read().strip()
    if content == "":
        raise ValueError(f"ans 文件为空: {ans_path}")
    return int(content, 0)


def build_simulator(
    max_cycles=50,
    icache_init_file: str | None = None,
    dcache_init_file: str | None = None,
    bpu_kind: str = "global",
    *,
    generate_verilog: bool | None = None,
):
    """只构建（elaborate+编译）仿真器，返回二进制路径与 verilog 输出路径。"""
    depth_log = 16  # 2^14 = 16,384条指令空间（默认）；
    if dcache_init_file is None:
        dcache_init_file = icache_init_file

    sys_obj = SysBuilder("my_cpu")

    with sys_obj:
        fetcher = Fetcher()
        pc_reg, pc_addr = fetcher.build()

        commit_counter = RegArray(Int(32), 1)
        prediction_counter = RegArray(Int(32), 1)
        prediction_correction_counter = RegArray(Int(32), 1)

        icache = SRAM(width=32, depth=1 << depth_log,
                      init_file=icache_init_file)
        icache.name = "icache"

        ifetch_continue_flag = RegArray(Bits(1), 1, initializer=[1])

        alu_value_to_rob = RegArray(Bits(32), 1)
        alu_valid_to_rob = RegArray(Bits(1), 1)
        alu_index_to_rob = RegArray(Bits(32), 1)
        alu = ALU()
        alu.build(alu_value_to_rob, alu_index_to_rob, alu_valid_to_rob)

        mul_value_to_rob = RegArray(Bits(32), 1)
        mul_valid_to_rob = RegArray(Bits(1), 1)
        mul_index_to_rob = RegArray(Bits(32), 1)
        booth_encoder = BoothEncoder()
        compress_stage1 = CompressStage1()
        compress_stage2 = CompressStage2()
        final_adder = FinalAdder()
        booth_encoder.build(compress_stage1)
        compress_stage1.build(compress_stage2)
        compress_stage2.build(final_adder)
        final_adder.build(
            result=mul_value_to_rob,
            tag_out=mul_index_to_rob,
            valid_out=mul_valid_to_rob,
        )

        # Divider pipeline (4 stages)
        div_value_to_rob = RegArray(Bits(32), 1)
        div_valid_to_rob = RegArray(Bits(1), 1)
        div_index_to_rob = RegArray(Bits(32), 1)
        div_stage1 = DivStage1()
        div_stage2 = DivStage2()
        div_stage3 = DivStage3()
        div_stage4 = DivStage4()
        div_stage1.build(div_stage2)
        div_stage2.build(div_stage3)
        div_stage3.build(div_stage4)
        div_stage4.build(
            div_result=div_value_to_rob,
            div_tag_out=div_index_to_rob,
            div_valid_out=div_valid_to_rob,
        )

        rob_bypass_valid_to_if = RegArray(Bits(1), 1)
        rob_bypass_pc_to_if = RegArray(Bits(32), 1)
        rob_bypass_is_jump_to_if = RegArray(Bits(1), 1)
        rob_bypass_valid_to_rs = RegArray(Bits(1), 1)
        rob_bypass_need_update_to_rs = RegArray(Bits(1), 1)
        rob_bypass_index_to_rs = RegArray(Bits(32), 1)
        revert_flag_cdb = RegArray(Bits(1), 1)

        lsq_bypass_sq_pos_to_rs = RegArray(Bits(32), 1)
        lsq_bypass_valid_to_rs = RegArray(Bits(1), 1)

        dcache = SRAM(width=32, depth=1 << DCACHE_DEPTH_LOG,
                      init_file=dcache_init_file)
        dcache.name = "dcache"

        lsb_out_valid_to_rob = RegArray(Bits(1), 1)
        lsb_rob_dest_to_rob = RegArray(Bits(32), 1)
        rob_commit_sq_pos_to_lsq = RegArray(Bits(32), 1)
        rob_commit_valid_to_lsq = RegArray(Bits(1), 1)
        lsq_mem_addr_to_rob = RegArray(Bits(32), 1)

        lsq = LSQ()
        lsq.build(
            dcache=dcache,
            depth_log=DCACHE_DEPTH_LOG,
            out_valid_to_rob=lsb_out_valid_to_rob,
            rob_dest_to_rob=lsb_rob_dest_to_rob,
            commit_sq_pos_from_rob=rob_commit_sq_pos_to_lsq,
            commit_valid_from_rob=rob_commit_valid_to_lsq,
            revert_flag_cdb=revert_flag_cdb,
            valid_to_rs=lsq_bypass_valid_to_rs,
            update_sq_pos_to_rs=lsq_bypass_sq_pos_to_rs,
            mem_addr_to_rob=lsq_mem_addr_to_rob,
            dout=dcache.dout
        )

        bpu_predicted_pc = RegArray(Bits(32), 1)
        bpu_predict_taken = RegArray(Bits(1), 1)
        rob_commit_branch_to_bpu = RegArray(Bits(1), 1)
        rob_actual_taken_to_bpu = RegArray(Bits(1), 1)
        rob_pc_addr_to_bpu = RegArray(Bits(32), 1)

        rob = ROB()
        rob.build(
            out_valid_to_rs=rob_bypass_valid_to_rs,
            need_update_to_rs=rob_bypass_need_update_to_rs,
            index_to_rs=rob_bypass_index_to_rs,
            revert_flag_cdb=revert_flag_cdb,
            bypass_valid_to_if=rob_bypass_valid_to_if,
            updated_pc_to_if=rob_bypass_pc_to_if,
            commit_branch_to_bpu=rob_commit_branch_to_bpu,
            actual_taken_to_bpu=rob_actual_taken_to_bpu,
            pc_addr_to_bpu=rob_pc_addr_to_bpu,
            alu_valid_from_alu=alu_valid_to_rob,
            alu_value_from_alu=alu_value_to_rob,
            rob_index_from_alu=alu_index_to_rob,
            in_valid_from_lsq=lsb_out_valid_to_rob,
            lsq_value_from_lsq=dcache.dout,
            rob_dest_from_lsq=lsb_rob_dest_to_rob,
            commit_sq_pos_to_lsq=rob_commit_sq_pos_to_lsq,
            commit_valid_to_lsq=rob_commit_valid_to_lsq,
            mul_valid_from_mul=mul_valid_to_rob,
            mul_value_from_mul=mul_value_to_rob,
            mul_rob_index_from_mul=mul_index_to_rob,
            div_valid_from_div=div_valid_to_rob,
            div_value_from_div=div_value_to_rob,
            div_rob_index_from_div=div_index_to_rob,
            commit_counter=commit_counter,
            prediction_counter=prediction_counter,
            prediction_correction_counter=prediction_correction_counter
        )

        rs = ReservationStation()
        rs.build(
            in_valid_from_rob=rob_bypass_valid_to_rs,
            need_update_from_rob=rob_bypass_need_update_to_rs,
            in_index_from_rob=rob_bypass_index_to_rs,
            jump_from_bpu=bpu_predict_taken,
            in_valid_from_lsq=lsq_bypass_valid_to_rs,
            sq_pos_from_lsq=lsq_bypass_sq_pos_to_rs,
            ifetch_continue_flag=ifetch_continue_flag,
            rob=rob,
            lsq=lsq,
            alu=alu,
            mul=booth_encoder,
            div=div_stage1,
            revert_flag_cdb=revert_flag_cdb,
            commit_counter=commit_counter,
            prediction_counter=prediction_counter,
            prediction_correction_counter=prediction_correction_counter,
            # CDB signals - results computed in RS instead of waiting for ROB commit
            alu_cdb_valid=alu_valid_to_rob,
            alu_cdb_value=alu_value_to_rob,
            alu_cdb_rob_idx=alu_index_to_rob,
            mul_cdb_valid=mul_valid_to_rob,
            mul_cdb_value=mul_value_to_rob,
            mul_cdb_rob_idx=mul_index_to_rob,
            div_cdb_valid=div_valid_to_rob,
            div_cdb_value=div_value_to_rob,
            div_cdb_rob_idx=div_index_to_rob,
            lsq_cdb_valid=lsb_out_valid_to_rob,
            lsq_cdb_value=dcache.dout,
            lsq_cdb_rob_idx=lsb_rob_dest_to_rob,
            lsq_cdb_mem_addr=lsq_mem_addr_to_rob,
        )

        decoder = Decoder()
        is_jal, is_branch, fetch_pc_from_d, target_pc = decoder.build(
            icache.dout, rs, revert_flag_cdb
        )

        bpu = make_bpu(bpu_kind)
        predict_taken, predicted_pc = bpu.build(
            pc_addr_from_d=fetch_pc_from_d,
            target_pc_from_d=target_pc,
            is_branch_from_d=is_branch,
            predicted_pc=bpu_predicted_pc,
            predict_taken=bpu_predict_taken,
            commit_branch_from_rob=rob_commit_branch_to_bpu,
            actual_taken_from_rob=rob_actual_taken_to_bpu,
            pc_addr_from_rob=rob_pc_addr_to_bpu,
        )

        fetch_impl = FetcherImpl()
        fetch_impl.build(
            pc_addr_from_f=pc_addr,
            pc_reg_from_f=pc_reg,
            is_jal_from_d=is_jal,
            is_branch_from_d=is_branch,
            target_pc_from_d=target_pc,
            predict_taken_from_bpu=predict_taken,
            predicted_pc_from_bpu=predicted_pc,
            icache=icache,
            depth_log=depth_log,
            decoder=decoder,
            continue_flag_from_rs=ifetch_continue_flag,
            in_valid_from_rob=rob_bypass_valid_to_if,
            updated_pc_from_rob=rob_bypass_pc_to_if,
            is_jump_from_rob=rob_bypass_is_jump_to_if,
            revert_flag_cdb=revert_flag_cdb,
        )
        # 创建 Driver
        driver = Driver()
        driver.build(fetcher=fetcher)

    print("\n系统结构:")
    if _is_verbose():
        print(sys_obj)
    else:
        print(f"(已隐藏详细结构输出；需要可设 CPU_VERBOSE=1，完整日志: {_build_log_path()})")

    # 配置仿真参数
    if generate_verilog is None:
        generate_verilog = bool(utils.has_verilator())

    conf = config(
        verilog=bool(generate_verilog),  # 生成 Verilog
        sim_threshold=max_cycles,  # 最大运行周期数
        idle_threshold=max_cycles,
        resource_base="",
        fifo_depth=1,
    )

    print("\n正在生成仿真器...")
    log_path = _build_log_path()
    if not _is_verbose():
        simulator_path, verilog_path = _run_quiet_to_log(
            lambda: elaborate(sys_obj, **conf),
            log_path=log_path,
        )
    else:
        simulator_path, verilog_path = elaborate(sys_obj, **conf)

    print(f"✓ 仿真器代码: {simulator_path}")
    print(f"✓ Verilog 代码: {verilog_path}")

    print("\n正在编译仿真器...")
    _suppress_rust_warnings_for_cargo_build()
    if not _is_verbose():
        simulator_binary = _run_quiet_to_log(
            lambda: utils.build_simulator(simulator_path),
            log_path=log_path,
        )
    else:
        simulator_binary = utils.build_simulator(simulator_path)
    print(f"✓ 仿真器二进制: {simulator_binary}")

    return simulator_binary, verilog_path


def run_simulator(
    simulator_binary: str,
    *,
    timeout_s: int = 10000,
    log_file_path: str | None = None,
    verilog_path: str | None = None,
    run_verilog: bool = True,
) -> bool:
    """运行已编译好的仿真器，并把 stdout/stderr 写入 .workspace/simulation.log。"""
    if log_file_path is None:
        log_file_path = f"{workspace}/simulation.log"

    print("\n正在运行仿真...")
    result = subprocess.run(
        [simulator_binary], capture_output=True, text=True, timeout=timeout_s
    )

    with open(log_file_path, "w") as f:
        if result.stdout:
            f.write(result.stdout)
        if result.stderr:
            f.write("\n错误/警告:\n")
            f.write(result.stderr)

    print(f"✓ 仿真日志已保存至: {log_file_path}")

    # Run Verilator simulation (可选)
    if run_verilog and verilog_path and utils.has_verilator():
        print("\n正在运行 Verilog 仿真...")
        verilog_log = utils.run_verilator(verilog_path)
        verilog_log_path = f"{workspace}/simulation.verilog.log"
        with open(verilog_log_path, "w") as f:
            f.write(verilog_log)
        print(f"✓ Verilog 仿真日志已保存至: {verilog_log_path}")

    # print("\n" + "=" * 70)
    # print("仿真输出:")
    # print("=" * 70)
    # if result.stdout:
    #     print(result.stdout)
    if result.stderr:
        print("\n错误/警告:")
        print(result.stderr)

    return result.returncode == 0


def build_and_run(
    max_cycles=50,
    bpu_kind="global",
    *,
    run_verilog: bool = True,
):
    """兼容旧接口：构建并运行一次仿真"""
    icache_init_file = f"{workspace}/workload.exe"
    dcache_init_file = icache_init_file
    simulator_binary, verilog_path = build_simulator(
        max_cycles=max_cycles,
        icache_init_file=icache_init_file,
        dcache_init_file=dcache_init_file,
        bpu_kind=bpu_kind,
        generate_verilog=run_verilog,
    )
    success = run_simulator(
        simulator_binary,
        verilog_path=verilog_path,
        run_verilog=run_verilog,
    )

    return success, verilog_path


def run_all_workloads(
    max_cycles: int,
    *,
    timeout_s: int = 10000,
    bpu_kind="global",
    skip_verilator: bool = False,
    stat_file: str | None = None,
) -> int:
    """编译一次仿真器，然后运行 workload/ 下所有子目录用例并校验 .ans。"""
    cases = discover_workload_cases()
    if not cases:
        print("✗ 未发现任何 workload 用例（workload/<name>/<name>.txt）")
        return 1

    # 使用固定的 init_file 路径，便于“编译一次，多次运行”
    icache_init_file = f"{workspace}/workload.exe"
    _ensure_file(icache_init_file, default_content="@00000000\n00000013\n")

    print("=" * 70)
    print(f"全量 workload 回归: {', '.join([c.name for c in cases])}")
    print(f"最大周期数: {max_cycles} 分支预测: {bpu_kind}")
    print("=" * 70)

    print("\n[步骤 0] 编译仿真器（一次）")
    simulator_binary, verilog_path = build_simulator(
        max_cycles=max_cycles,
        icache_init_file=icache_init_file,
        dcache_init_file=icache_init_file,
        bpu_kind=bpu_kind,
        generate_verilog=not skip_verilator,
    )

    passed = 0
    failed = 0
    failures: list[str] = []
    cycle_counts: list[str] = []

    all_stats = []

    print("\n[步骤 1] 运行 Python 仿真器并校验（先跑完所有用例）")
    for case in cases:
        print("\n" + "-" * 70)
        print(f"[用例] {case.name}")

        # 1) 准备 icache/dcache init 文件
        instructions = load_workload_file(case.name)
        _write_workload_exe_from_hex_list(instructions, icache_init_file)

        # 2) 运行仿真
        log_file = f"{workspace}/simulation.log"
        ok = run_simulator(
            simulator_binary,
            timeout_s=timeout_s,
            log_file_path=log_file,
            verilog_path=verilog_path,
            run_verilog=False,
        )

        if not ok:
            failed += 1
            failures.append(f"{case.name}: 仿真返回非 0")
            continue

        # 3) 校验
        if not case.ans_path:
            print("✗ 缺少 .ans 文件，跳过比对")
            failed += 1
            failures.append(f"{case.name}: 缺少 .ans")
            continue

        got = parse_last_rs_value_from_log(log_file)
        expected = read_expected_from_ans(case.ans_path)

        if got == expected:
            print(f"✓ PASS: got={got} expected={expected}")
            passed += 1
        else:
            print(f"✗ FAIL: got={got} expected={expected}")
            failed += 1
            failures.append(f"{case.name}: got={got} expected={expected}")

        cycles = parse_last_cycle_from_log(log_file)
        print(f"Total cycles={cycles}")
        cycle_counts.append(f"{case.name}: cycle={cycles}")

        # 收集统计信息
        if stat_file:
            stats = parse_stats_from_log(log_file)
            stats["name"] = case.name
            stats["cycles"] = cycles
            all_stats.append(stats)

    # 写入统计文件
    if stat_file and all_stats:
        try:
            with open(stat_file, "w") as f:
                # 写入 CSV 头
                f.write(
                    "workload,cycles,committed_instructions,total_branches,correctly_predicted_branches,accuracy\n")
                for s in all_stats:
                    f.write(
                        f"{s['name']},{s['cycles']},{s['committed_instructions']},{s['total_branches']},{s['correctly_predicted_branches']},{s['accuracy']:.4f}\n")
            print(f"\n✓ 统计信息已写入: {stat_file}")
        except Exception as e:
            print(f"\n✗ 写入统计文件失败: {e}")

    # 第二阶段：统一跑 Verilator（若可用）
    if skip_verilator:
        print("\n[步骤 2] 跳过 Verilator：已通过 --skip-verilator 禁用")
    elif verilog_path and utils.has_verilator():
        print("\n[步骤 2] 运行 Verilator（在所有 simulator 用例完成之后）")
        for case in cases:
            print("\n" + "-" * 70)
            print(f"[Verilator 用例] {case.name}")

            # 重新准备 init 文件，确保 Verilator 读取到对应 workload 的镜像
            instructions = load_workload_file(case.name)
            _write_workload_exe_from_hex_list(instructions, icache_init_file)

            print("正在运行 Verilog 仿真...")
            verilog_log = utils.run_verilator(verilog_path)
            verilog_log_path = f"{workspace}/simulation.verilog.{case.name}.log"
            with open(verilog_log_path, "w") as f:
                f.write(verilog_log)
            print(f"✓ Verilog 仿真日志已保存至: {verilog_log_path}")
    elif utils.has_verilator():
        # 理论上不会发生，但保留提示，便于排查 elaborate 未产出 verilog_path 的情况
        print("\n[步骤 2] 跳过 Verilator：未生成 verilog_path")
    else:
        print("\n[步骤 2] 跳过 Verilator：系统未检测到 verilator")

    print("\n" + "=" * 70)
    print(f"回归结果: PASS {passed}, FAIL {failed}")
    for item in cycle_counts:
        print(f"{item}")
    if failures:
        print("失败列表:")
        for item in failures:
            print(f"- {item}")
    print("=" * 70)

    return 0 if failed == 0 else 1


def run_single_init_file(
    init_file: str,
    *,
    max_cycles: int,
    bpu_kind: str,
    skip_verilator: bool,
) -> int:
    """使用用户提供的统一镜像文件作为 icache/dcache init，跳过 .ans 校验。"""
    init_file = os.path.abspath(init_file)
    if not os.path.exists(init_file):
        print(f"✗ 错误: 找不到 init 文件 {init_file}")
        return 1

    print("=" * 70)
    print(f"单一 init 文件: {init_file}")
    print(
        f"分支预测: {bpu_kind} 最大周期数: {max_cycles} 跳过 Verilator: {skip_verilator}"
    )
    print("=" * 70)

    log_file = f"{workspace}/simulation.log"
    simulator_binary, verilog_path = build_simulator(
        max_cycles=max_cycles,
        icache_init_file=init_file,
        dcache_init_file=init_file,
        bpu_kind=bpu_kind,
        generate_verilog=not skip_verilator,
    )

    ok = run_simulator(
        simulator_binary,
        log_file_path=log_file,
        verilog_path=verilog_path,
        run_verilog=not skip_verilator,
    )

    if ok:
        try:
            value = parse_last_rs_value_from_log(log_file)
            cycles = parse_last_cycle_from_log(log_file)
            print(f"✓ 仿真完成: got={value} cycles={cycles}")
        except Exception as e:
            print(f"✓ 仿真完成（结果解析失败: {e}）")
    else:
        print("✗ 仿真返回非 0")

    return 0 if ok else 1


def load_workload_file(filename):
    """从 workload 文件夹加载统一的内存初始化文件（指令 + 数据）
    支持三种格式:
    1. workload/xxx.txt - 直接加载文件
    2. workload/xxx/xxx.txt - 从子文件夹加载
    3. workload/xxx - 自动从子文件夹加载 xxx/xxx.txt
    """

    # 检查是否包含文件夹路径或扩展名
    if "/" in filename:
        # 格式: folder/file.txt
        workload_path = os.path.join(current_path, "workload", filename)
        folder_name = filename.split("/")[0]
    elif not filename.endswith(".txt"):
        # 格式: folder (不含扩展名) - 自动查找 folder/folder.txt
        folder_name = filename
        workload_path = os.path.join(
            current_path, "workload", folder_name, f"{folder_name}.txt"
        )
    else:
        # 格式: file.txt
        workload_path = os.path.join(current_path, "workload", filename)

    if not os.path.exists(workload_path):
        print(f"✗ 错误: 找不到文件 {workload_path}")
        sys.exit(1)

    instructions = []
    with open(workload_path, "r") as f:
        for line in f:
            line = line.strip()

            # 移除 // 后的注释
            if "//" in line:
                line = line.split("//")[0].strip()

            # 跳过空行和注释
            if not line or line.startswith("#") or line.startswith("@"):
                continue
            try:
                # 将十六进制字符串转换为整数
                inst = int(line, 16)
                instructions.append(inst)
            except ValueError:
                print(f"✗ 警告: 无法解析指令: {line}")
                continue

    print(f"✓ 从 {filename} 加载了 {len(instructions)} 个 word（指令/数据）")

    return instructions


def main():
    parser = argparse.ArgumentParser(description="Run Toy CPU tests")
    parser.add_argument(
        "--all-workloads",
        action="store_true",
        help="Compile simulator once then run and verify all workload/*/* tests",
    )
    parser.add_argument(
        "--test",
        choices=[
            "default",
            "war",
            "waw",
            "raw",
            "ls1",
            "br1",
            "brm1",
            "lui_auipc",
            "jal",
            "jalr",
            "jal_jalr",
            "sum_0_to_100",
            "sb",
            "sb2",
        ],
        default="default",
        help="Select test case",
    )
    parser.add_argument(
        "--workload",
        type=str,
        help="Load instructions from a file in workload/ directory (e.g., 0to100/0to100.txt or file.txt)",
    )
    parser.add_argument(
        "--max-cycles",
        type=int,
        default=None,
        help="Maximum number of simulation cycles to run (default: 50 for single test, 100000000 for all workloads)",
    )
    parser.add_argument(
        "--predictor",
        choices=["tournament", "global", "two_bit",
                 "always_false", "always_true", "tage"],
        default="global",
        help="Choose branch predictor",
    )
    parser.add_argument(
        "--skip-verilator",
        action="store_true",
        help="Skip Verilator (only run Rust simulator).",
    )
    parser.add_argument(
        "--init-file",
        type=str,
        help="Use a single init file (hex/word-per-line) for both icache and dcache; run simulator/Verilator once without ans check.",
    )
    parser.add_argument(
        "--stat",
        nargs="?",
        const=".workspace/stats.csv",
        help="Output statistics to a CSV file (default: .workspace/stats.csv). Implies --all-workloads.",
    )
    args = parser.parse_args()

    # 如果指定了 --stat，隐含 --all-workloads
    if args.stat is not None:
        args.all_workloads = True

    # 约定：直接 `python main.py`（无任何参数）时，跑全量 workload 回归。
    if len(sys.argv) == 1 and not args.all_workloads:
        args.all_workloads = True
        args.skip_verilator = False

    if len(sys.argv) == 2 and sys.argv[1] == "--skip-verilator":
        args.all_workloads = True
        args.skip_verilator = True

    # 设置默认 max_cycles
    if args.max_cycles is None:
        if args.all_workloads:
            args.max_cycles = 100000000
        else:
            args.max_cycles = 50

    if args.all_workloads:
        exit_code = run_all_workloads(
            max_cycles=args.max_cycles,
            skip_verilator=args.skip_verilator,
            stat_file=args.stat,
            bpu_kind=args.predictor,
        )
        sys.exit(exit_code)

    if args.init_file:
        exit_code = run_single_init_file(
            init_file=args.init_file,
            max_cycles=args.max_cycles,
            bpu_kind=args.predictor,
            skip_verilator=args.skip_verilator,
        )
        sys.exit(exit_code)

    print("=" * 70)
    if args.workload:
        print(f"工作负载: {args.workload} 分支预测: {args.predictor}")
    else:
        print(f"测试: {args.test} 分支预测: {args.predictor}")
    print("=" * 70)

    instructions = None

    # 优先使用 --workload 选项
    if args.workload:
        instructions = load_workload_file(args.workload)
    elif args.test == "war":
        instructions = war_hazard_test()
    elif args.test == "waw":
        instructions = waw_hazard_test()
    elif args.test == "raw":
        instructions = raw_hazard_test()
    elif args.test == "ls1":
        instructions = load_store_test_1()
    elif args.test == "br1":
        instructions = branch_test()
    elif args.test == "brm1":
        instructions = branch_mem_test()
    elif args.test == "lui_auipc":
        instructions = lui_auipc_test()
    elif args.test == "jal":
        instructions = jal_test()
    elif args.test == "jalr":
        instructions = jalr_test()
    elif args.test == "jal_jalr":
        instructions = jal_jalr_combined_test()
    elif args.test == "sum_0_to_100":
        instructions = sum_0_to_100_test()
    elif args.test == "sb":
        instructions = store_byte_halfword_test()
    elif args.test == "sb2":
        instructions = store_byte_halfword_test_2()

    # 1. 创建测试程序
    print("\n[步骤 1] 创建测试程序")
    create_test_program(instructions)

    # 2. 构建并运行
    print(f"\n[步骤 2] 构建并运行仿真 (最大周期数: {args.max_cycles})")
    success, verilog_path = build_and_run(
        max_cycles=args.max_cycles,
        run_verilog=not args.skip_verilator,
        bpu_kind=args.predictor
    )

    if success:
        print("\n✓ 仿真成功完成")
    else:
        print("\n✗ 仿真过程中出现错误")
        sys.exit(1)


if __name__ == "__main__":
    main()
