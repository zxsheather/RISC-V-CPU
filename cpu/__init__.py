"""
RISC-V CPU 模块包

该包包含乱序执行 RISC-V CPU 的所有核心模块:
- instruction: 指令定义和解码信号
- utils: 工具函数和日志配置
- alu: 算术逻辑单元
- bpu: 分支预测单元
- decoder: 指令解码器
- divider: 除法器（流水线）
- fetcher: 取指单元
- lsq: Load/Store 队列
- multiplier: 乘法器（Booth 编码）
- rob: 重排序缓冲区
- rs: 保留站
"""

from .alu import ALU
from .bpu import AlwaysFalseBPU, AlwaysTakenBPU, GlobalHistoryBPU, TageBPU, TournamentBPU, TwoBitBPU
from .decoder import Decoder
from .divider import DivStage1, DivStage2, DivStage3, DivStage4
from .fetcher import Fetcher, FetcherImpl
from .instruction import *
from .lsq import LSQ, LSQ_SIZE
from .multiplier import BoothEncoder, CompressStage1, CompressStage2, FinalAdder
from .rob import ROB, ROB_SIZE
from .rs import ReservationStation
from .utils import *

__all__ = [
    # instruction
    "RV32I_ALU",
    "DecodeSignals",
    # utils
    "Logger",
    "priority_select_tree",
    "read_mux",
    "write_1hot",
    # alu
    "ALU",
    # bpu
    "AlwaysFalseBPU",
    "AlwaysTakenBPU",
    "TwoBitBPU",
    "GlobalHistoryBPU",
    "TournamentBPU",
    "TageBPU",
    # decoder
    "Decoder",
    # divider
    "DivStage1",
    "DivStage2",
    "DivStage3",
    "DivStage4",
    # fetcher
    "Fetcher",
    "FetcherImpl",
    # lsq
    "LSQ",
    "LSQ_SIZE",
    # multiplier
    "BoothEncoder",
    "CompressStage1",
    "CompressStage2",
    "FinalAdder",
    # rob
    "ROB",
    "ROB_SIZE",
    # rs
    "ReservationStation",
]
