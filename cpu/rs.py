from assassyn.frontend import *

from .instruction import *
from .lsq import LSQ_SIZE
from .rob import ROB_SIZE
from .utils import *

RS_SIZE = 16
RS_SIZE_LOG = 4
Q_DEFAULT = Bits(32)(127)


class ReservationStation(Module):
    def __init__(self):
        super().__init__(
            ports={
                "decode_signals": Port(DecodeSignals),
                "has_entry_from_d": Port(Bits(1)),
                "pc_from_d": Port(Bits(32)),
            }
        )
        self.name = "RS"
        self.log = Logger(enabled=RSLogEnabled)

    def print_stats(self, commit_counter, prediction_counter, prediction_correction_counter):
        stat_log = Logger(enabled=StatLogEnabled)
        stat_log(
            "\n"
            "===== Prediction Stats =====\n"
            "Committed Instructions: {}\n"
            "Total Branches: {}\n"
            "Correctly Predicted Branches: {}\n"
            "=====================",
            commit_counter[0].bitcast(UInt(32)),
            prediction_counter[0].bitcast(UInt(32)),
            prediction_correction_counter[0].bitcast(UInt(32)),
        )

    @module.combinational
    def build(
        self,
        in_valid_from_rob: Array,
        need_update_from_rob: Array,
        in_index_from_rob: Array,
        jump_from_bpu: Array,
        in_valid_from_lsq: Array,
        sq_pos_from_lsq: Array,
        rob: Module,
        lsq: Module,
        alu: Module,
        mul: Module,
        div: Module,
        ifetch_continue_flag: Array,
        revert_flag_cdb: Array,
        commit_counter: Array,
        prediction_counter: Array,
        prediction_correction_counter: Array,
        # CDB signals from execution units (results computed in RS instead of ROB)
        alu_cdb_valid: Array,
        alu_cdb_value: Array,
        alu_cdb_rob_idx: Array,
        mul_cdb_valid: Array,
        mul_cdb_value: Array,
        mul_cdb_rob_idx: Array,
        div_cdb_valid: Array,
        div_cdb_value: Array,
        div_cdb_rob_idx: Array,
        lsq_cdb_valid: Array,
        lsq_cdb_value: Array,
        lsq_cdb_rob_idx: Array,
        lsq_cdb_mem_addr: Array,
    ):
        (
            signals,
            has_entry_from_d,
            pc_from_d,
        ) = self.pop_all_ports(False)

        rd_from_d = signals.rd
        alu_from_d = signals.alu
        alu_valid_from_d = signals.alu_valid
        memory_from_d = signals.memory
        mem_oper_size_from_d = signals.mem_oper_size
        mem_oper_signed_from_d = signals.mem_oper_signed
        rs1_from_d = signals.rs1
        rs1_valid_from_d = signals.rs1_valid
        rs2_from_d = signals.rs2
        rs2_valid_from_d = signals.rs2_valid
        imm_from_d = signals.imm
        imm_valid_from_d = signals.imm_valid
        rd_from_d = signals.rd
        rd_valid_from_d = signals.rd_valid
        jump = jump_from_bpu[0]

        with Condition(has_entry_from_d & ~revert_flag_cdb[0]):
            self.log(
                "New RS entry request: alu={}, memory={}, rd_valid={}, rd=x{:02}, rs1_valid={}, rs1=x{:02}, rs2_valid={}, rs2=x{:02}, imm_valid={}, pc=0x{:08x}, jump={}",
                alu_from_d.bitcast(UInt(RV32I_ALU.CNT)),
                memory_from_d.bitcast(UInt(2)),
                rd_valid_from_d.bitcast(UInt(1)),
                rd_from_d,
                rs1_valid_from_d.bitcast(UInt(1)),
                rs1_from_d,
                rs2_valid_from_d.bitcast(UInt(1)),
                rs2_from_d,
                imm_valid_from_d.bitcast(UInt(1)),
                pc_from_d.bitcast(UInt(5)),
                jump.bitcast(UInt(1)),
            )
        newly_freed_flag = Bits(1)(0)
        newly_freed_rd = Bits(5)(0)

        reuse_rd_flag = Bits(1)(0)

        newly_append_index = RegArray(Bits(32), 1)
        pos_in_rob = RegArray(Bits(32), 1)
        reg_file = RegArray(Bits(32), 32)

        # busy_array = RegArray(Bits(1), RS_SIZE, initializer=[0] * RS_SIZE)
        busy_array_d = [RegArray(Bits(1), 1, initializer=[0]) for _ in range(RS_SIZE)]

        busy_entry_count = RegArray(Bits(32), 1)
        # dispatched_array = RegArray(Bits(1), RS_SIZE)
        dispatched_array_d = [RegArray(Bits(1), 1) for _ in range(RS_SIZE)]
        alu_array = RegArray(Bits(RV32I_ALU.CNT), RS_SIZE)
        alu_valid_array = RegArray(Bits(1), RS_SIZE)
        memory_array = RegArray(Bits(2), RS_SIZE)
        mem_oper_size_array = RegArray(Bits(2), RS_SIZE)
        mem_oper_signed_array = RegArray(Bits(1), RS_SIZE)
        rd_array = RegArray(Bits(5), RS_SIZE)
        rd_valid_array = RegArray(Bits(1), RS_SIZE)
        # vj_array = RegArray(Bits(32), RS_SIZE)
        vj_array_d = [RegArray(Bits(32), 1) for _ in range(RS_SIZE)]
        vj_valid_array = RegArray(Bits(1), RS_SIZE)
        # vk_array = RegArray(Bits(32), RS_SIZE)
        vk_array_d = [RegArray(Bits(32), 1) for _ in range(RS_SIZE)]
        vk_valid_array = RegArray(Bits(1), RS_SIZE)
        # qj_array = RegArray(Bits(32), RS_SIZE)
        # qk_array = RegArray(Bits(32), RS_SIZE)
        qj_array_d = [RegArray(Bits(32), 1) for _ in range(RS_SIZE)]
        qk_array_d = [RegArray(Bits(32), 1) for _ in range(RS_SIZE)]
        imm_array = RegArray(Bits(32), RS_SIZE)
        imm_valid_array = RegArray(Bits(1), RS_SIZE)
        rob_dest_array = RegArray(Bits(32), RS_SIZE)
        pc_array = RegArray(Bits(32), RS_SIZE)
        jump_array = RegArray(Bits(1), RS_SIZE)
        is_jal_array = RegArray(Bits(1), RS_SIZE)
        is_jalr_array = RegArray(Bits(1), RS_SIZE)
        is_auipc_array = RegArray(Bits(1), RS_SIZE)
        is_lui_array = RegArray(Bits(1), RS_SIZE)
        is_branch_array = RegArray(Bits(1), RS_SIZE)
        is_ebreak_array = RegArray(Bits(1), RS_SIZE)
        is_ecall_array = RegArray(Bits(1), RS_SIZE)
        is_mul_array = RegArray(Bits(1), RS_SIZE)
        is_div_array = RegArray(Bits(1), RS_SIZE)

        cond_array = RegArray(Bits(RV32I_ALU.CNT), RS_SIZE)
        flip_array = RegArray(Bits(1), RS_SIZE)
        # reorder_array = RegArray(Bits(32), 32)
        # reorder_busy_array = RegArray(Bits(1), 32)
        reorder_array_d = [RegArray(Bits(32), 1) for _ in range(32)]
        reorder_busy_array_d = [RegArray(Bits(1), 1) for _ in range(32)]
        lsq_poses_array = RegArray(Bits(32), RS_SIZE)
        lsq_pos = RegArray(Bits(32), 1, initializer=[1])
        lq_poses_array = RegArray(Bits(32), RS_SIZE)
        lq_pos = RegArray(Bits(32), 1)
        sq_poses_array = RegArray(Bits(32), RS_SIZE)
        sq_pos = RegArray(Bits(32), 1)

        # Result storage - computed in RS instead of waiting for ROB commit
        # This allows dependent instructions to get values earlier
        result_array_d = [RegArray(Bits(32), 1) for _ in range(RS_SIZE)]
        result_ready_array_d = [RegArray(Bits(1), 1) for _ in range(RS_SIZE)]

        total_br = RegArray(Bits(32), 1)
        predicted_br = RegArray(Bits(32), 1)

        # Update sq_pos from LSQ after revert
        with Condition(in_valid_from_lsq[0]):
            self.log(
                "RS received LSQ sq_pos={} valid={}",
                sq_pos_from_lsq[0].bitcast(UInt(32)),
                in_valid_from_lsq[0].bitcast(UInt(1)),
            )
            sq_pos[0] = sq_pos_from_lsq[0]

        # Use result computed in RS instead of value from ROB
        # This is the key optimization: results are computed earlier in RS
        commit_rs_idx = in_index_from_rob[0]
        new_val = read_mux(result_array_d, commit_rs_idx)
        new_val = (rd_array[commit_rs_idx] == Bits(5)(0)).select(Bits(32)(0), new_val)

        match_mask = Bits(32)(0)
        update_index = in_index_from_rob[0]
        # Optimized logic to find the freed register
        # 1. Generate match mask in parallel
        for i in range(32):
            is_match = reorder_busy_array_d[i][0] & (reorder_array_d[i][0] == update_index)
            match_mask = match_mask | is_match.select(Bits(32)(1 << i), Bits(32)(0))

        # 2. Calculate flag
        newly_freed_flag = match_mask != Bits(32)(0)
        newly_freed_flag = (need_update_from_rob[0] & ~revert_flag_cdb[0]).select(
            newly_freed_flag, Bits(1)(0)
        )

        # 3. Calculate rd using select1hot
        possible_rds = [Bits(5)(i) for i in range(32)]
        # Ensure mask is valid for select1hot (must be one-hot)
        safe_mask = newly_freed_flag.select(match_mask, Bits(32)(1))
        raw_rd = safe_mask.select1hot(*possible_rds)

        newly_freed_rd = newly_freed_flag.select(raw_rd, Bits(5)(0))
        revert_flag = revert_flag_cdb[0]

        # ============= Result Computation in RS (instead of ROB) =============
        # When execution units produce results, we compute the final value here
        # and store it in result_array. This allows dependent instructions to
        # get values immediately without waiting for ROB commit.

        # Helper function to update waiting entries when a result is ready
        def broadcast_result_to_waiters(producer_idx_const, result_value):
            """Update all RS entries waiting for the producer's result"""
            for i in range(RS_SIZE):
                with Condition(
                    busy_array_d[i][0] & (qj_array_d[i][0] == Bits(32)(producer_idx_const))
                ):
                    vj_array_d[i][0] = result_value
                    qj_array_d[i][0] = Q_DEFAULT
                    self.log(
                        "CDB: RS entry {} received rs1 value 0x{:08x} from RS {}",
                        Bits(32)(i),
                        result_value,
                        Bits(32)(producer_idx_const),
                    )
                with Condition(
                    busy_array_d[i][0] & (qk_array_d[i][0] == Bits(32)(producer_idx_const))
                ):
                    vk_array_d[i][0] = result_value
                    qk_array_d[i][0] = Q_DEFAULT
                    self.log(
                        "CDB: RS entry {} received rs2 value 0x{:08x} from RS {}",
                        Bits(32)(i),
                        result_value,
                        Bits(32)(producer_idx_const),
                    )

        # ALU result: apply flip for branch comparison results
        with Condition(alu_cdb_valid[0] & ~revert_flag & rd_valid_array[alu_cdb_rob_idx[0]]):
            alu_rob_idx = alu_cdb_rob_idx[0]
            for producer_idx in range(RS_SIZE):
                producer_match = busy_array_d[producer_idx][0] & (
                    rob_dest_array[producer_idx] == alu_rob_idx
                )
                with Condition(producer_match):
                    # Compute final result with flip (for branch comparisons)
                    final_alu_result = flip_array[producer_idx].select(
                        alu_cdb_value[0] ^ Bits(32)(1),
                        alu_cdb_value[0],
                    )
                    result_array_d[producer_idx][0] = final_alu_result
                    result_ready_array_d[producer_idx][0] = Bits(1)(1)
                    self.log(
                        "RS {}: ALU result computed = 0x{:08x} (flip={})",
                        Bits(32)(producer_idx),
                        final_alu_result,
                        flip_array[producer_idx],
                    )
                    # Broadcast to waiting entries
                    broadcast_result_to_waiters(producer_idx, final_alu_result)

        # MUL result
        with Condition(mul_cdb_valid[0] & ~revert_flag & rd_valid_array[mul_cdb_rob_idx[0]]):
            mul_rob_idx = mul_cdb_rob_idx[0]
            for producer_idx in range(RS_SIZE):
                producer_match = busy_array_d[producer_idx][0] & (
                    rob_dest_array[producer_idx] == mul_rob_idx
                )
                with Condition(producer_match):
                    result_array_d[producer_idx][0] = mul_cdb_value[0]
                    result_ready_array_d[producer_idx][0] = Bits(1)(1)
                    self.log(
                        "RS {}: MUL result computed = 0x{:08x}",
                        Bits(32)(producer_idx),
                        mul_cdb_value[0],
                    )
                    broadcast_result_to_waiters(producer_idx, mul_cdb_value[0])

        # DIV result
        with Condition(div_cdb_valid[0] & ~revert_flag & rd_valid_array[div_cdb_rob_idx[0]]):
            div_rob_idx = div_cdb_rob_idx[0]
            for producer_idx in range(RS_SIZE):
                producer_match = busy_array_d[producer_idx][0] & (
                    rob_dest_array[producer_idx] == div_rob_idx
                )
                with Condition(producer_match):
                    result_array_d[producer_idx][0] = div_cdb_value[0]
                    result_ready_array_d[producer_idx][0] = Bits(1)(1)
                    self.log(
                        "RS {}: DIV result computed = 0x{:08x}",
                        Bits(32)(producer_idx),
                        div_cdb_value[0],
                    )
                    broadcast_result_to_waiters(producer_idx, div_cdb_value[0])

        # LSQ (Load) result: apply sign extension based on mem_oper_size and mem_oper_signed
        with Condition(lsq_cdb_valid[0] & ~revert_flag):
            lsq_rob_idx = lsq_cdb_rob_idx[0]
            for producer_idx in range(RS_SIZE):
                producer_match = busy_array_d[producer_idx][0] & (
                    rob_dest_array[producer_idx] == lsq_rob_idx
                )
                with Condition(producer_match):
                    # Sign extension logic (moved from ROB)
                    sign = mem_oper_signed_array[producer_idx]
                    size = mem_oper_size_array[producer_idx]
                    value = lsq_cdb_value[0]
                    offset = lsq_cdb_mem_addr[0][0:1]  # lowest 2 bits

                    # Byte sign extension
                    byte_ext_bit = sign & value[7:7]
                    byte_ext = byte_ext_bit.select(Bits(24)(0xFFFFFF), Bits(24)(0))
                    byte_val = concat(byte_ext, value[0:7])
                    for i in range(4):
                        byte_offset_flag = offset == Bits(2)(i)
                        byte_val = byte_offset_flag.select(
                            concat(byte_ext, value[i << 3 : (i << 3) + 7]), byte_val
                        )

                    # Halfword sign extension
                    half_ext_bit = sign & value[15:15]
                    half_ext = half_ext_bit.select(Bits(16)(0xFFFF), Bits(16)(0))
                    half_val = offset[0:0].select(
                        concat(half_ext, value[0:15]), concat(half_ext, value[16:31])
                    )

                    # Select final value based on size
                    final_load_result = (size == Bits(2)(0)).select(
                        byte_val, (size == Bits(2)(1)).select(half_val, value)
                    )

                    result_array_d[producer_idx][0] = final_load_result
                    result_ready_array_d[producer_idx][0] = Bits(1)(1)
                    self.log(
                        "RS {}: Load result computed = 0x{:08x}",
                        Bits(32)(producer_idx),
                        final_load_result,
                    )
                    broadcast_result_to_waiters(producer_idx, final_load_result)

        # ============= End Result Computation =============

        self.log("Busy entries in RS: {}", busy_entry_count[0].bitcast(UInt(32)))

        busy_entry_count_next = in_valid_from_rob[0].select(
            busy_entry_count[0].bitcast(Int(32)) - Int(32)(1),
            busy_entry_count[0].bitcast(Int(32)),
        )
        busy_entry_count_next = has_entry_from_d.select(
            busy_entry_count_next + Int(32)(1), busy_entry_count_next
        )
        busy_entry_count[0] = revert_flag.select(
            Bits(32)(0), busy_entry_count_next.bitcast(Bits(32))
        )
        # Commit from ROB
        with Condition(in_valid_from_rob[0]):
            update_index = in_index_from_rob[0].bitcast(Bits(5))
            newly_append_ind = newly_append_index[0].bitcast(Bits(RS_SIZE_LOG))
            with Condition(
                ~revert_flag & (newly_append_ind != update_index.bitcast(Bits(RS_SIZE_LOG)))
            ):
                write_1hot(busy_array_d, update_index, Bits(1)(0))
            self.log(
                "Committing from ROB idx={}, value=0x{:08x}",
                update_index,
                new_val,
            )
            with Condition(is_ebreak_array[update_index]):
                self.log(
                    "EBREAK instruction committed, finish simulation",
                )
                self.print_stats(commit_counter, prediction_counter, prediction_correction_counter)
                log("{}", reg_file[10].bitcast(UInt(32)))
                finish()

            with Condition(is_ecall_array[update_index]):
                self.log(
                    "ECALL instruction committed, finish simulation",
                )
                self.print_stats(commit_counter, prediction_counter, prediction_correction_counter)
                log("{}", reg_file[10].bitcast(UInt(32)))
                finish()

            is_li_x10_255 = (
                (alu_array[update_index] == Bits(RV32I_ALU.CNT)(1 << RV32I_ALU.ALU_ADD))
                & (rd_array[update_index] == Bits(5)(10))
                & (imm_valid_array[update_index] == Bits(1)(1))
                & (read_mux(vj_array_d, update_index) == Bits(32)(0))
                & (memory_array[update_index] == Bits(2)(0))
                & (imm_array[update_index] == Bits(32)(255))
            )

            is_sb_x0__1 = (
                (memory_array[update_index] == Bits(2)(2))  # Store
                & (read_mux(vk_array_d, update_index) == Bits(32)(0))  # rs2==0
                & (read_mux(vj_array_d, update_index) == Bits(32)(0))  # rs1==0
                & (mem_oper_size_array[update_index] == Bits(2)(0))  # byte
                & (imm_array[update_index] == Bits(32)(0xFFFFFFFF))  # imm==-1
            )

            with Condition(is_li_x10_255):
                self.log(
                    "Main program executed LI x10 255, finish simulation",
                )
                self.print_stats(commit_counter, prediction_counter, prediction_correction_counter)
                log("{}", reg_file[10].bitcast(UInt(32)))
                finish()

            with Condition(is_sb_x0__1):
                self.log(
                    "Main program executed SB x0 -1, finish simulation",
                )
                self.print_stats(commit_counter, prediction_counter, prediction_correction_counter)
                log("{}", reg_file[10].bitcast(UInt(32)))
                finish()

            with Condition(need_update_from_rob[0]):
                for i in range(RS_SIZE):
                    with Condition(busy_array_d[i][0] & (qj_array_d[i][0] == update_index)):
                        vj_array_d[i][0] = new_val
                        qj_array_d[i][0] = Q_DEFAULT
                        self.log(
                            "RS entry index {} received rs1 value 0x{:08x} from ROB entry {}",
                            Bits(32)(i),
                            new_val,
                            update_index,
                        )
                    with Condition(busy_array_d[i][0] & (qk_array_d[i][0] == update_index)):
                        vk_array_d[i][0] = new_val
                        qk_array_d[i][0] = Q_DEFAULT
                        self.log(
                            "RS entry index {} received rs2 value 0x{:08x} from ROB entry {}",
                            Bits(32)(i),
                            new_val,
                            update_index,
                        )

                reg_file[rd_array[update_index]] = new_val
                self.log(
                    "RegFile updated: x{:02} = 0x{:08x}",
                    rd_array[update_index],
                    new_val,
                )

        with Condition(revert_flag):
            self.log(
                "Revert triggered, clearing all entries",
            )
            for i in range(RS_SIZE):
                busy_array_d[i][0] = Bits(1)(0)
            for i in range(32):
                reorder_busy_array_d[i][0] = Bits(1)(0)

            lsq_pos[0] = Bits(32)(1)
            newly_append_index[0] = Bits(32)(0)
            pos_in_rob[0] = Bits(32)(0)
            lq_pos[0] = Bits(32)(0)

        with Condition(revert_flag & ~in_valid_from_lsq[0]):
            sq_pos[0] = Bits(32)(0)

        # Append new entry
        with Condition(has_entry_from_d & ~revert_flag):
            newly_append_ind = newly_append_index[0].bitcast(Bits(RS_SIZE_LOG))
            newly_append_index[0] = (newly_append_index[0].bitcast(Int(32)) + Int(32)(1)) & Int(32)(
                RS_SIZE - 1
            )
            self.log("New RS entry allocated at index {}", newly_append_ind)
            pos_in_rob[0] = (pos_in_rob[0].bitcast(Int(32)) + Int(32)(1)).bitcast(Bits(32)) & Bits(
                32
            )(ROB_SIZE - 1)
            write_1hot(busy_array_d, newly_append_ind, Bits(1)(1))
            pc_array[newly_append_ind] = pc_from_d
            alu_array[newly_append_ind] = alu_from_d
            alu_valid_array[newly_append_ind] = alu_valid_from_d
            memory_array[newly_append_ind] = memory_from_d
            mem_oper_size_array[newly_append_ind] = mem_oper_size_from_d
            mem_oper_signed_array[newly_append_ind] = mem_oper_signed_from_d
            imm_array[newly_append_ind] = imm_from_d
            imm_valid_array[newly_append_ind] = imm_valid_from_d
            jump_array[newly_append_ind] = jump

            is_jal_array[newly_append_ind] = signals.is_jal
            is_jalr_array[newly_append_ind] = signals.is_jalr
            is_auipc_array[newly_append_ind] = signals.is_auipc
            is_lui_array[newly_append_ind] = signals.is_lui
            is_branch_array[newly_append_ind] = signals.is_branch_inst
            is_ebreak_array[newly_append_ind] = signals.is_ebreak
            is_ecall_array[newly_append_ind] = signals.is_ecall
            is_mul_array[newly_append_ind] = signals.is_mul
            is_div_array[newly_append_ind] = signals.is_div
            cond_array[newly_append_ind] = signals.cond
            flip_array[newly_append_ind] = signals.flip

            write_1hot(dispatched_array_d, newly_append_ind, Bits(1)(0))
            rob_dest_array[newly_append_ind] = pos_in_rob[0]

            # Pre-compute results for instructions that don't need execution units
            # This allows dependent instructions to get values immediately
            with Condition(signals.is_jal | signals.is_jalr):
                # jal/jalr: result = pc + 4
                jal_result = (pc_from_d.bitcast(Int(32)) + Int(32)(4)).bitcast(Bits(32))
                write_1hot(result_array_d, newly_append_ind, jal_result)
                write_1hot(result_ready_array_d, newly_append_ind, Bits(1)(1))
                self.log(
                    "RS {}: JAL/JALR result pre-computed = 0x{:08x}", newly_append_ind, jal_result
                )

            with Condition(signals.is_auipc):
                # auipc: result = pc + imm
                auipc_result = (pc_from_d.bitcast(Int(32)) + imm_from_d.bitcast(Int(32))).bitcast(
                    Bits(32)
                )
                write_1hot(result_array_d, newly_append_ind, auipc_result)
                write_1hot(result_ready_array_d, newly_append_ind, Bits(1)(1))
                self.log(
                    "RS {}: AUIPC result pre-computed = 0x{:08x}", newly_append_ind, auipc_result
                )

            with Condition(signals.is_lui):
                # lui: result = imm
                write_1hot(result_array_d, newly_append_ind, imm_from_d)
                write_1hot(result_ready_array_d, newly_append_ind, Bits(1)(1))
                self.log("RS {}: LUI result pre-computed = 0x{:08x}", newly_append_ind, imm_from_d)

            # For other instructions (ALU, MUL, DIV, Load), result will be computed
            # when execution units return results
            with Condition(
                ~signals.is_jal & ~signals.is_jalr & ~signals.is_auipc & ~signals.is_lui
            ):
                write_1hot(result_ready_array_d, newly_append_ind, Bits(1)(0))

            with Condition(memory_from_d[0:0] == Bits(1)(1)):  # Load
                lsq_poses_array[newly_append_ind] = lsq_pos[0]
                lsq_pos[0] = (lsq_pos[0].bitcast(Int(32)) + Int(32)(1)).bitcast(Bits(32))
                lq_poses_array[newly_append_ind] = lq_pos[0]
                lq_pos[0] = (lq_pos[0].bitcast(Int(32)) + Int(32)(1)).bitcast(Bits(32)) & Bits(32)(
                    LSQ_SIZE - 1
                )
                self.log(
                    "RS entry index {} assigned LSQ load position {}, LQ position {}",
                    newly_append_ind,
                    lsq_pos[0],
                    lq_pos[0],
                )

            with Condition(memory_from_d[1:1] == Bits(1)(1)):  # Store
                lsq_poses_array[newly_append_ind] = lsq_pos[0]
                lsq_pos[0] = (lsq_pos[0].bitcast(Int(32)) + Int(32)(1)).bitcast(Bits(32))
                sq_poses_array[newly_append_ind] = sq_pos[0]
                sq_pos[0] = (sq_pos[0].bitcast(Int(32)) + Int(32)(1)).bitcast(Bits(32)) & Bits(32)(
                    LSQ_SIZE - 1
                )
                self.log(
                    "RS entry index {} assigned LSQ store position {}, SQ position {}",
                    newly_append_ind,
                    lsq_pos[0],
                    sq_pos[0],
                )

            with Condition(rs1_valid_from_d):
                vj_valid_array[newly_append_ind] = Bits(1)(1)
                producer_rs_idx = read_mux(reorder_array_d, rs1_from_d)
                producer_busy = read_mux(reorder_busy_array_d, rs1_from_d)
                producer_result_ready = read_mux(result_ready_array_d, producer_rs_idx)
                producer_result = read_mux(result_array_d, producer_rs_idx)

                # Case 1: Producer exists and result is already ready - use it directly
                with Condition(
                    producer_busy
                    & producer_result_ready
                    & (~newly_freed_flag | (newly_freed_rd != rs1_from_d))
                    & (rs1_from_d != Bits(5)(0))
                ):
                    write_1hot(vj_array_d, newly_append_ind, producer_result)
                    write_1hot(qj_array_d, newly_append_ind, Q_DEFAULT)
                    self.log(
                        "RS entry index {} got rs1 x{:02} value 0x{:08x} from RS {} (result ready)",
                        newly_append_ind,
                        rs1_from_d,
                        producer_result,
                        producer_rs_idx,
                    )

                # Case 2: Producer exists but result not ready - wait for it
                with Condition(
                    producer_busy
                    & ~producer_result_ready
                    & (~newly_freed_flag | (newly_freed_rd != rs1_from_d))
                    & (rs1_from_d != Bits(5)(0))
                ):
                    write_1hot(
                        qj_array_d,
                        newly_append_ind,
                        producer_rs_idx,
                    )
                    write_1hot(vj_array_d, newly_append_ind, Bits(32)(0))
                    self.log(
                        "RS entry index {} waiting for rs1 x{:02} from RS entry {}",
                        newly_append_ind,
                        rs1_from_d,
                        producer_rs_idx,
                    )

                # Case 3: Value being freed this cycle from ROB commit
                with Condition(newly_freed_flag & (newly_freed_rd == rs1_from_d)):
                    write_1hot(vj_array_d, newly_append_ind, new_val)
                    write_1hot(qj_array_d, newly_append_ind, Q_DEFAULT)
                    self.log(
                        "RS entry index {} received rs1 x{:02} value 0x{:08x} from commit",
                        newly_append_ind,
                        rs1_from_d,
                        new_val,
                    )

                # Case 4: No producer - read from register file
                with Condition(
                    ~producer_busy
                    & (~newly_freed_flag | (newly_freed_rd != rs1_from_d))
                    & (rs1_from_d != Bits(5)(0))
                ):
                    write_1hot(vj_array_d, newly_append_ind, reg_file[rs1_from_d])
                    write_1hot(qj_array_d, newly_append_ind, Q_DEFAULT)
                    self.log(
                        "RS entry index {} got rs1 x{:02} value 0x{:08x} from RegFile",
                        newly_append_ind,
                        rs1_from_d,
                        reg_file[rs1_from_d],
                    )

                # Case 5: x0 is always 0
                with Condition(rs1_from_d == Bits(5)(0)):
                    write_1hot(vj_array_d, newly_append_ind, Bits(32)(0))
                    write_1hot(qj_array_d, newly_append_ind, Q_DEFAULT)
                    self.log(
                        "RS entry index {} has rs1 x0, set value to 0",
                        newly_append_ind,
                    )

            with Condition(~rs1_valid_from_d):
                vj_valid_array[newly_append_ind] = Bits(1)(0)
                write_1hot(vj_array_d, newly_append_ind, Bits(32)(0))
                write_1hot(qj_array_d, newly_append_ind, Q_DEFAULT)
                self.log(
                    "RS entry index {} has unused rs1",
                    newly_append_ind,
                )

            with Condition(rs2_valid_from_d):
                vk_valid_array[newly_append_ind] = Bits(1)(1)
                producer_rs_idx_k = read_mux(reorder_array_d, rs2_from_d)
                producer_busy_k = read_mux(reorder_busy_array_d, rs2_from_d)
                producer_result_ready_k = read_mux(result_ready_array_d, producer_rs_idx_k)
                producer_result_k = read_mux(result_array_d, producer_rs_idx_k)

                # Case 1: Producer exists and result is already ready - use it directly
                with Condition(
                    producer_busy_k
                    & producer_result_ready_k
                    & (~newly_freed_flag | (newly_freed_rd != rs2_from_d))
                    & (rs2_from_d != Bits(5)(0))
                ):
                    write_1hot(vk_array_d, newly_append_ind, producer_result_k)
                    write_1hot(qk_array_d, newly_append_ind, Q_DEFAULT)
                    self.log(
                        "RS entry index {} got rs2 x{:02} value 0x{:08x} from RS {} (result ready)",
                        newly_append_ind,
                        rs2_from_d,
                        producer_result_k,
                        producer_rs_idx_k,
                    )

                # Case 2: Producer exists but result not ready - wait for it
                with Condition(
                    producer_busy_k
                    & ~producer_result_ready_k
                    & (~newly_freed_flag | (newly_freed_rd != rs2_from_d))
                    & (rs2_from_d != Bits(5)(0))
                ):
                    write_1hot(
                        qk_array_d,
                        newly_append_ind,
                        producer_rs_idx_k,
                    )
                    write_1hot(vk_array_d, newly_append_ind, Bits(32)(0))
                    self.log(
                        "RS entry index {} waiting for rs2 x{:02} from RS entry {}",
                        newly_append_ind,
                        rs2_from_d,
                        producer_rs_idx_k,
                    )

                # Case 3: Value being freed this cycle from ROB commit
                with Condition(
                    newly_freed_flag & (newly_freed_rd == rs2_from_d) & (rs2_from_d != Bits(5)(0))
                ):
                    write_1hot(vk_array_d, newly_append_ind, new_val)
                    write_1hot(qk_array_d, newly_append_ind, Q_DEFAULT)
                    self.log(
                        "RS entry index {} received rs2 x{:02} value 0x{:08x} from commit",
                        newly_append_ind,
                        rs2_from_d,
                        new_val,
                    )

                # Case 4: No producer - read from register file
                with Condition(
                    ~producer_busy_k
                    & (~newly_freed_flag | (newly_freed_rd != rs2_from_d))
                    & (rs2_from_d != Bits(5)(0))
                ):
                    write_1hot(vk_array_d, newly_append_ind, reg_file[rs2_from_d])
                    write_1hot(qk_array_d, newly_append_ind, Q_DEFAULT)
                    self.log(
                        "RS entry index {} got rs2 x{:02} value 0x{:08x} from RegFile",
                        newly_append_ind,
                        rs2_from_d,
                        reg_file[rs2_from_d],
                    )

                # Case 5: x0 is always 0
                with Condition(rs2_from_d == Bits(5)(0)):
                    write_1hot(vk_array_d, newly_append_ind, Bits(32)(0))
                    write_1hot(qk_array_d, newly_append_ind, Q_DEFAULT)
                    self.log(
                        "RS entry index {} has rs2 x0, set value to 0",
                        newly_append_ind,
                    )

            with Condition(~rs2_valid_from_d):
                vk_valid_array[newly_append_ind] = Bits(1)(0)
                write_1hot(vk_array_d, newly_append_ind, Bits(32)(0))
                write_1hot(qk_array_d, newly_append_ind, Q_DEFAULT)
                self.log(
                    "RS entry index {} has unused rs2",
                    newly_append_ind,
                )

            with Condition(rd_valid_from_d):
                rd_valid_array[newly_append_ind] = Bits(1)(1)
                write_1hot(reorder_array_d, rd_from_d, newly_append_ind.bitcast(Bits(32)))
                write_1hot(reorder_busy_array_d, rd_from_d, Bits(1)(1))
                self.log(
                    "Reorder array updated: x{:02} -> RS entry {}",
                    rd_from_d,
                    newly_append_ind,
                )
                rd_array[newly_append_ind] = rd_from_d

            with Condition(~rd_valid_from_d):
                rd_valid_array[newly_append_ind] = Bits(1)(0)
                write_1hot(reorder_array_d, rd_from_d, Bits(32)(0))
                write_1hot(reorder_busy_array_d, rd_from_d, Bits(1)(0))
                self.log(
                    "Reorder array cleared for unused rd x{:02}",
                    rd_from_d,
                )

        reuse_rd_flag = (rd_from_d == newly_freed_rd).select(Bits(1)(1), Bits(1)(0))
        reuse_rd_flag = rd_valid_from_d.select(reuse_rd_flag, Bits(1)(0))
        reuse_rd_flag = (has_entry_from_d & ~revert_flag).select(reuse_rd_flag, Bits(1)(0))
        with Condition(reuse_rd_flag):
            self.log(
                "New entry rd x{:02} reuses freed rd from ROB entry {}",
                newly_freed_rd,
                in_index_from_rob[0],
            )

        with Condition(
            ~reuse_rd_flag & newly_freed_flag & ~revert_flag & (rd_from_d != newly_freed_rd)
        ):
            write_1hot(reorder_array_d, newly_freed_rd, Bits(32)(0))
            write_1hot(reorder_busy_array_d, newly_freed_rd, Bits(1)(0))
            self.log(
                "Reorder array cleared for freed rd x{:02}",
                newly_freed_rd,
            )

        ifetch_continue_flag[0] = (
            busy_entry_count[0].bitcast(Int(32)) < Int(32)(RS_SIZE // 2)
        ).select(Bits(1)(1), Bits(1)(0))

        # Dispatch logic
        ready_flags = []
        ready_indices = []
        for i in range(RS_SIZE):
            ready_flags.append(
                busy_array_d[i][0]
                & ~dispatched_array_d[i][0]
                & (qj_array_d[i][0] == Q_DEFAULT)
                & (qk_array_d[i][0] == Q_DEFAULT)
            )
            ready_indices.append(Bits(RS_SIZE_LOG)(i))

        dispatch_valid, dispatch_index = priority_select_tree(ready_flags, ready_indices)

        dispatch_valid = dispatch_valid & ~revert_flag
        with Condition(dispatch_valid):
            self.log(
                "Dispatching RS entry {} to ROB, pc=0x{:08X}",
                dispatch_index,
                pc_array[dispatch_index].bitcast(Int(32)),
            )
            write_1hot(dispatched_array_d, dispatch_index, Bits(1)(1))

        read_mux(vj_array_d, dispatch_index)
        # Determine if result is ready at dispatch time
        # JAL, JALR, AUIPC, LUI have pre-computed results
        # Store operations don't need result writeback
        # ALU, Load, Branch need to wait for execution
        result_ready_at_dispatch = (
            is_jal_array[dispatch_index]
            | is_jalr_array[dispatch_index]
            | is_auipc_array[dispatch_index]
            | is_lui_array[dispatch_index]
            | memory_array[dispatch_index][1:1]  # Store
        )
        # Send to ROB - simplified, only send necessary fields
        rob.async_called(
            has_entry_from_rs=dispatch_valid,
            memory_from_rs=memory_array[dispatch_index],
            rs1_val_from_rs=read_mux(vj_array_d, dispatch_index),
            dest_from_rs=rob_dest_array[dispatch_index],
            imm_from_rs=imm_array[dispatch_index],
            pc_from_rs=pc_array[dispatch_index],
            ind_from_rs=dispatch_index.bitcast(Bits(32)),
            jump_from_rs=jump_array[dispatch_index],
            is_jalr_from_rs=is_jalr_array[dispatch_index],
            is_branch_from_rs=is_branch_array[dispatch_index],
            sq_pos_from_rs=sq_poses_array[dispatch_index],
            result_from_rs=read_mux(result_array_d, dispatch_index),
            result_ready_from_rs=result_ready_at_dispatch,
            flip_from_rs=flip_array[dispatch_index],
        )

        # Send to LSQ
        lsq_out_flag = dispatch_valid & (memory_array[dispatch_index] != Bits(2)(0))
        with Condition(lsq_out_flag):
            self.log("Dispatching RS entry {} to LSQ", dispatch_index)
        lsq.async_called(
            has_entry_from_rs=lsq_out_flag,
            rs1_val_from_rs=read_mux(vj_array_d, dispatch_index),
            rs2_val_from_rs=read_mux(vk_array_d, dispatch_index),
            imm_val_from_rs=imm_array[dispatch_index],
            memory_from_rs=memory_array[dispatch_index],
            mem_oper_size_from_rs=mem_oper_size_array[dispatch_index],
            mem_oper_signed_from_rs=mem_oper_signed_array[dispatch_index],
            lsq_pos_from_rs=lsq_poses_array[dispatch_index],
            lq_pos_from_rs=lq_poses_array[dispatch_index],
            sq_pos_from_rs=sq_poses_array[dispatch_index],
            rob_dest_from_rs=rob_dest_array[dispatch_index],
        )

        # Send to ALU
        alu_out_flag = (
            dispatch_valid
            & (memory_array[dispatch_index] == Bits(2)(0))
            & alu_valid_array[dispatch_index]
            & ~is_jal_array[dispatch_index]
            & ~is_jalr_array[dispatch_index]
            & ~is_auipc_array[dispatch_index]
            & ~is_lui_array[dispatch_index]
            & ~is_mul_array[dispatch_index]
            & ~is_div_array[dispatch_index]
        )

        alu_a = vj_valid_array[dispatch_index].select(
            read_mux(vj_array_d, dispatch_index), pc_array[dispatch_index]
        )

        alu_b = vk_valid_array[dispatch_index].select(
            read_mux(vk_array_d, dispatch_index), imm_array[dispatch_index]
        )

        op = is_branch_array[dispatch_index].select(
            cond_array[dispatch_index], alu_array[dispatch_index]
        )

        with Condition(alu_out_flag):
            self.log("Dispatching RS entry {} to ALU", dispatch_index)

        alu.async_called(
            alu_valid_from_rs=alu_out_flag,
            op_from_rs=op,
            alu_a_from_rs=alu_a,
            alu_b_from_rs=alu_b,
            rob_idx_from_rs=rob_dest_array[dispatch_index],
        )

        # Send to Multiplier
        mul_out_flag = dispatch_valid & is_mul_array[dispatch_index]
        with Condition(mul_out_flag):
            self.log("Dispatching RS entry {} to Multiplier", dispatch_index)

        mul.async_called(
            valid=mul_out_flag,
            a=read_mux(vj_array_d, dispatch_index),
            b=read_mux(vk_array_d, dispatch_index),
            tag=rob_dest_array[dispatch_index],
            alu=alu_array[dispatch_index],
        )

        # Send to Divider
        div_out_flag = dispatch_valid & is_div_array[dispatch_index]
        with Condition(div_out_flag):
            self.log("Dispatching RS entry {} to Divider", dispatch_index)

        div.async_called(
            valid=div_out_flag,
            a=read_mux(vj_array_d, dispatch_index),
            b=read_mux(vk_array_d, dispatch_index),
            tag=rob_dest_array[dispatch_index],
            alu=alu_array[dispatch_index],
        )
