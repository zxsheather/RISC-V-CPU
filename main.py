from assassyn.frontend import *
from assassyn.backend import *
from assassyn import utils
import os
import sys
import struct
import subprocess

current_path = os.path.dirname(os.path.abspath(__file__))
workspace = f"{current_path}/.workspace/"
os.makedirs(workspace, exist_ok=True)

sys.path.insert(0, current_path)
from fetcher import Fetcher, FetcherImpl
from decoder import Decoder
from rs import ReservationStation
from alu import ALU
from rob import ROB
from lsq import LSQ


import argparse
from unit_tests.tests import *
import re
from dataclasses import dataclass


class Driver(Module):
    def __init__(self):
        super().__init__(ports={})

    @module.combinational
    def build(self, fetcher: Module):
        fetcher.async_called()


DCACHE_DEPTH_LOG = 16


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


def _copy_text_file(src_path: str, dst_path: str):
    with open(src_path, "r") as src, open(dst_path, "w") as dst:
        dst.write(src.read())


def _ensure_file(path: str, *, default_content: str = ""):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if not os.path.exists(path):
        with open(path, "w") as f:
            f.write(default_content)


@dataclass(frozen=True)
class WorkloadCase:
    name: str
    txt_path: str
    data_path: str | None
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

        data_path = os.path.join(folder, f"{entry}.data")
        if not os.path.exists(data_path):
            data_path = None

        ans_path = os.path.join(folder, f"{entry}.ans")
        if not os.path.exists(ans_path):
            ans_path = None

        cases.append(
            WorkloadCase(name=entry, txt_path=txt_path, data_path=data_path, ans_path=ans_path)
        )

    return cases


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


def read_expected_from_ans(ans_path: str) -> int:
    with open(ans_path, "r") as f:
        content = f.read().strip()
    if content == "":
        raise ValueError(f"ans 文件为空: {ans_path}")
    return int(content, 0)


