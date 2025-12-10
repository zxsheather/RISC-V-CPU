from assassyn.frontend import *
from utils import *

LSQ_SIZE = 16


def write_1hot(arrs, idx_val, payload):
    for i, arr in enumerate(arrs):
        with Condition(idx_val == Bits(32)(i)):
            arr[0] = payload


def read_mux(arrs, idx_val):
    return idx_val.case({Bits(32)(i): arrs[i][0] for i, arr in enumerate(arrs)} | {None: arrs[0][0]})


class LSQ(Module):
    def __init__(self):
        super().__init__(
            ports={
                "has_entry_from_rs": Port(Bits(1)),
                "rs1_val_from_rs": Port(Bits(32)),
                "rs2_val_from_rs": Port(Bits(32)),
                "imm_val_from_rs": Port(Bits(32)),
                "memory_from_rs": Port(Bits(2)),
                "lsq_pos_from_rs": Port(Bits(32)),
                "lq_pos_from_rs": Port(Bits(32)),
                "sq_pos_from_rs": Port(Bits(32)),
                "rob_dest_from_rs": Port(Bits(32)),
            }
        )
        self.name = "LSQ"

    @module.combinational
    def build(
        self,
        dcache: SRAM,
        depth_log: int,
        out_valid_to_rob,
        rob_dest_to_rob,
        commit_sq_pos_from_rob: Array,
        commit_valid_from_rob: Array,
        revert_flag_cdb: Array,
    ):
        (
            has_entry_from_rs,
            rs1_val_from_rs,
            rs2_val_from_rs,
            imm_val_from_rs,
            memory_from_rs,
            lsq_pos_from_rs,
            lq_pos_from_rs,
            sq_pos_from_rs,
            rob_dest_from_rs,
        ) = self.pop_all_ports(False)

        lsq_head = RegArray(Bits(32), 1, initializer=[1])
        lq_head = RegArray(Bits(32), 1)
        sq_head = RegArray(Bits(32), 1)
        # LQ table
        # lq_busy_array = RegArray(Bits(1), LSQ_SIZE)
        lq_busy_array_d = [RegArray(Bits(1), 1) for _ in range(LSQ_SIZE)]
        lq_addr_array = RegArray(Bits(32), LSQ_SIZE)
        lq_rob_dest_array = RegArray(Bits(32), LSQ_SIZE)
        lq_lsq_pos_array = RegArray(Bits(32), LSQ_SIZE)

        # SQ table
        # sq_busy_array = RegArray(Bits(1), LSQ_SIZE)
        sq_busy_array_d = [RegArray(Bits(1), 1) for _ in range(LSQ_SIZE)]
        sq_addr_array = RegArray(Bits(32), LSQ_SIZE)
        sq_data_array = RegArray(Bits(32), LSQ_SIZE)
        # sq_is_committed_array = RegArray(Bits(1), LSQ_SIZE)
        # sq_lsq_pos_array = RegArray(Bits(32), LSQ_SIZE)
        sq_is_committed_array_d = [
            RegArray(Bits(1), 1) for _ in range(LSQ_SIZE)]
        sq_lsq_pos_array_d = [RegArray(Bits(32), 1) for _ in range(LSQ_SIZE)]

        # Commit SQ entries from ROB
        with Condition(commit_valid_from_rob[0]):
            write_1hot(sq_is_committed_array_d, commit_sq_pos_from_rob[0] & Bits(
                32)(LSQ_SIZE - 1), Bits(1)(1))
            log(
                "Receive commit for SQ entry: sq_pos={}",
                commit_sq_pos_from_rob[0].bitcast(UInt(32)),
            )

        # Revert on misprediction
        with Condition(revert_flag_cdb[0]):
            log(
                "Received revert signal, flushing LSQ"
            )
            lsq_head[0] = Bits(32)(1)
            lq_head[0] = Bits(32)(0)
            for _, arr in enumerate(lq_busy_array_d):
                arr[0] = Bits(1)(0)
            for _, arr in enumerate(sq_busy_array_d):
                arr[0] = Bits(1)(0)
            for _, arr in enumerate(sq_lsq_pos_array_d):
                arr[0] = Bits(32)(0)

            with Condition(read_mux(sq_is_committed_array_d, sq_head[0]) == Bits(1)(0)):
                log(
                    "sq_is_committed_array[{}] == 0 on revert, setting sq_head to 0",
                    sq_head[0].bitcast(UInt(32)),
                )
                sq_head[0] = Bits(32)(0)

        with Condition(has_entry_from_rs & (~revert_flag_cdb[0])):
            with Condition(memory_from_rs[0:0] == Bits(1)(1)):  # Load
                index = lq_pos_from_rs & Bits(32)(LSQ_SIZE - 1)
                write_1hot(lq_busy_array_d, index, Bits(1)(1))
                addr = rs1_val_from_rs.bitcast(Int(32)) + imm_val_from_rs.bitcast(
                    Int(32)
                )
                lq_addr_array[index] = addr.bitcast(Bits(32))
                lq_rob_dest_array[index] = rob_dest_from_rs
                lq_lsq_pos_array[index] = lsq_pos_from_rs
                log(
                    "Append LQ Entry: index={}, addr=0x{:08x}, rob_dest=0x{:08x}, lsq_pos={}",
                    index.bitcast(UInt(32)),
                    addr.bitcast(UInt(32)),
                    rob_dest_from_rs.bitcast(UInt(32)),
                    lsq_pos_from_rs.bitcast(UInt(32)),
                )

            with Condition(memory_from_rs[1:1] == Bits(1)(1)):  # Store
                index = sq_pos_from_rs & Bits(32)(LSQ_SIZE - 1)
                write_1hot(sq_busy_array_d, index, Bits(1)(1))
                addr = rs1_val_from_rs.bitcast(Int(32)) + imm_val_from_rs.bitcast(
                    Int(32)
                )
                sq_addr_array[index] = addr.bitcast(Bits(32))
                sq_data_array[index] = rs2_val_from_rs
                write_1hot(sq_is_committed_array_d, index, Bits(1)(0))
                write_1hot(sq_lsq_pos_array_d, index, lsq_pos_from_rs)
                log(
                    "Append SQ Entry: index={}, addr=0x{:08x}, data=0x{:08x}, lsq_pos={}",
                    index.bitcast(UInt(32)),
                    addr.bitcast(UInt(32)),
                    rs2_val_from_rs.bitcast(UInt(32)),
                    lsq_pos_from_rs.bitcast(UInt(32)),
                )

        # Execute head entry
        store_flag = (
            read_mux(sq_busy_array_d, sq_head[0])
            & ((read_mux(sq_lsq_pos_array_d, sq_head[0]) == lsq_head[0]) | (read_mux(sq_lsq_pos_array_d, sq_head[0]) == Bits(32)(0)))
            & read_mux(sq_is_committed_array_d, sq_head[0])
            & ~revert_flag_cdb[0]
        )

        load_flag = read_mux(lq_busy_array_d, lq_head[0]) & (
            lq_lsq_pos_array[lq_head[0]] == lsq_head[0]
        ) & (~store_flag) & (~revert_flag_cdb[0])
        requested_addr = load_flag.select(
            lq_addr_array[lq_head[0]][2: 2 +
                                      depth_log - 1].bitcast(UInt(depth_log)),
            sq_addr_array[sq_head[0]][2: 2 +
                                      depth_log - 1].bitcast(UInt(depth_log)),
        )
        out_valid_to_rob[0] = load_flag
        rob_dest_to_rob[0] = load_flag.select(
            lq_rob_dest_array[lq_head[0]], Bits(32)(0)
        )
        with Condition(load_flag | store_flag):
            log(
                "Execute Entry: LSQ pos={}, Load={}, Store={}",
                lsq_head[0].bitcast(UInt(32)),
                load_flag.bitcast(UInt(1)),
                store_flag.bitcast(UInt(1)),
            )

            with Condition(load_flag):
                lsq_head[0] = (lsq_head[0].bitcast(Int(32)) +
                               Int(32)(1)).bitcast(Bits(32))
                write_1hot(lq_busy_array_d, lq_head[0], Bits(1)(0))
                log(
                    "Load: LQ index={}, addr=0x{:08x}",
                    lq_head[0].bitcast(UInt(32)),
                    lq_addr_array[lq_head[0]],
                )
                lq_head[0] = (lq_head[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                )

            with Condition(store_flag):
                with Condition(
                    read_mux(sq_lsq_pos_array_d, sq_head[0]) == Bits(32)(0)
                ):

                    log(
                        "Store with lsq_pos=0, treating as committed already before flushing"
                    )
                with Condition(
                    read_mux(sq_lsq_pos_array_d, sq_head[0]) != Bits(32)(0)
                ):
                    lsq_head[0] = (lsq_head[0].bitcast(
                        Int(32)) + Int(32)(1)).bitcast(Bits(32))
                write_1hot(sq_busy_array_d, sq_head[0], Bits(1)(0))
                log(
                    "Store: SQ index={}, addr=0x{:08x}, data=0x{:08x}, is_committed={}",
                    sq_head[0].bitcast(UInt(32)),
                    sq_addr_array[sq_head[0]],
                    sq_data_array[sq_head[0]],
                    read_mux(sq_is_committed_array_d, sq_head[0]),
                )
                sq_head[0] = (sq_head[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                )

        dcache.build(
            we=store_flag,
            re=load_flag,
            addr=requested_addr,
            wdata=sq_data_array[sq_head[0]],
        )
