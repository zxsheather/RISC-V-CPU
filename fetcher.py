from assassyn.frontend import *

from decoder import Decoder


class Fetcher(Module):
    def __init__(self):
        super().__init__(ports={})

    @module.combinational
    def build(self):
        pc_reg_to_fi = RegArray(Bits(32), 1)
        pc_addr_to_fi = pc_reg_to_fi[0]

        return pc_reg_to_fi, pc_addr_to_fi


class FetcherImpl(Downstream):
    def __init__(self):
        super().__init__()
        self.name = "FI"

    @downstream.combinational
    def build(
        self,
        pc_reg_from_f: Array,
        pc_addr_from_f: Value,
        is_jal_from_d: Value,
        is_branch_from_d: Value,
        target_pc_from_d: Value,
        predict_taken_from_bpu: Value,
        predicted_pc_from_bpu: Value,
        icache: SRAM,
        depth_log: int,
        decoder: Decoder,
        continue_flag_from_rs: Array,
        in_valid_from_rob: Array,
        updated_pc_from_rob: Array,
        is_jump_from_rob: Array,
        revert_flag_cdb: Array,
    ):
        """
        Currently when facing branch, we just continue fetching sequentially.
        If mispredicted, ROB will redirect the PC later. And other modules
        will handle the flush.
        Thus here 'on_br_from_d', 'is_jump_from_rob', 'should_fetch' is not
        used, but reserved for future improvement.
        """
        fetch_state = RegArray(Bits(1), 1, initializer=[1])
        is_jal = is_jal_from_d.optional(Bits(1)(0))
        is_branch = is_branch_from_d.optional(Bits(1)(0))
        jump = predict_taken_from_bpu.optional(Bits(1)(0))
        updated_pc_from_bpu = predicted_pc_from_bpu.optional(Bits(32)(0))
        target_pc_from_d = target_pc_from_d.optional(Bits(32)(0))
        fetch_addr = is_jal.select(target_pc_from_d, pc_addr_from_f)
        fetch_addr = (is_branch & jump).select(updated_pc_from_bpu, fetch_addr)
        fetch_addr = revert_flag_cdb[0].select(updated_pc_from_rob[0], fetch_addr)
        with Condition(is_jal):
            log(
                "Fetcher received JAL PC=0x{:08x}",
                target_pc_from_d,
            )

        with Condition(is_branch & jump):
            log(
                "Fetcher received BRANCH taken PC=0x{:08x}",
                updated_pc_from_bpu,
            )

        with Condition(revert_flag_cdb[0]):
            log(
                "Fetcher received redirect PC=0x{:08x}",
                updated_pc_from_rob[0],
            )

        should_fetch = continue_flag_from_rs[0]
        with Condition(~should_fetch):
            log("Fetcher is stalled this cycle")

        next_pc = should_fetch.select(
            fetch_addr.bitcast(UInt(32)) + UInt(32)(4), fetch_addr.bitcast(UInt(32))
        ).bitcast(Bits(32))

        log(
            "PC=0x{:08x}, next_PC=0x{:08x}, should_fetch={}, on_br={}",
            fetch_addr,
            next_pc,
            should_fetch.bitcast(UInt(1)),
            is_branch.bitcast(UInt(1)),
        )

        fetch_state[0] = should_fetch

        pc_reg_from_f[0] = next_pc

        icache.build(
            we=Bits(1)(0),
            re=should_fetch,
            addr=fetch_addr[2 : 2 + depth_log - 1].bitcast(Int(depth_log)),
            wdata=Bits(32)(0),
        )

        decoder.async_called(
            inst_valid_from_fi=should_fetch, fetch_pc_from_fi=fetch_addr
        )
