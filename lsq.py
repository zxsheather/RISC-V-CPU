from assassyn.frontend import *
from utils import *

LSQ_SIZE = 16
LSQ_SIZE_LOG = 4  # log2(LSQ_SIZE)
DCACHE_OFFSET = 0x10000


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
        self.log = Logger(enabled=LSQLogEnabled)

    @module.combinational
    def build(
        self,
        dcache: SRAM,
        depth_log: int,
        out_valid_to_rob,
        rob_dest_to_rob,
        mem_addr_to_rob,
        commit_sq_pos_from_rob: Array,
        commit_valid_from_rob: Array,
        update_sq_pos_to_rs: Array,
        valid_to_rs: Array,
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
        sq_is_committed_array_d = [RegArray(Bits(1), 1) for _ in range(LSQ_SIZE)]
        sq_lsq_pos_array_d = [RegArray(Bits(32), 1) for _ in range(LSQ_SIZE)]

        # Commit SQ entries from ROB
        with Condition(commit_valid_from_rob[0]):
            write_1hot(
                sq_is_committed_array_d,
                commit_sq_pos_from_rob[0] & Bits(32)(LSQ_SIZE - 1),
                Bits(1)(1),
            )
            self.log(
                "Receive commit for SQ entry: sq_pos={}",
                commit_sq_pos_from_rob[0].bitcast(UInt(32)),
            )

        # Revert on misprediction
        sq_pos_need_update = read_mux(sq_is_committed_array_d, sq_head[0]) & read_mux(
            sq_busy_array_d, sq_head[0]
        )
        valid_to_rs[0] = revert_flag_cdb[0] & sq_pos_need_update
        with Condition(revert_flag_cdb[0]):
            self.log("Received revert signal, flushing LSQ")

            with Condition(~sq_pos_need_update):
                self.log(
                    "sq_is_committed_array[{}] == 0 on revert, setting sq_head to 0",
                    sq_head[0].bitcast(UInt(32)),
                )
                sq_head[0] = Bits(32)(0)

            with Condition(sq_pos_need_update):
                self.log(
                    "sq_is_committed_array[{}] == 1 on revert, keeping sq_head as is",
                    sq_head[0].bitcast(UInt(32)),
                )

                # Find the next sq index for rs
                """ 
                    Note: committed entries are not flushed, so we need to find the max committed sq pos.
                    And committed entries are continuous from sq_head to higher positions Since 
                    ROB commits in order.
                """
                max_sq_committed_index = Bits(32)(0)
                max_lsq_pos = Bits(32)(0)
                for i in range(LSQ_SIZE):
                    is_committed_sq = (
                        sq_is_committed_array_d[i][0] & sq_busy_array_d[i][0]
                    )
                    is_selected_sq = is_committed_sq & (
                        sq_lsq_pos_array_d[i][0] > max_lsq_pos
                    )
                    max_lsq_pos = is_selected_sq.select(
                        sq_lsq_pos_array_d[i][0], max_lsq_pos
                    )
                    max_sq_committed_index = is_selected_sq.select(
                        Bits(32)(i), max_sq_committed_index
                    )

                update_sq_pos_to_rs[0] = (
                    max_sq_committed_index.bitcast(UInt(32)) + UInt(32)(1)
                ).bitcast(Bits(32))
                self.log(
                    "After revert, updating RS sq_pos to {}",
                    (max_sq_committed_index.bitcast(UInt(32)) + UInt(32)(1)).bitcast(
                        Bits(32)
                    ),
                )

            lsq_head[0] = Bits(32)(1)
            lq_head[0] = Bits(32)(0)
            for _, arr in enumerate(lq_busy_array_d):
                arr[0] = Bits(1)(0)
            for i, arr in enumerate(sq_busy_array_d):
                arr[0] = sq_busy_array_d[i][0] & sq_is_committed_array_d[i][0]
            for _, arr in enumerate(sq_lsq_pos_array_d):
                arr[0] = Bits(32)(0)

        with Condition(has_entry_from_rs & (~revert_flag_cdb[0])):
            with Condition(memory_from_rs[0:0] == Bits(1)(1)):  # Load
                index = lq_pos_from_rs & Bits(32)(LSQ_SIZE - 1)
                index_trucated = index.bitcast(Bits(LSQ_SIZE_LOG))
                write_1hot(lq_busy_array_d, index, Bits(1)(1))
                addr = rs1_val_from_rs.bitcast(Int(32)) + imm_val_from_rs.bitcast(
                    Int(32)
                ) - Int(32)(DCACHE_OFFSET)
                lq_addr_array[index_trucated] = addr.bitcast(Bits(32))
                lq_rob_dest_array[index_trucated] = rob_dest_from_rs
                lq_lsq_pos_array[index_trucated] = lsq_pos_from_rs
                self.log(
                    "Append LQ Entry: index={}, addr=0x{:08x}, rob_dest=0x{:08x}, lsq_pos={}",
                    index.bitcast(UInt(32)),
                    addr.bitcast(UInt(32)),
                    rob_dest_from_rs.bitcast(UInt(32)),
                    lsq_pos_from_rs.bitcast(UInt(32)),
                )

            with Condition(memory_from_rs[1:1] == Bits(1)(1)):  # Store
                index = sq_pos_from_rs & Bits(32)(LSQ_SIZE - 1)
                index_trucated = index.bitcast(Bits(LSQ_SIZE_LOG))
                write_1hot(sq_busy_array_d, index, Bits(1)(1))
                addr = rs1_val_from_rs.bitcast(Int(32)) + imm_val_from_rs.bitcast(
                    Int(32)
                ) - Int(32)(DCACHE_OFFSET)
                sq_addr_array[index_trucated] = addr.bitcast(Bits(32))
                sq_data_array[index_trucated] = rs2_val_from_rs
                write_1hot(sq_is_committed_array_d, index, Bits(1)(0))
                write_1hot(sq_lsq_pos_array_d, index, lsq_pos_from_rs)
                self.log(
                    "Append SQ Entry: index={}, addr=0x{:08x}, data=0x{:08x}, lsq_pos={}",
                    index.bitcast(UInt(32)),
                    addr.bitcast(UInt(32)),
                    rs2_val_from_rs.bitcast(UInt(32)),
                    lsq_pos_from_rs.bitcast(UInt(32)),
                )

        # Execute head entry
        lq_head_pos = lq_head[0].bitcast(Bits(LSQ_SIZE_LOG))
        sq_head_pos = sq_head[0].bitcast(Bits(LSQ_SIZE_LOG))

        store_flag = (
            read_mux(sq_busy_array_d, sq_head[0])
            & (
                (read_mux(sq_lsq_pos_array_d, sq_head[0]) == lsq_head[0])
                | (read_mux(sq_lsq_pos_array_d, sq_head[0]) == Bits(32)(0))
            )
            & read_mux(sq_is_committed_array_d, sq_head[0])
            & ~revert_flag_cdb[0]
        )

        load_flag = (
            read_mux(lq_busy_array_d, lq_head[0])
            & (lq_lsq_pos_array[lq_head_pos] == lsq_head[0])
            & (~store_flag)
            & (~revert_flag_cdb[0])
        )
        requested_addr = load_flag.select(
            lq_addr_array[lq_head_pos][2 : 2 + depth_log - 1].bitcast(UInt(depth_log)),
            sq_addr_array[sq_head_pos][2 : 2 + depth_log - 1].bitcast(UInt(depth_log)),
        )
        out_valid_to_rob[0] = load_flag
        rob_dest_to_rob[0] = load_flag.select(
            lq_rob_dest_array[lq_head_pos], Bits(32)(0)
        )

        with Condition(load_flag | store_flag):
            self.log(
                "Execute Entry: LSQ pos={}, Load={}, Store={}",
                lsq_head[0].bitcast(UInt(32)),
                load_flag.bitcast(UInt(1)),
                store_flag.bitcast(UInt(1)),
            )

            with Condition(load_flag):
                lsq_head[0] = (lsq_head[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                )
                write_1hot(lq_busy_array_d, lq_head[0], Bits(1)(0))
                self.log(
                    "Load: LQ index={}, addr=0x{:08x}",
                    lq_head[0].bitcast(UInt(32)),
                    lq_addr_array[lq_head_pos],
                )
                lq_head[0] = (lq_head[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                ) & Bits(32)(LSQ_SIZE - 1)
                mem_addr_to_rob[0] = lq_addr_array[lq_head_pos]

            with Condition(store_flag):
                with Condition(read_mux(sq_lsq_pos_array_d, sq_head[0]) == Bits(32)(0)):

                    self.log(
                        "Store with lsq_pos=0, treating as committed already before flushing"
                    )
                with Condition(read_mux(sq_lsq_pos_array_d, sq_head[0]) != Bits(32)(0)):
                    lsq_head[0] = (lsq_head[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                        Bits(32)
                    )
                write_1hot(sq_busy_array_d, sq_head[0], Bits(1)(0))
                self.log(
                    "Store: SQ index={}, addr=0x{:08x}, data=0x{:08x}, is_committed={}",
                    sq_head[0].bitcast(UInt(32)),
                    sq_addr_array[sq_head_pos],
                    sq_data_array[sq_head_pos],
                    read_mux(sq_is_committed_array_d, sq_head[0]),
                )
                sq_head[0] = (sq_head[0].bitcast(Int(32)) + Int(32)(1)).bitcast(
                    Bits(32)
                ) & Bits(32)(LSQ_SIZE - 1)
                mem_addr_to_rob[0] = sq_addr_array[sq_head_pos]


        dcache.build(
            we=store_flag,
            re=load_flag,
            addr=requested_addr,
            wdata=sq_data_array[sq_head_pos],
        )
