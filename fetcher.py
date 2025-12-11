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
        updated_pc_from_d: Value,
        on_br_from_d: Value,
        icache: SRAM,
        depth_log: int,
        decoder: Decoder,
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
        updated_pc_from_d = updated_pc_from_d.optional(Bits(32)(0))
        fetch_addr = is_jal.select(
            updated_pc_from_d, pc_addr_from_f
        )
        fetch_addr = revert_flag_cdb[0].select(updated_pc_from_rob[0], fetch_addr)
        with Condition(is_jal):
            log(
                "Fetcher received JAL PC=0x{:08x}",
                updated_pc_from_d,
            )

        with Condition(revert_flag_cdb[0]):
            log(
                "Fetcher received redirect PC=0x{:08x}, is_jump={}",
                updated_pc_from_rob[0],
                is_jump_from_rob[0].bitcast(UInt(1)),
            )

        should_fetch = fetch_state[0]

        next_pc = (fetch_addr.bitcast(UInt(32)) + UInt(32)(4)).bitcast(Bits(32))

        log(
            "PC=0x{:08x}, next_PC=0x{:08x}, should_fetch={}, on_br={}",
            fetch_addr,
            next_pc,
            should_fetch.bitcast(UInt(1)),
            on_br_from_d.bitcast(UInt(1)),
        )

        fetch_state[0] = should_fetch

        pc_reg_from_f[0] = should_fetch.select(next_pc, pc_reg_from_f[0])

        icache.build(
            we=Bits(1)(0),
            re=should_fetch,
            addr=fetch_addr[2 : 2 + depth_log - 1].bitcast(Int(depth_log)),
            wdata=Bits(32)(0),
        )

        decoder.async_called(
            inst_valid_from_fi=should_fetch, fetch_pc_from_fi=fetch_addr
        )
