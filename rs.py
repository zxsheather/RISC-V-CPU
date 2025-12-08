from assassyn.frontend import *
from instruction import *

RS_SIZE = 32
Q_DEFAULT = Bits(32)(127)

class RSWritePort(Module):
    def __init__(self):
        super().__init__(ports={})

class ReservationStation(Module):
    def __init__(self):
        super().__init__(
            ports={
                "decode_signals": Port(DecodeSignals),
                "has_entry_from_d": Port(Bits(1)),
                "pc_from_d": Port(Bits(32)),
                "jump_from_d": Port(Bits(1)),
            }
        )
        self.name = "RS"

    @module.combinational
    def build(
        self,
        in_valid_from_rob: Array,
        in_index_from_rob: Array,
        value_from_rob: Array,
        rob: Module,
        lsq: Module,
        ifetch_continue_flag: Array,
        revert_flag_cdb: Array,
    ):
        (
            signals,
            has_entry_from_d,
            pc_from_d,
            jump_from_d,
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

        with Condition(has_entry_from_d):
            log(
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
                jump_from_d.bitcast(UInt(1)),
            )
        newly_freed_flag = Bits(1)(0)
        newly_freed_rd = Bits(5)(0)

        reuse_rd_flag = Bits(1)(0)

        newly_append_index = RegArray(Bits(32), 1)
        pos_in_rob = RegArray(Bits(32), 1)
        reg_file = RegArray(Bits(32), 32)

        busy_array = RegArray(Bits(1), RS_SIZE, initializer=[0] * RS_SIZE)

        busy_entry_count = RegArray(Bits(32), 1)
        dispatched_array = RegArray(Bits(1), RS_SIZE)
        alu_array = RegArray(Bits(RV32I_ALU.CNT), RS_SIZE)
        alu_valid_array = RegArray(Bits(1), RS_SIZE)
        memory_array = RegArray(Bits(2), RS_SIZE)
        mem_oper_size_array = RegArray(Bits(2), RS_SIZE)
        mem_oper_signed_array = RegArray(Bits(1), RS_SIZE)
        rd_array = RegArray(Bits(5), RS_SIZE)
        rd_valid_array = RegArray(Bits(1), RS_SIZE)
        vj_array = RegArray(Bits(32), RS_SIZE)
        vj_valid_array = RegArray(Bits(1), RS_SIZE)
        vk_array = RegArray(Bits(32), RS_SIZE)
        vk_valid_array = RegArray(Bits(1), RS_SIZE)
        qj_array = RegArray(Bits(32), RS_SIZE)
        qk_array = RegArray(Bits(32), RS_SIZE)
        imm_array = RegArray(Bits(32), RS_SIZE)
        imm_valid_array = RegArray(Bits(1), RS_SIZE)
        rob_dest_array = RegArray(Bits(32), RS_SIZE)
        pc_array = RegArray(Bits(32), RS_SIZE)
        ready_array = RegArray(Bits(1), RS_SIZE)
        jump_array = RegArray(Bits(1), RS_SIZE)
        is_jal_array = RegArray(Bits(1), RS_SIZE)
        is_jalr_array = RegArray(Bits(1), RS_SIZE)
        is_auipc_array = RegArray(Bits(1), RS_SIZE)
        is_lui_array = RegArray(Bits(1), RS_SIZE)
        is_branch_array = RegArray(Bits(1), RS_SIZE)
        cond_array = RegArray(Bits(RV32I_ALU.CNT), RS_SIZE)
        flip_array = RegArray(Bits(1), RS_SIZE)
        reorder_array = RegArray(Bits(32), 32)
        reorder_busy_array = RegArray(Bits(1), 32)
        lsq_poses_array = RegArray(Bits(32), RS_SIZE)
        lsq_pos = RegArray(Bits(32), 1, initializer=[1])
        lq_poses_array = RegArray(Bits(32), RS_SIZE)
        lq_pos = RegArray(Bits(32), 1)
        sq_poses_array = RegArray(Bits(32), RS_SIZE)
        sq_pos = RegArray(Bits(32), 1)

        new_val = in_valid_from_rob[0].select(
            value_from_rob[0], Bits(32)(0)
        )
        new_val = (rd_array[in_index_from_rob[0]] == Bits(32)(0)).select(
            Bits(32)(0), new_val
        )

        write_port_3 = [RSWritePort() for i in range(RS_SIZE)]
        write_port_4 = [RSWritePort() for i in range(RS_SIZE)]

        match_mask = Bits(32)(0)
        update_index = in_index_from_rob[0]
        # Optimized logic to find the freed register
        # 1. Generate match mask in parallel
        for i in range(32):
            is_match = (reorder_busy_array[i] & (reorder_array[i] == update_index))
            match_mask = match_mask | is_match.select(Bits(32)(1 << i), Bits(32)(0))

        # 2. Calculate flag
        newly_freed_flag = (match_mask != Bits(32)(0))

        # 3. Calculate rd using select1hot
        possible_rds = [Bits(5)(i) for i in range(32)]
        # Ensure mask is valid for select1hot (must be one-hot)
        safe_mask = newly_freed_flag.select(match_mask, Bits(32)(1))
        raw_rd = safe_mask.select1hot(*possible_rds)
        
        newly_freed_rd = newly_freed_flag.select(raw_rd, Bits(5)(0))
        newly_freed_rd = in_valid_from_rob[0].select(
            newly_freed_rd, Bits(5)(0)
        )
        newly_freed_flag = in_valid_from_rob[0].select(
            newly_freed_flag, Bits(1)(0)
        )
        revert_flag = revert_flag_cdb[0]
        with Condition(in_valid_from_rob[0]):
            update_index = in_index_from_rob[0]
            with Condition(~revert_flag):
                (busy_array & write_port_3[0])[update_index] = Bits(1)(0)
            busy_entry_count[0] = (
                busy_entry_count[0].bitcast(Int(32)) - Int(32)(1)
            ).bitcast(Bits(32))
            log(
                "Committing from ROB idx={}, value=0x{:08x}",
                update_index,
                new_val,
            )
            for i in range(RS_SIZE):
                with Condition(
                    busy_array[i]
                    & (qj_array[i] == update_index)
                ):
                    (vj_array & write_port_3[i])[i] = new_val
                    (qj_array & write_port_3[i])[i] = Q_DEFAULT
                    log(
                        "RS entry index {} received rs1 value 0x{:08x} from ROB entry {}",
                        Bits(32)(i),
                        new_val,
                        update_index,
                    )
                with Condition(
                    busy_array[i]
                    & (qk_array[i] == update_index)
                ):
                    (vk_array & write_port_4[i])[i] = new_val
                    (qk_array & write_port_4[i])[i] = Q_DEFAULT
                    log(
                        "RS entry index {} received rs2 value 0x{:08x} from ROB entry {}",
                        Bits(32)(i),
                        new_val,
                        update_index,
                    )

            reg_file[rd_array[update_index]] = new_val
            log(
                "RegFile updated: x{:02} = 0x{:08x}",
                rd_array[update_index],
                new_val,
            )

        revert_ports = [RSWritePort() for _ in range(RS_SIZE)]
        with Condition(revert_flag):
            log(
                "Revert triggered, clearing all entries",
            )
            for i in range(RS_SIZE):
                (busy_array & revert_ports[i])[i] = Bits(1)(0)
            for i in range(32):
                (reorder_busy_array & revert_ports[i])[i] = Bits(1)(0)

            lsq_pos[0] = Bits(32)(1)
            newly_append_index[0] = Bits(32)(0)
            pos_in_rob[0] = Bits(32)(0)
            lq_pos[0] = Bits(32)(0)
            sq_pos[0] = Bits(32)(0)
                
                
        write_port_2 = RSWritePort()
        write_port_reorder = RSWritePort()
        write_port_reorder_busy = RSWritePort()

        # Append new entry
        with Condition(has_entry_from_d & ~revert_flag):
            newly_append_ind = newly_append_index[0].bitcast(Int(32))
            newly_append_index[0] = (newly_append_ind + Int(32)(1)) & Int(32)(
                RS_SIZE - 1
            )
            log("New RS entry allocated at index {}", newly_append_ind)
            pos_in_rob[0] = (pos_in_rob[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                Bits(32)
            )
            busy_array[newly_append_ind] = Bits(1)(1)
            busy_entry_count[0] = (
                busy_entry_count[0].bitcast(Int(32)) + Int(32)(1)
            ).bitcast(Bits(32))
            pc_array[newly_append_ind] = pc_from_d
            alu_array[newly_append_ind] = alu_from_d
            alu_valid_array[newly_append_ind] = alu_valid_from_d
            memory_array[newly_append_ind] = memory_from_d
            mem_oper_size_array[newly_append_ind] = mem_oper_size_from_d
            mem_oper_signed_array[newly_append_ind] = mem_oper_signed_from_d
            imm_array[newly_append_ind] = imm_from_d
            imm_valid_array[newly_append_ind] = imm_valid_from_d
            jump_array[newly_append_ind] = jump_from_d

            is_jal_array[newly_append_ind] = signals.is_jal
            is_jalr_array[newly_append_ind] = signals.is_jalr
            is_auipc_array[newly_append_ind] = signals.is_auipc
            is_lui_array[newly_append_ind] = signals.is_lui
            is_branch_array[newly_append_ind] = signals.is_branch_inst
            cond_array[newly_append_ind] = signals.cond
            flip_array[newly_append_ind] = signals.flip

            (dispatched_array & write_port_2)[newly_append_ind] = Bits(1)(0)
            rob_dest_array[newly_append_ind] = pos_in_rob[0]

            with Condition(memory_from_d[0:0] == Bits(1)(1)):  # Load
                lsq_poses_array[newly_append_ind] = lsq_pos[0]
                lsq_pos[0] = (lsq_pos[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                )
                lq_poses_array[newly_append_ind] = lq_pos[0]
                lq_pos[0] = (lq_pos[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                )
                log(
                    "RS entry index {} assigned LSQ load position {}, LQ position {}",
                    newly_append_ind,
                    lsq_poses_array[newly_append_ind],
                    lq_poses_array[newly_append_ind],
                )

            with Condition(memory_from_d[1:1] == Bits(1)(1)):  # Store
                lsq_poses_array[newly_append_ind] = lsq_pos[0]
                lsq_pos[0] = (lsq_pos[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                )
                sq_poses_array[newly_append_ind] = sq_pos[0]
                sq_pos[0] = (sq_pos[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                )
                log(
                    "RS entry index {} assigned LSQ store position {}, SQ position {}",
                    newly_append_ind,
                    lsq_poses_array[newly_append_ind],
                    sq_poses_array[newly_append_ind],
                )

            with Condition(rs1_valid_from_d):
                vj_valid_array[newly_append_ind] = Bits(1)(1)
                with Condition(
                    reorder_busy_array[rs1_from_d]
                    & (~newly_freed_flag | (newly_freed_rd != rs1_from_d))
                ):
                    qj_array[newly_append_ind] = reorder_array[rs1_from_d]
                    vj_array[newly_append_ind] = Bits(32)(0)
                    log(
                        "RS entry index {} waiting for rs1 x{:02} from ROB entry {}",
                        newly_append_ind,
                        rs1_from_d,
                        reorder_array[rs1_from_d],
                    )
                with Condition(newly_freed_flag & (newly_freed_rd == rs1_from_d)):
                    vj_array[newly_append_ind] = value_from_rob[0]
                    qj_array[newly_append_ind] = Q_DEFAULT
                    log(
                        "RS entry index {} received rs1 x{:02} value 0x{:08x} from ROB",
                        newly_append_ind,
                        rs1_from_d,
                        value_from_rob[0],
                    )
                with Condition(
                    ~reorder_busy_array[rs1_from_d]
                    & (~newly_freed_flag | (newly_freed_rd != rs1_from_d))
                ):
                    vj_array[newly_append_ind] = reg_file[rs1_from_d]
                    qj_array[newly_append_ind] = Q_DEFAULT
                    log(
                        "RS entry index {} got rs1 x{:02} value 0x{:08x} from RegFile",
                        newly_append_ind,
                        rs1_from_d,
                        reg_file[rs1_from_d],
                    )

            with Condition(~rs1_valid_from_d):
                vj_valid_array[newly_append_ind] = Bits(1)(0)
                vj_array[newly_append_ind] = Bits(32)(0)
                qj_array[newly_append_ind] = Q_DEFAULT
                log(
                    "RS entry index {} has unused rs1",
                    newly_append_ind,
                )

            with Condition(rs2_valid_from_d):
                vk_valid_array[newly_append_ind] = Bits(1)(1)
                with Condition(
                    reorder_busy_array[rs2_from_d]
                    & (~newly_freed_flag | (newly_freed_rd != rs2_from_d))
                ):
                    qk_array[newly_append_ind] = reorder_array[rs2_from_d]
                    vk_array[newly_append_ind] = Bits(32)(0)
                    log(
                        "RS entry index {} waiting for rs2 x{:02} from ROB entry {}",
                        newly_append_ind,
                        rs2_from_d,
                        reorder_array[rs2_from_d],
                    )
                with Condition(newly_freed_flag & newly_freed_rd == rs2_from_d):
                    vk_array[newly_append_ind] = value_from_rob[0]
                    qk_array[newly_append_ind] = Q_DEFAULT
                    log(
                        "RS entry index {} received rs2 x{:02} value 0x{:08x} from ROB",
                        newly_append_ind,
                        rs2_from_d,
                        value_from_rob[0],
                    )
                with Condition(
                    ~reorder_busy_array[rs2_from_d]
                    & (~newly_freed_flag | (newly_freed_rd != rs2_from_d))
                ):
                    vk_array[newly_append_ind] = reg_file[rs2_from_d]
                    qk_array[newly_append_ind] = Q_DEFAULT
                    log(
                        "RS entry index {} got rs2 x{:02} value 0x{:08x} from RegFile",
                        newly_append_ind,
                        rs2_from_d,
                        reg_file[rs2_from_d],
                    )

            with Condition(~rs2_valid_from_d):
                vk_valid_array[newly_append_ind] = Bits(1)(0)
                vk_array[newly_append_ind] = Bits(32)(0)
                qk_array[newly_append_ind] = Q_DEFAULT
                log(
                    "RS entry index {} has unused rs2",
                    newly_append_ind,
                )

            with Condition(rd_valid_from_d):
                rd_valid_array[newly_append_ind] = Bits(1)(1)
                (reorder_array & write_port_reorder)[rd_from_d] = newly_append_ind.bitcast(Bits(32))
                (reorder_busy_array & write_port_reorder_busy)[rd_from_d] = Bits(1)(1)
                log(
                    "Reorder array updated: x{:02} -> RS entry {}",
                    rd_from_d,
                    newly_append_ind,
                )
                rd_array[newly_append_ind] = rd_from_d

                with Condition(rd_from_d == newly_freed_rd):
                    reuse_rd_flag = Bits(1)(1)

            with Condition(~rd_valid_from_d):
                rd_valid_array[newly_append_ind] = Bits(1)(0)
                (reorder_array & write_port_reorder)[rd_from_d] = Bits(32)(0)
                (reorder_busy_array & write_port_reorder_busy)[rd_from_d] = Bits(1)(0)
                log(
                    "Reorder array cleared for unused rd x{:02}",
                    rd_from_d,
                )

        with Condition(~reuse_rd_flag & newly_freed_flag):
            reorder_array[newly_freed_rd] = Bits(32)(0)
            reorder_busy_array[newly_freed_rd] = Bits(1)(0)
            log(
                "Reorder array cleared for freed rd x{:02}",
                newly_freed_rd,
            )

        ifetch_continue_flag[0] = (
            busy_entry_count[0].bitcast(Int(32)) < Int(32)(RS_SIZE // 2)
        ).select(Bits(1)(1), Bits(1)(0))

        # Dispatch logic
        dispatch_index = Bits(32)(0)
        # dispatch_flag = Bits(1)(0)
        has_selected = Bits(1)(0)
        for i in range(RS_SIZE):
            entry_ready = (
                busy_array[i]
                & ~dispatched_array[i]
                & (qj_array[i] == Q_DEFAULT)
                & (qk_array[i] == Q_DEFAULT)
            )
            is_selected = entry_ready & ~has_selected
            current_index_value = is_selected.select(Bits(32)(i), Bits(32)(0))
            dispatch_index = dispatch_index | current_index_value

            has_selected = has_selected | entry_ready

        has_selected = has_selected & ~revert_flag
        with Condition(has_selected):
            log("Dispatching RS entry {} to ROB", dispatch_index)
            dispatched_array[dispatch_index] = Bits(1)(1)

        # Send to ROB
        rob.async_called(
            has_entry_from_rs=has_selected,
            alu_from_rs=alu_array[dispatch_index],
            alu_valid_from_rs=alu_valid_array[dispatch_index],
            memory_from_rs=memory_array[dispatch_index],
            rs1_val_from_rs=vj_array[dispatch_index],
            rs1_valid_from_rs=vj_valid_array[dispatch_index],
            rs2_val_from_rs=vk_array[dispatch_index],
            rs2_valid_from_rs=vk_valid_array[dispatch_index],
            dest_from_rs=rob_dest_array[dispatch_index],
            imm_from_rs=imm_array[dispatch_index],
            pc_from_rs=pc_array[dispatch_index],
            ind_from_rs=dispatch_index.bitcast(Bits(32)),
            jump_from_rs=jump_array[dispatch_index],
            is_jal_from_rs=is_jal_array[dispatch_index],
            is_jalr_from_rs=is_jalr_array[dispatch_index],
            is_auipc_from_rs=is_auipc_array[dispatch_index],
            is_lui_from_rs=is_lui_array[dispatch_index],
            is_branch_from_rs=is_branch_array[dispatch_index],
            cond_from_rs=cond_array[dispatch_index],
            flip_from_rs=flip_array[dispatch_index],
            sq_pos_from_rs=sq_poses_array[dispatch_index],
        )

        # Send to LSQ
        lsq_out_flag = has_selected & (memory_array[dispatch_index] != Bits(2)(0))
        with Condition(lsq_out_flag):
            log("Dispatching RS entry {} to LSQ", dispatch_index)
        lsq.async_called(
            has_entry_from_rs=lsq_out_flag,
            rs1_val_from_rs=vj_array[dispatch_index],
            rs2_val_from_rs=vk_array[dispatch_index],
            imm_val_from_rs=imm_array[dispatch_index],
            memory_from_rs=memory_array[dispatch_index],
            lsq_pos_from_rs=lsq_poses_array[dispatch_index],
            lq_pos_from_rs=lq_poses_array[dispatch_index],
            sq_pos_from_rs=sq_poses_array[dispatch_index],
            rob_dest_from_rs=rob_dest_array[dispatch_index],
        )