def build_simulator(max_cycles=50, icache_init_file: str | None = None, dcache_init_file: str | None = None):
    """只构建（elaborate+编译）仿真器，返回二进制路径与 verilog 输出路径。"""
    depth_log = 8  # 2^8 = 256条指令空间

    sys_obj = SysBuilder("my_cpu")

    with sys_obj:
        fetcher = Fetcher()
        pc_reg, pc_addr = fetcher.build()

        icache = SRAM(width=32, depth=1 << depth_log, init_file=icache_init_file)
        icache.name = "icache"

        ifetch_continue_flag = RegArray(Bits(1), 1, initializer=[1])

        alu_value_to_rob = RegArray(Bits(32), 1)
        alu_valid_to_rob = RegArray(Bits(1), 1)
        alu_index_to_rob = RegArray(Bits(32), 1)
        alu = ALU()
        alu.build(alu_value_to_rob, alu_index_to_rob, alu_valid_to_rob)

        rob_bypass_valid_to_if = RegArray(Bits(1), 1)
        rob_bypass_pc_to_if = RegArray(Bits(32), 1)
        rob_bypass_is_jump_to_if = RegArray(Bits(1), 1)
        rob_bypass_valid_to_rs = RegArray(Bits(1), 1)
        rob_bypass_need_update_to_rs = RegArray(Bits(1), 1)
        rob_bypass_value_to_rs = RegArray(Bits(32), 1)
        rob_bypass_index_to_rs = RegArray(Bits(32), 1)
        revert_flag_cdb = RegArray(Bits(1), 1)

        lsq_bypass_sq_pos_to_rs = RegArray(Bits(32), 1)
        lsq_bypass_valid_to_rs = RegArray(Bits(1), 1)

        dcache = SRAM(width=32, depth=1 << DCACHE_DEPTH_LOG, init_file=dcache_init_file)
        dcache.name = "dcache"

        lsb_out_valid_to_rob = RegArray(Bits(1), 1)
        lsb_rob_dest_to_rob = RegArray(Bits(32), 1)
        rob_commit_sq_pos_to_lsq = RegArray(Bits(32), 1)
        rob_commit_valid_to_lsq = RegArray(Bits(1), 1)

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
        )

        rob = ROB()
        rob.build(
            alu=alu,
            out_valid_to_rs=rob_bypass_valid_to_rs,
            value_to_rs=rob_bypass_value_to_rs,
            index_to_rs=rob_bypass_index_to_rs,
            revert_flag_cdb=revert_flag_cdb,
            bypass_valid_to_if=rob_bypass_valid_to_if,
            updated_pc_to_if=rob_bypass_pc_to_if,
            is_jump_to_if=rob_bypass_is_jump_to_if,
            alu_valid_from_alu=alu_valid_to_rob,
            alu_value_from_alu=alu_value_to_rob,
            rob_index_from_alu=alu_index_to_rob,
            in_valid_from_lsq=lsb_out_valid_to_rob,
            value_from_dcache=dcache.dout,
            rob_dest_from_lsq=lsb_rob_dest_to_rob,
            commit_sq_pos_to_lsq=rob_commit_sq_pos_to_lsq,
            commit_valid_to_lsq=rob_commit_valid_to_lsq,
            need_update_to_rs=rob_bypass_need_update_to_rs
        )

        rs = ReservationStation()
        rs.build(
            in_valid_from_rob=rob_bypass_valid_to_rs,
            need_update_from_rob=rob_bypass_need_update_to_rs,
            in_index_from_rob=rob_bypass_index_to_rs,
            value_from_rob=rob_bypass_value_to_rs,
            in_valid_from_lsq=lsq_bypass_valid_to_rs,
            sq_pos_from_lsq=lsq_bypass_sq_pos_to_rs,
            ifetch_continue_flag=ifetch_continue_flag,
            rob=rob,
            lsq=lsq,
            revert_flag_cdb=revert_flag_cdb,
        )

        decoder = Decoder()
        is_jal, is_branch, updated_pc, is_nop, jump = decoder.build(icache.dout, rs, revert_flag_cdb)

        fetch_impl = FetcherImpl()
        fetch_impl.build(
            pc_addr_from_f=pc_addr,
            pc_reg_from_f=pc_reg,
            is_jal_from_d=is_jal,
            is_branch_from_d=is_branch,
            is_nop_from_d=is_nop,
            jump_from_d=jump,
            updated_pc_from_d=updated_pc,
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
    print(sys_obj)

    # 配置仿真参数
    conf = config(
        verilog=bool(utils.has_verilator()),  # 生成 Verilog
        sim_threshold=max_cycles,  # 最大运行周期数
        idle_threshold=max_cycles,
        resource_base="",
        fifo_depth=1,
    )

    print("\n正在生成仿真器...")
    simulator_path, verilog_path = elaborate(sys_obj, **conf)

    print(f"✓ 仿真器代码: {simulator_path}")
    print(f"✓ Verilog 代码: {verilog_path}")

    print("\n正在编译仿真器...")
    simulator_binary = utils.build_simulator(simulator_path)
    print(f"✓ 仿真器二进制: {simulator_binary}")

    return simulator_binary, verilog_path


def run_simulator(simulator_binary: str, *, timeout_s: int = 30, log_file_path: str | None = None) -> bool:
    """运行已编译好的仿真器，并把 stdout/stderr 写入 .workspace/simulation.log。"""
    if log_file_path is None:
        log_file_path = f"{workspace}/simulation.log"

    print("\n正在运行仿真...")
    result = subprocess.run([simulator_binary], capture_output=True, text=True, timeout=timeout_s)

    with open(log_file_path, "w") as f:
        if result.stdout:
            f.write(result.stdout)
        if result.stderr:
            f.write("\n错误/警告:\n")
            f.write(result.stderr)

    print(f"✓ 仿真日志已保存至: {log_file_path}")

    # Run Verilator simulation (可选)
    # 注：Verilator 路径由 elaborate 的输出决定；这里只保留原行为（如果需要可再扩展）。

    # print("\n" + "=" * 70)
    # print("仿真输出:")
    # print("=" * 70)
    # if result.stdout:
    #     print(result.stdout)
    if result.stderr:
        print("\n错误/警告:")
        print(result.stderr)

    return result.returncode == 0


def build_and_run(max_cycles=50, dcache_init_file=None):
    """兼容旧接口：构建并运行一次仿真"""
    icache_init_file = f"{workspace}/workload.exe"
    simulator_binary, verilog_path = build_simulator(
        max_cycles=max_cycles, icache_init_file=icache_init_file, dcache_init_file=dcache_init_file
    )
    success = run_simulator(simulator_binary)

    # 旧逻辑：可选 Verilator 仿真
    if utils.has_verilator():
        print("\n正在运行 Verilog 仿真...")
        verilog_log = utils.run_verilator(verilog_path)
        verilog_log_path = f"{workspace}/simulation.verilog.log"
        with open(verilog_log_path, "w") as f:
            f.write(verilog_log)
        print(f"✓ Verilog 仿真日志已保存至: {verilog_log_path}")

    return success, verilog_path


def run_all_workloads(max_cycles: int, *, timeout_s: int = 30) -> int:
    """编译一次仿真器，然后运行 workload/ 下所有子目录用例并校验 .ans。"""
    cases = discover_workload_cases()
    if not cases:
        print("✗ 未发现任何 workload 用例（workload/<name>/<name>.txt）")
        return 1

    # 使用固定的 init_file 路径，便于“编译一次，多次运行”
    icache_init_file = f"{workspace}/workload.exe"
    dcache_init_file = f"{workspace}/dcache.data"
    _ensure_file(icache_init_file, default_content="@00000000\n00000013\n")
    _ensure_file(dcache_init_file, default_content="")

    print("=" * 70)
    print(f"全量 workload 回归: {', '.join([c.name for c in cases])}")
    print(f"最大周期数: {max_cycles}")
    print("=" * 70)

    print("\n[步骤 0] 编译仿真器（一次）")
    simulator_binary, _ = build_simulator(
        max_cycles=max_cycles, icache_init_file=icache_init_file, dcache_init_file=dcache_init_file
    )

    passed = 0
    failed = 0
    failures: list[str] = []

    for case in cases:
        print("\n" + "-" * 70)
        print(f"[用例] {case.name}")

        # 1) 准备 icache/dcache init 文件
        instructions, data_file = load_workload_file(case.name)
        _write_workload_exe_from_hex_list(instructions, icache_init_file)
        if data_file and os.path.exists(data_file):
            _copy_text_file(data_file, dcache_init_file)
        else:
            _copy_text_file("/dev/null", dcache_init_file)

        # 2) 运行仿真
        ok = run_simulator(simulator_binary, timeout_s=timeout_s, log_file_path=f"{workspace}/simulation.log")
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

        got = parse_last_rs_value_from_log(f"{workspace}/simulation.log")
        expected = read_expected_from_ans(case.ans_path)

        if got == expected:
            print(f"✓ PASS: got={got} expected={expected}")
            passed += 1
        else:
            print(f"✗ FAIL: got={got} expected={expected}")
            failed += 1
            failures.append(f"{case.name}: got={got} expected={expected}")

    print("\n" + "=" * 70)
    print(f"回归结果: PASS {passed}, FAIL {failed}")
    if failures:
        print("失败列表:")
        for item in failures:
            print(f"- {item}")
    print("=" * 70)

    return 0 if failed == 0 else 1


def load_workload_file(filename):
    """从 workload 文件夹加载十六进制指令文件
    支持三种格式:
    1. workload/xxx.txt - 直接加载文件
    2. workload/xxx/xxx.txt - 从子文件夹加载，同时查找 xxx.data 作为 dcache 初始化
    3. workload/xxx - 自动从子文件夹加载 xxx/xxx.txt 和 xxx/xxx.data
    """
    data_file = None
    
    # 检查是否包含文件夹路径或扩展名
    if "/" in filename:
        # 格式: folder/file.txt
        workload_path = os.path.join(current_path, "workload", filename)
        folder_name = filename.split("/")[0]
        data_file = os.path.join(current_path, "workload", folder_name, f"{folder_name}.data")
    elif not filename.endswith(".txt"):
        # 格式: folder (不含扩展名) - 自动查找 folder/folder.txt
        folder_name = filename
        workload_path = os.path.join(current_path, "workload", folder_name, f"{folder_name}.txt")
        data_file = os.path.join(current_path, "workload", folder_name, f"{folder_name}.data")
    else:
        # 格式: file.txt
        workload_path = os.path.join(current_path, "workload", filename)
        data_file = None
    
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
    
    print(f"✓ 从 {filename} 加载了 {len(instructions)} 条指令")
    
    # 检查是否存在数据文件
    if data_file and os.path.exists(data_file):
        print(f"✓ 找到数据文件: {data_file}")
        return instructions, data_file
    else:
        return instructions, None


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
        default=50,
        help="Maximum number of simulation cycles to run (default: 50)",
    )
    args = parser.parse_args()

    # 约定：直接 `python main.py`（无任何参数）时，跑全量 workload 回归。
    # 注意：workload 往往需要更高 max_cycles，因此这里默认用 300000。
    if len(sys.argv) == 1 and not args.all_workloads:
        args.all_workloads = True
        args.max_cycles = 300000

    if args.all_workloads:
        exit_code = run_all_workloads(max_cycles=args.max_cycles)
        sys.exit(exit_code)

    print("=" * 70)
    if args.workload:
        print(f"工作负载: {args.workload}")
    else:
        print(f"测试: {args.test}")
    print("=" * 70)

    instructions = None
    dcache_init_file = None
    
    # 优先使用 --workload 选项
    if args.workload:
        instructions, dcache_init_file = load_workload_file(args.workload)
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
    
    # 1. 创建测试程序
    print("\n[步骤 1] 创建测试程序")
    create_test_program(instructions)

    # 2. 构建并运行
    print(f"\n[步骤 2] 构建并运行仿真 (最大周期数: {args.max_cycles})")
    if dcache_init_file:
        print(f"    使用 dcache 初始化文件: {dcache_init_file}")
    success, verilog_path = build_and_run(max_cycles=args.max_cycles, dcache_init_file=dcache_init_file)

    if success:
        print("\n✓ 仿真成功完成")
    else:
        print("\n✗ 仿真过程中出现错误")
        sys.exit(1)


if __name__ == "__main__":
    main()
