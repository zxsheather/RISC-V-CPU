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


def build_and_run():
    """构建并运行仿真"""
    depth_log = 6  # 2^6 = 64条指令空间

    sys_obj = SysBuilder("my_cpu")

    with sys_obj:
        fetcher = Fetcher()
        pc_reg, pc_addr = fetcher.build()

        icache = SRAM(
            width=32, depth=1 << depth_log, init_file=f"{workspace}/workload.exe"
        )
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
        rob_bypass_value_to_rs = RegArray(Bits(32), 1)
        rob_bypass_index_to_rs = RegArray(Bits(32), 1)
        revert_flag_cdb = RegArray(Bits(1), 1)

        dcache = SRAM(width=32, depth=1 << DCACHE_DEPTH_LOG, init_file=None)
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
        )

        rs = ReservationStation()
        rs.build(
            in_valid_from_rob=rob_bypass_valid_to_rs,
            in_index_from_rob=rob_bypass_index_to_rs,
            value_from_rob=rob_bypass_value_to_rs,
            ifetch_continue_flag=ifetch_continue_flag,
            rob=rob,
            lsq=lsq,
            revert_flag_cdb=revert_flag_cdb,
        )

        decoder = Decoder()
        decoder.build(icache.dout, rs, revert_flag_cdb)

        fetch_impl = FetcherImpl()
        fetch_impl.build(
            pc_addr_from_f=pc_addr,
            pc_reg_from_f=pc_reg,
            on_br_from_d=Bits(1)(0),  # Not used currently
            icache=icache,
            depth_log=depth_log,
            decoder=decoder,
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
        sim_threshold=50,  # 运行 50 个周期
        idle_threshold=50,
        resource_base="",
        fifo_depth=1,
    )

    print("\n正在生成仿真器...")
    simulator_path, verilog_path = elaborate(sys_obj, **conf)

    print(f"✓ 仿真器代码: {simulator_path}")
    print(f"✓ Verilog 代码: {verilog_path}")

    # 编译仿真器
    print("\n正在编译仿真器...")
    simulator_binary = utils.build_simulator(simulator_path)
    print(f"✓ 仿真器二进制: {simulator_binary}")

    # 运行仿真
    print("\n正在运行仿真...")
    result = subprocess.run(
        [simulator_binary], capture_output=True, text=True, timeout=30
    )

    log_file_path = f"{workspace}/simulation.log"
    with open(log_file_path, "w") as f:
        if result.stdout:
            f.write(result.stdout)
        if result.stderr:
            f.write("\n错误/警告:\n")
            f.write(result.stderr)

    print(f"✓ 仿真日志已保存至: {log_file_path}")

    # Run Verilator simulation
    if utils.has_verilator():
        print("\n正在运行 Verilog 仿真...")
        verilog_log = utils.run_verilator(verilog_path)
        verilog_log_path = f"{workspace}/simulation.verilog.log"
        with open(verilog_log_path, "w") as f:
            f.write(verilog_log)
        print(f"✓ Verilog 仿真日志已保存至: {verilog_log_path}")

    print("\n" + "=" * 70)
    print("仿真输出:")
    print("=" * 70)
    if result.stdout:
        print(result.stdout)

    if result.stderr:
        print("\n错误/警告:")
        print(result.stderr)

    return result.returncode == 0, verilog_path


def main():
    parser = argparse.ArgumentParser(description="Run Toy CPU tests")
    parser.add_argument(
        "--test",
        choices=["default", "war", "waw", "raw", "ls1", "br1", "brm1"],
        default="default",
        help="Select test case",
    )
    args = parser.parse_args()

    print("=" * 70)
    print(f"测试: {args.test}")
    print("=" * 70)

    instructions = None
    if args.test == "war":
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
    # 1. 创建测试程序
    print("\n[步骤 1] 创建测试程序")
    create_test_program(instructions)

    # 2. 构建并运行
    print("\n[步骤 2] 构建并运行仿真")
    success, verilog_path = build_and_run()

    if success:
        print("\n✓ 仿真成功完成")
    else:
        print("\n✗ 仿真过程中出现错误")
        sys.exit(1)


if __name__ == "__main__":
    main()
