from assassyn.frontend import *

from .instruction import *
from .utils import *

ROB_SIZE = 16
ROB_SIZE_LOG = 4


class ROB(Module):
    def __init__(self):
        super().__init__(
            ports={
                "has_entry_from_rs": Port(Bits(1)),
                "memory_from_rs": Port(Bits(2)),
                "rs1_val_from_rs": Port(Bits(32)),
                "dest_from_rs": Port(Bits(32)),
                "imm_from_rs": Port(Bits(32)),
                "pc_from_rs": Port(Bits(32)),
                "ind_from_rs": Port(Bits(32)),
                "jump_from_rs": Port(Bits(1)),
                "is_jalr_from_rs": Port(Bits(1)),
                "is_branch_from_rs": Port(Bits(1)),
                "sq_pos_from_rs": Port(Bits(32)),
                "result_from_rs": Port(Bits(32)),  # Result computed in RS
                "result_ready_from_rs": Port(Bits(1)),  # Whether result is already ready
                "flip_from_rs": Port(Bits(1)),  # Flip flag for branch comparison
            }
        )
        self.name = "ROB"
        self.log = Logger(enabled=ROBLogEnabled)

    @module.combinational
    def build(
        self,
        out_valid_to_rs: Array,
        need_update_to_rs: Array,
        index_to_rs: Array,
        revert_flag_cdb: Array,
        bypass_valid_to_if: Array,
        updated_pc_to_if: Array,
        commit_branch_to_bpu: Array,
        actual_taken_to_bpu: Array,
        pc_addr_to_bpu: Array,
        alu_valid_from_alu: Array,
        alu_value_from_alu: Array,
        rob_index_from_alu: Array,
        in_valid_from_lsq: Array,
        lsq_value_from_lsq: Array,
        rob_dest_from_lsq: Array,
        mul_valid_from_mul: Array,
        mul_value_from_mul: Array,
        mul_rob_index_from_mul: Array,
        div_valid_from_div: Array,
        div_value_from_div: Array,
        div_rob_index_from_div: Array,
        commit_sq_pos_to_lsq: Array,
        commit_valid_to_lsq: Array,
        commit_counter: Array,
        prediction_counter: Array,
        prediction_correction_counter: Array,
    ):
        pos = RegArray(Bits(32), 1)

        # ROB table - simplified, no longer stores values
        busy_array_d = [RegArray(Bits(1), 1) for _ in range(ROB_SIZE)]
        ready_array_d = [RegArray(Bits(1), 1) for _ in range(ROB_SIZE)]

        # Only keep necessary fields
        memory_from_rs_array = RegArray(Bits(2), ROB_SIZE)
        rs1_val_array = RegArray(Bits(32), ROB_SIZE)
        imm_array = RegArray(Bits(32), ROB_SIZE)
        pc_array = RegArray(Bits(32), ROB_SIZE)
        ind_array = RegArray(Bits(32), ROB_SIZE)
        jump_array = RegArray(Bits(1), ROB_SIZE)
        is_jalr_from_rs_array = RegArray(Bits(1), ROB_SIZE)
        is_branch_from_rs_array = RegArray(Bits(1), ROB_SIZE)
        sq_pos_from_rs_array = RegArray(Bits(32), ROB_SIZE)
        result_array_d = [
            RegArray(Bits(32), 1) for _ in range(ROB_SIZE)
        ]  # Store result from RS or execution units
        flip_array = RegArray(Bits(1), ROB_SIZE)  # Flip flag for branch comparison

        (
            has_entry_from_rs,
            memory_from_rs,
            rs1_val_from_rs,
            dest_from_rs,
            imm_from_rs,
            pc_from_rs,
            ind_from_rs,
            jump_from_rs,
            is_jalr_from_rs,
            is_branch_from_rs,
            sq_pos_from_rs,
            result_from_rs,
            result_ready_from_rs,
            flip_from_rs,
        ) = self.pop_all_ports(False)

        with Condition(revert_flag_cdb[0]):
            revert_flag_cdb[0] = Bits(1)(0)
            self.log("Resume after revert")
            commit_branch_to_bpu[0] = Bits(1)(0)
            out_valid_to_rs[0] = Bits(1)(0)
            need_update_to_rs[0] = Bits(1)(0)
            commit_valid_to_lsq[0] = Bits(1)(0)

        with Condition(~revert_flag_cdb[0]):
            # commit head entry
            head = pos[0].bitcast(Bits(ROB_SIZE_LOG))
            head_result = read_mux(result_array_d, head)
            commit_flag = read_mux(busy_array_d, pos[0]) & read_mux(ready_array_d, head)
            bypass_valid_to_if[0] = commit_flag & (
                is_branch_from_rs_array[head] | is_jalr_from_rs_array[head]
            )
            revert_flag = commit_flag & (
                (is_branch_from_rs_array[head] & (head_result[0:0] ^ jump_array[head][0:0]))
                | is_jalr_from_rs_array[head]
            )
            revert_flag_cdb[0] = revert_flag
            need_update_to_rs[0] = commit_flag & ~(
                is_branch_from_rs_array[head] | memory_from_rs_array[head][1:1]
            )
            commit_branch_to_bpu[0] = commit_flag & is_branch_from_rs_array[head]
            pc_addr_to_bpu[0] = pc_array[head]

            with Condition(commit_flag):
                self.log(
                    "Committing entry rob_idx={}, rs_idx={}, pc=0x{:08x}",
                    head,
                    ind_array[head],
                    pc_array[head],
                )
                commit_counter[0] = commit_counter[0] + Int(32)(1)
                index_to_rs[0] = ind_array[head]

                with Condition(~revert_flag):
                    write_1hot(busy_array_d, head, Bits(1)(0))
                    pos[0] = (head.bitcast(UInt(32)) + UInt(32)(1)) & Bits(32)(ROB_SIZE - 1)
                write_1hot(ready_array_d, head, Bits(1)(0))

                # Handle jalr - compute target PC
                with Condition(is_jalr_from_rs_array[head]):
                    updated_pc_to_if[0] = (
                        (
                            rs1_val_array[head].bitcast(Int(32)) + imm_array[head].bitcast(Int(32))
                        ).bitcast(Bits(32))
                    ) & Bits(32)(0xFFFFFFFE)

                # Handle store - notify LSQ
                with Condition(memory_from_rs_array[head][1:1] == Bits(1)(1)):
                    commit_sq_pos_to_lsq[0] = sq_pos_from_rs_array[head]
                    commit_valid_to_lsq[0] = Bits(1)(1)
                with Condition(~(memory_from_rs_array[head][1:1] == Bits(1)(1))):
                    commit_valid_to_lsq[0] = Bits(1)(0)

                # Handle branch - update BPU
                with Condition(is_branch_from_rs_array[head]):
                    prediction_counter[0] = prediction_counter[0] + Int(32)(1)
                    predict_result = ~(head_result[0:0] ^ jump_array[head][0:0])

                    with Condition(head_result[0:0]):
                        updated_pc_to_if[0] = (
                            pc_array[head].bitcast(Int(32)) + imm_array[head].bitcast(Int(32))
                        ).bitcast(Bits(32))
                        actual_taken_to_bpu[0] = Bits(1)(1)

                    with Condition(~head_result[0:0]):
                        updated_pc_to_if[0] = (
                            pc_array[head].bitcast(Int(32)) + Int(32)(4)
                        ).bitcast(Bits(32))
                        actual_taken_to_bpu[0] = Bits(1)(0)

                    with Condition(predict_result):
                        prediction_correction_counter[0] = prediction_correction_counter[0] + Int(
                            32
                        )(1)

                out_valid_to_rs[0] = Bits(1)(1)

            with Condition(revert_flag):
                self.log("Revert triggered at idx={}, pc={}", head, pc_array[head])
                pos[0] = Bits(32)(0)
                for i in range(ROB_SIZE):
                    busy_array_d[i][0] = Bits(1)(0)

            with Condition(~commit_flag):
                out_valid_to_rs[0] = Bits(1)(0)
                commit_valid_to_lsq[0] = Bits(1)(0)

            # receive from ALU - mark ready and update result with flip
            with Condition(alu_valid_from_alu[0] & ~revert_flag):
                alu_idx = rob_index_from_alu[0].bitcast(Bits(ROB_SIZE_LOG))
                write_1hot(ready_array_d, alu_idx, Bits(1)(1))
                # Apply flip for branch comparison results
                alu_result_flipped = flip_array[alu_idx].select(
                    alu_value_from_alu[0] ^ Bits(32)(1),
                    alu_value_from_alu[0],
                )
                write_1hot(result_array_d, alu_idx, alu_result_flipped)

            # receive from MUL - mark ready and update result
            with Condition(mul_valid_from_mul[0] & ~revert_flag):
                mul_idx = mul_rob_index_from_mul[0].bitcast(Bits(ROB_SIZE_LOG))
                write_1hot(ready_array_d, mul_idx, Bits(1)(1))
                write_1hot(result_array_d, mul_idx, mul_value_from_mul[0])

            # receive from DIV - mark ready and update result
            with Condition(div_valid_from_div[0] & ~revert_flag):
                div_idx = div_rob_index_from_div[0].bitcast(Bits(ROB_SIZE_LOG))
                write_1hot(ready_array_d, div_idx, Bits(1)(1))
                write_1hot(result_array_d, div_idx, div_value_from_div[0])

            # receive from LSQ - mark ready and update result
            with Condition(in_valid_from_lsq[0] & ~revert_flag):
                lsq_idx = (rob_dest_from_lsq[0] & Bits(32)(ROB_SIZE - 1)).bitcast(
                    Bits(ROB_SIZE_LOG)
                )
                write_1hot(ready_array_d, lsq_idx, Bits(1)(1))
                write_1hot(result_array_d, lsq_idx, lsq_value_from_lsq[0])

            # append new entry
            idx = (dest_from_rs & Bits(32)(ROB_SIZE - 1)).bitcast(Bits(ROB_SIZE_LOG))

            with Condition(has_entry_from_rs & ~revert_flag):
                write_1hot(busy_array_d, idx, Bits(1)(1))
                memory_from_rs_array[idx] = memory_from_rs
                rs1_val_array[idx] = rs1_val_from_rs
                imm_array[idx] = imm_from_rs
                pc_array[idx] = pc_from_rs
                ind_array[idx] = ind_from_rs
                jump_array[idx] = jump_from_rs
                is_jalr_from_rs_array[idx] = is_jalr_from_rs
                is_branch_from_rs_array[idx] = is_branch_from_rs
                sq_pos_from_rs_array[idx] = sq_pos_from_rs
                write_1hot(result_array_d, idx, result_from_rs)
                flip_array[idx] = flip_from_rs

                # Use result_ready_from_rs directly - RS knows if result is pre-computed
                # jal/jalr/lui/auipc/store are ready immediately
                # ALU/MUL/DIV/Load/branch need to wait for execution unit
                write_1hot(ready_array_d, idx, result_ready_from_rs)
                self.log(
                    "Appended entry idx={}, ind_rs={}, pc=0x{:08x}, memory={}, ready={}",
                    idx,
                    ind_from_rs,
                    pc_from_rs,
                    memory_from_rs,
                    result_ready_from_rs,
                )
