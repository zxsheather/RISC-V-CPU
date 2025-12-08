from assassyn.frontend import *
from instruction import *

ROB_SIZE = 32


class ROBWritePort(Module):
    def __init__(self):
        super().__init__(ports={})


class ROB(Module):
    def __init__(self):
        super().__init__(
            ports={
                "has_entry_from_rs": Port(Bits(1)),
                "alu_from_rs": Port(Bits(RV32I_ALU.CNT)),
                "alu_valid_from_rs": Port(Bits(1)),
                "memory_from_rs": Port(Bits(2)),
                "rs1_val_from_rs": Port(Bits(32)),
                "rs1_valid_from_rs": Port(Bits(1)),
                "rs2_val_from_rs": Port(Bits(32)),
                "rs2_valid_from_rs": Port(Bits(1)),
                "dest_from_rs": Port(Bits(32)),
                "imm_from_rs": Port(Bits(32)),
                "pc_from_rs": Port(Bits(32)),
                "ind_from_rs": Port(Bits(32)),
                "jump_from_rs": Port(Bits(1)),
                "is_jal_from_rs": Port(Bits(1)),
                "is_jalr_from_rs": Port(Bits(1)),
                "is_auipc_from_rs": Port(Bits(1)),
                "is_lui_from_rs": Port(Bits(1)),
                "is_branch_from_rs": Port(Bits(1)),
                "cond_from_rs": Port(Bits(RV32I_ALU.CNT)),
                "flip_from_rs": Port(Bits(1)),
                "sq_pos_from_rs": Port(Bits(32)),
            }
        )
        self.name = "ROB"

    @module.combinational
    def build(
        self,
        alu: Module,
        out_valid_to_rs: Array,
        value_to_rs: Array,
        index_to_rs: Array,
        revert_flag_cdb: Array,
        bypass_valid_to_if: Array,
        updated_pc_to_if: Array,
        is_jump_to_if: Array,
        alu_valid_from_alu: Array,
        alu_value_from_alu: Array,
        rob_index_from_alu: Array,
        in_valid_from_lsq: Array,
        value_from_dcache: Array,
        rob_dest_from_lsq: Array,
        commit_sq_pos_to_lsq: Array,
        commit_valid_to_lsq: Array,
    ):
        pos = RegArray(Bits(32), 1)

        # ROB table
        busy_array = RegArray(Bits(1), ROB_SIZE)
        alu_array = RegArray(Bits(RV32I_ALU.CNT), ROB_SIZE)
        alu_valid_array = RegArray(Bits(1), ROB_SIZE)
        memory_from_rs_array = RegArray(Bits(2), ROB_SIZE)
        rs1_val_array = RegArray(Bits(32), ROB_SIZE)
        rs1_valid_array = RegArray(Bits(1), ROB_SIZE)
        rs2_val_array = RegArray(Bits(32), ROB_SIZE)
        rs2_valid_array = RegArray(Bits(1), ROB_SIZE)
        dest_array = RegArray(Bits(32), ROB_SIZE)
        imm_array = RegArray(Bits(32), ROB_SIZE)
        pc_array = RegArray(Bits(32), ROB_SIZE)
        ind_array = RegArray(Bits(32), ROB_SIZE)
        jump_array = RegArray(Bits(1), ROB_SIZE)
        is_jal_from_rs_array = RegArray(Bits(1), ROB_SIZE)
        is_jalr_from_rs_array = RegArray(Bits(1), ROB_SIZE)
        is_auipc_from_rs_array = RegArray(Bits(1), ROB_SIZE)
        is_lui_from_rs_array = RegArray(Bits(1), ROB_SIZE)
        is_branch_from_rs_array = RegArray(Bits(1), ROB_SIZE)
        cond_from_rs_array = RegArray(Bits(RV32I_ALU.CNT), ROB_SIZE)
        flip_from_rs_array = RegArray(Bits(1), ROB_SIZE)
        sq_pos_from_rs_array = RegArray(Bits(32), ROB_SIZE)
        ready_array = RegArray(Bits(1), ROB_SIZE)
        value_array = RegArray(Bits(32), ROB_SIZE)

        (
            has_entry_from_rs,
            alu_from_rs,
            alu_valid_from_rs,
            memory_from_rs,
            rs1_val_from_rs,
            rs1_valid_from_rs,
            rs2_val_from_rs,
            rs2_valid_from_rs,
            dest_from_rs,
            imm_from_rs,
            pc_from_rs,
            ind_from_rs,
            jump_from_rs,
            is_jal_from_rs,
            is_jalr_from_rs,
            is_auipc_from_rs,
            is_lui_from_rs,
            is_branch_from_rs,
            cond_from_rs,
            flip_from_rs,
            sq_pos_from_rs,
        ) = self.pop_all_ports(False)

        with Condition(revert_flag_cdb[0]):
            revert_flag_cdb[0] = Bits(1)(0)
            log("Resume after revert")
    
        with Condition(~revert_flag_cdb[0]):
            # commit head entry
            write_port_commit = ROBWritePort()
            commit_flag = busy_array[pos[0]] & ready_array[pos[0]]
            bypass_valid_to_if[0] = commit_flag & (
                is_branch_from_rs_array[pos[0]] | is_jalr_from_rs_array[pos[0]]
            )
            revert_flag = (
                commit_flag
                & is_branch_from_rs_array[pos[0]]
                & ((value_array[pos[0]][0:0] ^ jump_array[pos[0]][0:0]))
            )
            revert_flag_cdb[0] = revert_flag
            with Condition(commit_flag):
                log(
                    "Committing entry rob_idx={}, dest={}, value={}, rs_idx={}",
                    pos[0],
                    dest_array[pos[0]],
                    value_array[pos[0]],
                    ind_array[pos[0]],
                )
                index_to_rs[0] = ind_array[pos[0]]
                head = pos[0]
                with Condition(~revert_flag):
                    # If revert triggered, clearing entries is handled later
                    (busy_array & write_port_commit)[head] = Bits(1)(0)
                    pos[0] = (head.bitcast(Int(32)) + Int(32)(1)).bitcast(Bits(32))
                (ready_array & write_port_commit)[head] = Bits(1)(0)
                with Condition(
                    is_jal_from_rs_array[head] | is_jalr_from_rs_array[head]
                ):
                    log("is_jal/jalr, value_to_rs[0] = {}", value_array[head])
                    value_to_rs[0] = pc_array[head] + Bits(32)(4)

                with Condition(is_auipc_from_rs_array[head]):
                    log(
                        "is_auipc, value_to_rs[0] = {}",
                        pc_array[head] + imm_array[head],
                    )
                    value_to_rs[0] = pc_array[head] + imm_array[head]

                with Condition(is_lui_from_rs_array[head]):
                    log("is_lui, value_to_rs[0] = {}", imm_array[head])
                    value_to_rs[0] = imm_array[head]

                with Condition(alu_valid_array[head]):
                    log("alu_type, value_to_rs[0] = {}", value_array[head])
                    value_to_rs[0] = value_array[head]

                with Condition(memory_from_rs_array[head][0:0] == Bits(1)(1)):
                    log("load_type, value_to_rs[0] = {}", value_array[head])
                    value_to_rs[0] = value_array[head]

                with Condition(memory_from_rs_array[head][1:1] == Bits(1)(1)):
                    value_to_rs[0] = Bits(32)(0)
                    commit_sq_pos_to_lsq[0] = sq_pos_from_rs_array[head]
                    commit_valid_to_lsq[0] = Bits(1)(1)
                    log(
                        "store_type, commit_sq_pos_to_lsq[0] = {}",
                        sq_pos_from_rs_array[head],
                    )
                with Condition(~(memory_from_rs_array[head][1:1] == Bits(1)(1))):
                    commit_valid_to_lsq[0] = Bits(1)(0)

                with Condition(is_branch_from_rs_array[head]):
                    log("is_branch_type, value_array[head] = {}", value_array[head])
                    predict_result = ~(value_array[head][0:0] ^ jump_array[head][0:0])

                    # Branch taken
                    with Condition(value_array[head][0:0]):
                        updated_pc_to_if[0] = pc_array[head] + imm_array[head]
                        is_jump_to_if[0] = Bits(1)(1)

                    # Branch not taken
                    with Condition(~value_array[head][0:0]):
                        updated_pc_to_if[0] = pc_array[head] + Bits(32)(4)
                        is_jump_to_if[0] = Bits(1)(0)

                    with Condition(~predict_result):
                        log(
                            "Branch mispredict at idx={}, pc={}, predicted={}, actual={}",
                            head,
                            pc_array[head],
                            jump_array[head][0:0],
                            value_array[head][0:0],
                        )

                    with Condition(predict_result):
                        log(
                            "Branch correct at idx={}, pc={}, predicted={}, actual={}",
                            head,
                            pc_array[head],
                            jump_array[head][0:0],
                            value_array[head][0:0],
                        )

                with Condition(is_jalr_from_rs_array[head]):
                    updated_pc_to_if[0] = (
                        rs1_val_array[head] + imm_array[head]
                    ) & Bits(32)(0xFFFFFFFE)
                    is_jump_to_if[0] = Bits(1)(1)

                out_valid_to_rs[0] = Bits(1)(1)

            revert_ports = [ROBWritePort() for _ in range(ROB_SIZE)]
            with Condition(revert_flag):
                log(
                    "Revert triggered at idx={}, pc={}",
                    pos[0],
                    pc_array[pos[0]],
                )
                pos[0] = Bits(32)(0)
                # Clear all entries
                for i in range(ROB_SIZE):
                    (busy_array & revert_ports[i])[i] = Bits(1)(0)

            with Condition(~commit_flag):
                out_valid_to_rs[0] = Bits(1)(0)
                commit_valid_to_lsq[0] = Bits(1)(0)
                log(
                    "No commit, busy={}, ready={}, idx={}",
                    busy_array[pos[0]],
                    ready_array[pos[0]],
                    pos[0],
                )

            # receive from ALU
            write_port_alu = ROBWritePort()
            with Condition(alu_valid_from_alu[0] & ~revert_flag):
                alu_idx = rob_index_from_alu[0]
                (ready_array & write_port_alu)[alu_idx] = Bits(1)(1)
                (value_array & write_port_alu)[alu_idx] = flip_from_rs_array[
                    alu_idx
                ].select(
                    alu_value_from_alu[0] ^ Bits(32)(1),
                    alu_value_from_alu[0],
                )
                log(
                    "Received from ALU idx={}, value=0x{:08x}",
                    alu_idx,
                    alu_value_from_alu[0],
                )

            # receive from LSQ
            write_port_lsq = ROBWritePort()
            with Condition(in_valid_from_lsq[0] & ~revert_flag):
                lsq_idx = rob_dest_from_lsq[0] & Bits(32)(ROB_SIZE - 1)
                (ready_array & write_port_lsq)[lsq_idx] = Bits(1)(1)
                (value_array & write_port_lsq)[lsq_idx] = value_from_dcache[0]
                log(
                    "Received from LSQ idx={}, value=0x{:08x}",
                    lsq_idx,
                    value_from_dcache[0],
                )

            # append new entry
            idx = (dest_from_rs & Bits(32)(ROB_SIZE - 1)).bitcast(Int(32))
            # Currently we don't send memory instructions to ALU
            alu_flag = (
                (
                    (alu_valid_from_rs & (memory_from_rs == Bits(2)(0)))
                    | is_branch_from_rs
                )
                & ~revert_flag
                & has_entry_from_rs
            )

            with Condition(has_entry_from_rs & ~revert_flag):
                busy_array[idx] = Bits(1)(1)
                alu_array[idx] = alu_from_rs
                rs1_val_array[idx] = rs1_val_from_rs
                rs1_valid_array[idx] = rs1_valid_from_rs
                alu_valid_array[idx] = alu_flag & ~is_branch_from_rs
                memory_from_rs_array[idx] = memory_from_rs
                rs2_valid_array[idx] = rs2_valid_from_rs
                rs2_val_array[idx] = rs2_val_from_rs
                dest_array[idx] = dest_from_rs
                imm_array[idx] = imm_from_rs
                pc_array[idx] = pc_from_rs
                ind_array[idx] = ind_from_rs
                jump_array[idx] = jump_from_rs
                is_jal_from_rs_array[idx] = is_jal_from_rs
                is_jalr_from_rs_array[idx] = is_jalr_from_rs
                is_auipc_from_rs_array[idx] = is_auipc_from_rs
                is_lui_from_rs_array[idx] = is_lui_from_rs
                is_branch_from_rs_array[idx] = is_branch_from_rs
                cond_from_rs_array[idx] = cond_from_rs
                flip_from_rs_array[idx] = flip_from_rs
                sq_pos_from_rs_array[idx] = sq_pos_from_rs

                ready_flag = ~alu_flag & ~memory_from_rs[0:0]
                (ready_array & self)[idx] = ready_flag.select(Bits(1)(1), Bits(1)(0))

                log(
                    "Appended entry idx={}, ind_rs={}, pc={}, rs1={}, rs2={}, imm={}, alu={}, memory={}, alu_valid={}, ready={}, cond={}, flip={}",
                    idx,
                    ind_from_rs,
                    pc_from_rs,
                    rs1_val_from_rs,
                    rs2_val_from_rs,
                    imm_from_rs,
                    alu_from_rs,
                    memory_from_rs,
                    alu_flag,
                    ready_flag,
                    cond_from_rs,
                    flip_from_rs,
                )

            # If the instruction is ALU type, send to ALU for execution
            alu_a = rs1_valid_from_rs.select(rs1_val_from_rs, pc_from_rs)
            alu_b = rs2_valid_from_rs.select(rs2_val_from_rs, imm_from_rs)

            op = is_branch_from_rs.select(cond_from_rs, alu_from_rs)
            alu.async_called(
                op_from_rob=op,
                alu_valid_from_rob=alu_flag,
                alu_a_from_rob=alu_a,
                alu_b_from_rob=alu_b,
                rob_idx_from_rob=idx.bitcast(Bits(32)),
            )
            with Condition(alu_flag):
                log(
                    "Sent to ALU idx={} alu_a={} alu_b={}, op={}, alu_valid={}, is_branch={}",
                    idx,
                    alu_a,
                    alu_b,
                    op,
                    alu_valid_from_rs,
                    is_branch_from_rs,
                )
