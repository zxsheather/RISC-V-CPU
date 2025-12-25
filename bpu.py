from assassyn.frontend import *
from utils import Logger, BPULogEnabled


class AlwaysFalseBPU(Downstream):
    def __init__(self):
        super().__init__()
        self.name = "BPU"
        self.log = Logger(enabled=BPULogEnabled)

    @downstream.combinational
    def build(
        self,
        pc_addr_from_d: Value,
        target_pc_from_d: Value,
        is_branch_from_d: Value,
        predicted_pc: Array,
        predict_taken: Array,
        commit_branch_from_rob: Array,
        actual_taken_from_rob: Array,
        pc_addr_from_rob: Array,
    ):
        """
        A BPU that always predicts not taken.
        """

        predict_taken[0] = Bits(1)(0)
        predicted_pc[0] = (
            pc_addr_from_d.bitcast(Int(32)) + Bits(32)(4).bitcast(Int(32))
        ).bitcast(Bits(32))

        with Condition(is_branch_from_d):
            self.log(
                "BPU PC=0x{:08x} PredictTaken=0",
                pc_addr_from_d,
            )

        return Bits(1)(0), pc_addr_from_d + Bits(32)(4)


class AlwaysTakenBPU(Downstream):
    def __init__(self):
        super().__init__()
        self.name = "BPU"
        self.log = Logger(enabled=BPULogEnabled)

    @downstream.combinational
    def build(
        self,
        pc_addr_from_d: Value,
        target_pc_from_d: Value,
        is_branch_from_d: Value,
        predicted_pc: Array,
        predict_taken: Array,
        commit_branch_from_rob: Array,
        actual_taken_from_rob: Array,
        pc_addr_from_rob: Array,
    ):
        """
        A BPU that always predicts taken.
        """

        predict_taken[0] = is_branch_from_d
        predicted_pc_addr = is_branch_from_d.select(
            target_pc_from_d,
            (pc_addr_from_d.bitcast(Int(32)) + Bits(32)(4).bitcast(Int(32))).bitcast(
                Bits(32)
            ),
        )
        predicted_pc[0] = predicted_pc_addr

        with Condition(is_branch_from_d):
            self.log(
                "BPU PC=0x{:08x} PredictTaken=1",
                pc_addr_from_d,
            )

        return is_branch_from_d, predicted_pc_addr


class TwoBitBPU(Downstream):
    def __init__(self):
        super().__init__()
        self.name = "BPU"
        self.log = Logger(enabled=BPULogEnabled)

    @downstream.combinational
    def build(
        self,
        pc_addr_from_d: Value,
        target_pc_from_d: Value,
        is_branch_from_d: Value,
        predicted_pc: Array,
        predict_taken: Array,
        commit_branch_from_rob: Array,
        actual_taken_from_rob: Array,
        pc_addr_from_rob: Array,
    ):
        """
        A simple 2-bit saturating counter BPU.
        """

        bpu_size = 1024  # Number of entries in the BPU
        index_bits = 10  # log2(bpu_size)
        bpu_counters = RegArray(Bits(2), bpu_size)

        pc_index = pc_addr_from_d[
            2: 2 + index_bits - 1
        ]  # Use bits [2:12] of PC as index

        counter = bpu_counters[pc_index]

        branch_predict_taken = counter[1:1]
        pc_plus_4 = (pc_addr_from_d.bitcast(Int(32)) +
                     Int(32)(4)).bitcast(Bits(32))
        branch_predicted_pc = branch_predict_taken.select(
            target_pc_from_d, pc_plus_4
        )

        predict_taken_flag = is_branch_from_d.select(
            branch_predict_taken, Bits(1)(0))
        predicted_pc_addr = is_branch_from_d.select(
            branch_predicted_pc,
            pc_plus_4,
        )

        with Condition(is_branch_from_d):
            self.log(
                "BPU PC=0x{:08x} Counter={} PredictTaken={}",
                pc_addr_from_d,
                counter.bitcast(UInt(2)),
                predict_taken_flag.bitcast(UInt(1)),
            )

        predicted_pc[0] = predicted_pc_addr
        predict_taken[0] = predict_taken_flag

        with Condition(commit_branch_from_rob[0]):
            rob_pc_index = pc_addr_from_rob[0][2: 2 + index_bits - 1]
            actual_taken_flag = actual_taken_from_rob[0]

            counter = bpu_counters[rob_pc_index]

            plus_one_flag = (counter != Bits(2)(3)) & actual_taken_flag
            minus_one_flag = (counter != Bits(2)(0)) & (~actual_taken_flag)

            new_counter = plus_one_flag.select(
                (counter.bitcast(Int(2)) + Int(2)(1)).bitcast(Bits(2)), counter
            )
            new_counter = minus_one_flag.select(
                (counter.bitcast(Int(2)) - Int(2)(1)).bitcast(Bits(2)), new_counter
            )

            bpu_counters[rob_pc_index] = new_counter

            self.log(
                "BPU Update PC=0x{:08x} OldCounter={} ActualTaken={} NewCounter={}",
                pc_addr_from_rob[0],
                counter.bitcast(UInt(2)),
                actual_taken_flag.bitcast(UInt(1)),
                new_counter.bitcast(UInt(2)),
            )

        return predict_taken_flag, predicted_pc_addr


class GlobalHistoryBPU(Downstream):
    def __init__(self, size=64):
        super().__init__()
        # Require power-of-two size; default is 64 entries (6-bit history).
        if size <= 0 or (size & (size - 1)) != 0:
            raise ValueError("GlobalHistoryBPU size must be a power of two")
        self.size = size
        self.index_bits = size.bit_length() - 1
        self.mask_bits = (1 << self.index_bits) - 1
        self.name = "BPU"
        self.log = Logger(enabled=BPULogEnabled)

    @downstream.combinational
    def build(
        self,
        pc_addr_from_d: Value,
        target_pc_from_d: Value,
        is_branch_from_d: Value,
        predicted_pc: Array,
        predict_taken: Array,
        commit_branch_from_rob: Array,
        actual_taken_from_rob: Array,
        pc_addr_from_rob: Array,
    ):
        """
        Global-history predictor with a pattern history table of 2-bit counters.
        History length = log2(table_size); default table_size=64.
        """

        pht = RegArray(Bits(2), self.size)
        global_history = RegArray(Bits(self.index_bits), 1)

        hist = global_history[0]
        idx = hist
        counter = pht[idx]

        branch_predict_taken = counter[1:1]
        pc_plus_4 = (pc_addr_from_d.bitcast(Int(32)) +
                     Int(32)(4)).bitcast(Bits(32))
        branch_predicted_pc = branch_predict_taken.select(
            target_pc_from_d, pc_plus_4)

        predict_taken_flag = is_branch_from_d.select(
            branch_predict_taken, Bits(1)(0))
        predicted_pc_addr = is_branch_from_d.select(
            branch_predicted_pc, pc_plus_4)

        with Condition(is_branch_from_d):
            self.log(
                "BPU PC=0x{:08x} GHR=0x{:x} Counter={} PredictTaken={}",
                pc_addr_from_d,
                hist.bitcast(UInt(self.index_bits)),
                counter.bitcast(UInt(2)),
                predict_taken_flag.bitcast(UInt(1)),
            )

        predicted_pc[0] = predicted_pc_addr
        predict_taken[0] = predict_taken_flag

        with Condition(commit_branch_from_rob[0]):
            old_hist = global_history[0]
            old_counter = pht[old_hist]
            actual_taken_flag = actual_taken_from_rob[0]

            plus_one_flag = (old_counter != Bits(2)(3)) & actual_taken_flag
            minus_one_flag = (old_counter != Bits(2)(0)) & (~actual_taken_flag)

            new_counter = plus_one_flag.select(
                (old_counter.bitcast(Int(2)) + Int(2)(1)).bitcast(Bits(2)),
                old_counter,
            )
            new_counter = minus_one_flag.select(
                (old_counter.bitcast(Int(2)) - Int(2)(1)).bitcast(Bits(2)),
                new_counter,
            )
            pht[old_hist] = new_counter

            hist_u = old_hist.bitcast(UInt(self.index_bits))
            shifted = ((hist_u << UInt(self.index_bits)(1)) | actual_taken_flag.bitcast(
                UInt(self.index_bits)
            ))
            new_hist = ((shifted & Bits(self.index_bits)(self.mask_bits).bitcast(
                UInt(self.index_bits)
            )).bitcast(Bits(self.index_bits)))
            global_history[0] = new_hist

            self.log(
                "BPU Update PC=0x{:08x} OldGHR=0x{:x} OldCounter={} ActualTaken={} NewCounter={} NewGHR=0x{:x}",
                pc_addr_from_rob[0],
                old_hist.bitcast(UInt(self.index_bits)),
                old_counter.bitcast(UInt(2)),
                actual_taken_flag.bitcast(UInt(1)),
                new_counter.bitcast(UInt(2)),
                new_hist.bitcast(UInt(self.index_bits)),
            )

        return predict_taken_flag, predicted_pc_addr


class TournamentBPU(Downstream):
    def __init__(self, local_bits=10, global_size=64, chooser_bits=10):
        super().__init__()
        if global_size <= 0 or (global_size & (global_size - 1)) != 0:
            raise ValueError("global_size must be a power of two")
        self.local_bits = local_bits
        self.chooser_bits = chooser_bits
        self.global_size = global_size
        self.global_bits = global_size.bit_length() - 1
        self.global_mask = (1 << self.global_bits) - 1
        self.name = "BPU"
        self.log = Logger(enabled=BPULogEnabled)

    @downstream.combinational
    def build(
        self,
        pc_addr_from_d: Value,
        target_pc_from_d: Value,
        is_branch_from_d: Value,
        predicted_pc: Array,
        predict_taken: Array,
        commit_branch_from_rob: Array,
        actual_taken_from_rob: Array,
        pc_addr_from_rob: Array,
    ):
        """
        Tournament predictor: local vs. global,
        chooser table decides which prediction to use.
        """
        local_pht = RegArray(Bits(2), 1 << self.local_bits)
        global_pht = RegArray(Bits(2), self.global_size)
        chooser = RegArray(Bits(2), 1 << self.chooser_bits)
        global_history = RegArray(Bits(self.global_bits), 1)

        pc_plus_4 = (pc_addr_from_d.bitcast(Int(32)) +
                     Int(32)(4)).bitcast(Bits(32))

        local_idx = pc_addr_from_d[2: 2 + self.local_bits - 1]
        local_ctr = local_pht[local_idx]
        local_taken = local_ctr[1:1]
        local_pc_pred = local_taken.select(target_pc_from_d, pc_plus_4)

        ghr = global_history[0]
        global_ctr = global_pht[ghr]
        global_taken = global_ctr[1:1]
        global_pc_pred = global_taken.select(target_pc_from_d, pc_plus_4)

        chooser_idx = pc_addr_from_d[2: 2 + self.chooser_bits - 1]
        chooser_ctr = chooser[chooser_idx]
        use_global = chooser_ctr[1:1]

        predict_taken_flag = is_branch_from_d.select(
            use_global.select(global_taken, local_taken), Bits(1)(0)
        )
        predicted_pc_addr = is_branch_from_d.select(
            use_global.select(global_pc_pred, local_pc_pred),
            pc_plus_4,
        )

        with Condition(is_branch_from_d):
            self.log(
                "BPU PC=0x{:08x} chooser={} use_global={} local_ctr={} global_ctr={} predict_taken={}",
                pc_addr_from_d,
                chooser_ctr.bitcast(UInt(2)),
                use_global.bitcast(UInt(1)),
                local_ctr.bitcast(UInt(2)),
                global_ctr.bitcast(UInt(2)),
                predict_taken_flag.bitcast(UInt(1)),
            )

        predicted_pc[0] = predicted_pc_addr
        predict_taken[0] = predict_taken_flag

        with Condition(commit_branch_from_rob[0]):
            actual_taken_flag = actual_taken_from_rob[0]

            local_idx_c = pc_addr_from_rob[0][2: 2 + self.local_bits - 1]
            chooser_idx_c = pc_addr_from_rob[0][2: 2 + self.chooser_bits - 1]

            local_ctr_old = local_pht[local_idx_c]
            plus_local = (local_ctr_old != Bits(2)(3)) & actual_taken_flag
            minus_local = (local_ctr_old != Bits(2)(0)) & (~actual_taken_flag)
            local_ctr_new = plus_local.select(
                (local_ctr_old.bitcast(Int(2)) + Int(2)(1)).bitcast(Bits(2)),
                local_ctr_old,
            )
            local_ctr_new = minus_local.select(
                (local_ctr_old.bitcast(Int(2)) - Int(2)(1)).bitcast(Bits(2)),
                local_ctr_new,
            )
            local_pht[local_idx_c] = local_ctr_new

            ghr_old = global_history[0]
            global_ctr_old = global_pht[ghr_old]
            plus_global = (global_ctr_old != Bits(2)(3)) & actual_taken_flag
            minus_global = (global_ctr_old != Bits(2)
                            (0)) & (~actual_taken_flag)
            global_ctr_new = plus_global.select(
                (global_ctr_old.bitcast(Int(2)) + Int(2)(1)).bitcast(Bits(2)),
                global_ctr_old,
            )
            global_ctr_new = minus_global.select(
                (global_ctr_old.bitcast(Int(2)) - Int(2)(1)).bitcast(Bits(2)),
                global_ctr_new,
            )
            global_pht[ghr_old] = global_ctr_new

            local_correct = (local_ctr_old[1:1] == actual_taken_flag)
            global_correct = (global_ctr_old[1:1] == actual_taken_flag)
            chooser_ctr_old = chooser[chooser_idx_c]
            inc_chooser = global_correct & (~local_correct) & (
                chooser_ctr_old != Bits(2)(3))
            dec_chooser = local_correct & (~global_correct) & (
                chooser_ctr_old != Bits(2)(0))
            chooser_ctr_new = inc_chooser.select(
                (chooser_ctr_old.bitcast(Int(2)) + Int(2)(1)).bitcast(Bits(2)),
                chooser_ctr_old,
            )
            chooser_ctr_new = dec_chooser.select(
                (chooser_ctr_old.bitcast(Int(2)) - Int(2)(1)).bitcast(Bits(2)),
                chooser_ctr_new,
            )
            chooser[chooser_idx_c] = chooser_ctr_new

            ghr_u = ghr_old.bitcast(UInt(self.global_bits))
            shifted = (ghr_u << UInt(self.global_bits)(1)) | actual_taken_flag.bitcast(
                UInt(self.global_bits)
            )
            masked = shifted & Bits(self.global_bits)(self.global_mask).bitcast(
                UInt(self.global_bits)
            )
            ghr_new = masked.bitcast(Bits(self.global_bits))
            global_history[0] = ghr_new

            self.log(
                "BPU Update PC=0x{:08x} local_ctr {}->{} global_ctr {}->{} chooser {}->{} ghr {}->{} outcome={}",
                pc_addr_from_rob[0],
                local_ctr_old.bitcast(UInt(2)),
                local_ctr_new.bitcast(UInt(2)),
                global_ctr_old.bitcast(UInt(2)),
                global_ctr_new.bitcast(UInt(2)),
                chooser_ctr_old.bitcast(UInt(2)),
                chooser_ctr_new.bitcast(UInt(2)),
                ghr_old.bitcast(UInt(self.global_bits)),
                ghr_new,
                actual_taken_flag.bitcast(UInt(1)),
            )

        return predict_taken_flag, predicted_pc_addr


class TageBPU(Downstream):
    def __init__(
        self,
        base_size=256,
        tag_sizes=(64, 64, 64),
        hist_lens=(4, 12, 24),
        tag_bits=8,
        ghr_bits=32,
        meta_idx_bits=8,
    ):
        super().__init__()
        if base_size <= 0 or (base_size & (base_size - 1)) != 0:
            raise ValueError("base_size must be a power of two")
        if len(tag_sizes) != len(hist_lens):
            raise ValueError("tag_sizes and hist_lens must match")
        for sz in tag_sizes:
            if sz <= 0 or (sz & (sz - 1)) != 0:
                raise ValueError("tag_sizes must be powers of two")
        self.base_size = base_size
        self.base_idx_bits = base_size.bit_length() - 1
        self.tag_sizes = list(tag_sizes)
        self.hist_lens = list(hist_lens)
        self.tag_bits = tag_bits
        self.ghr_bits = ghr_bits
        self.idx_bits = [sz.bit_length() - 1 for sz in tag_sizes]
        self.max_idx_bits = max(self.idx_bits) if self.idx_bits else 0
        self.num_banks = len(tag_sizes)
        self.meta_idx_bits = max(meta_idx_bits, self.base_idx_bits)
        self.name = "BPU"
        self.log = Logger(enabled=BPULogEnabled)
        # meta layout: provider_pred(1) | alt_pred(1) | provider_bank(2) | alt_bank(2)
        # | base_idx | idx[bank]*max_idx_bits | tag[bank]*tag_bits
        self.meta_width = (
            1
            + 1
            + 2
            + 2
            + self.base_idx_bits
            + self.num_banks * self.max_idx_bits
            + self.num_banks * self.tag_bits
        )

    def _fold(self, value_u: Value, width: int):
        if width <= 0:
            return Bits(1)(0)
        mask = (1 << width) - 1
        acc = value_u & UInt(self.ghr_bits)(mask)
        shift = width
        while shift < self.ghr_bits:
            acc = acc ^ ((value_u >> UInt(self.ghr_bits)(shift))
                         & UInt(self.ghr_bits)(mask))
            shift += width
        return Bits(width)(acc.bitcast(UInt(width)))

    def _pack_entry(self, tag: Value, ctr: Value, u: Value):
        total = self.tag_bits + 3 + 1
        assembled = (
            (tag.bitcast(UInt(total)) << UInt(total)(4))
            | (ctr.bitcast(UInt(total)) << UInt(total)(1))
            | u.bitcast(UInt(total))
        )
        return Bits(total)(assembled)

    def _entry_fields(self, entry: Value):
        u = entry[0:0]
        ctr = entry[1:3]
        tag = entry[4:4 + self.tag_bits - 1]
        return tag, ctr, u

    @downstream.combinational
    def build(
        self,
        pc_addr_from_d: Value,
        target_pc_from_d: Value,
        is_branch_from_d: Value,
        predicted_pc: Array,
        predict_taken: Array,
        commit_branch_from_rob: Array,
        actual_taken_from_rob: Array,
        pc_addr_from_rob: Array,
    ):
        """
        TAGE-style predictor with one base table and multiple tagged banks.
        Predict path is combinational; updates happen when ROB commits a branch.
        """
        base_table = RegArray(Bits(2), self.base_size)
        tagged_tables = [
            RegArray(Bits(self.tag_bits + 3 + 1), sz) for sz in self.tag_sizes
        ]
        ghr = RegArray(Bits(self.ghr_bits), 1)
        meta = RegArray(Bits(self.meta_width), 1 << self.meta_idx_bits)

        pc_plus_4 = (pc_addr_from_d.bitcast(Int(32)) +
                     Int(32)(4)).bitcast(Bits(32))

        # calculate unique index and tag for each bank
        ghr_val = ghr[0].bitcast(UInt(self.ghr_bits))
        base_idx = pc_addr_from_d[2: 2 + self.base_idx_bits - 1]
        idxs = []
        tags = []
        for hist_len, idx_bits in zip(self.hist_lens, self.idx_bits):
            idx_mask = (1 << idx_bits) - 1
            tag_mask = (1 << self.tag_bits) - 1
            folded_idx = self._fold(ghr_val, idx_bits)
            folded_tag = self._fold(ghr_val, self.tag_bits)
            pc_idx = pc_addr_from_d[2: 2 + idx_bits - 1]
            pc_tag = pc_addr_from_d[2: 2 + self.tag_bits - 1]
            idxs.append((folded_idx ^ pc_idx) & Bits(idx_bits)(idx_mask))
            tags.append((folded_tag ^ pc_tag) & Bits(self.tag_bits)(tag_mask))

        # base_ctr is the state of base bank, parsed holds the ctr of each tagged bank, then divide info into lists
        base_ctr = base_table[base_idx]
        entries = [tbl[idxs[i]] for i, tbl in enumerate(tagged_tables)]
        parsed = [self._entry_fields(e) for e in entries]
        matches = []
        ctrs = []
        us = []
        for i, (tag_rd, ctr_rd, u_rd) in enumerate(parsed):
            matches.append(tag_rd == tags[i])
            ctrs.append(ctr_rd)
            us.append(u_rd)

        # previder: 1st choice, alt: 2nd choice
        provider_bank = Bits(2)(0)
        provider_ctr = base_ctr
        provider_idx = base_idx
        provider_tag = Bits(self.tag_bits)(0)
        provider_pred = base_ctr[1:1]

        alt_bank = Bits(2)(0)
        alt_pred = base_ctr[1:1]

        # the alt is chosen after provider is chosen so it's second best
        for bank_id in reversed(range(self.num_banks)):
            choose_provider = matches[bank_id] & (provider_bank == Bits(2)(0))
            provider_bank = choose_provider.select(
                Bits(2)(bank_id + 1), provider_bank)
            provider_ctr = choose_provider.select(ctrs[bank_id], provider_ctr)
            provider_idx = choose_provider.select(idxs[bank_id], provider_idx)
            provider_tag = choose_provider.select(tags[bank_id], provider_tag)
            provider_pred = choose_provider.select(
                ctrs[bank_id][2:2], provider_pred)
            choose_alt = matches[bank_id] & (
                alt_bank == Bits(2)(0)) & (~choose_provider)
            alt_bank = choose_alt.select(Bits(2)(bank_id + 1), alt_bank)
            alt_pred = choose_alt.select(ctrs[bank_id][2:2], alt_pred)

        final_pred_taken = provider_pred
        predicted_pc_addr = final_pred_taken.select(
            target_pc_from_d, pc_plus_4)

        predicted_pc[0] = is_branch_from_d.select(predicted_pc_addr, pc_plus_4)
        predict_taken[0] = is_branch_from_d.select(
            final_pred_taken, Bits(1)(0))

        # Pack meta per PC bucket (LSB-first packing)
        meta_idx = pc_addr_from_d[2: 2 + self.meta_idx_bits - 1]
        idx_pad = []
        for idx_val in idxs:
            idx_pad.append(
                Bits(self.max_idx_bits)(
                    idx_val.bitcast(UInt(self.max_idx_bits))
                )
            )
        while len(idx_pad) < self.num_banks:
            idx_pad.append(Bits(self.max_idx_bits)(0))
        tag_pad = tags + [Bits(self.tag_bits)(0)] * \
            (self.num_banks - len(tags))

        acc = Bits(self.meta_width)(0)
        off = 0

        def insert(val: Value, width: int):
            nonlocal acc, off
            acc_u = acc.bitcast(UInt(self.meta_width))
            acc = Bits(self.meta_width)(
                acc_u
                | (val.bitcast(UInt(self.meta_width)) << UInt(self.meta_width)(off))
            )
            off += width

        insert(provider_pred, 1)
        insert(alt_pred, 1)
        insert(provider_bank, 2)
        insert(alt_bank, 2)
        insert(base_idx, self.base_idx_bits)
        for idx_val in idx_pad:
            insert(idx_val, self.max_idx_bits)
        for tag_val in tag_pad:
            insert(tag_val, self.tag_bits)

        meta[meta_idx] = acc

        with Condition(commit_branch_from_rob[0]):
            actual_taken_flag = actual_taken_from_rob[0]
            rob_pc = pc_addr_from_rob[0]
            meta_idx_c = rob_pc[2: 2 + self.meta_idx_bits - 1]
            meta_rd = meta[meta_idx_c].bitcast(UInt(self.meta_width))

            def extract(width: int, shift: int):
                return Bits(width)(
                    (meta_rd >> UInt(self.meta_width)(shift))
                    & UInt(self.meta_width)((1 << width) - 1)
                )

            off_r = 0
            provider_pred_m = extract(1, off_r)
            off_r += 1
            alt_pred_m = extract(1, off_r)
            off_r += 1
            provider_bank_m = extract(2, off_r)
            off_r += 2
            alt_bank_m = extract(2, off_r)
            off_r += 2
            base_idx_m = extract(self.base_idx_bits, off_r)
            off_r += self.base_idx_bits
            idx_list = []
            for _ in range(self.num_banks):
                idx_list.append(extract(self.max_idx_bits, off_r))
                off_r += self.max_idx_bits
            tag_list = []
            for _ in range(self.num_banks):
                tag_list.append(extract(self.tag_bits, off_r))
                off_r += self.tag_bits

            # Base counter update
            old_base_ctr = base_table[base_idx_m]
            plus_base = (old_base_ctr != Bits(2)(3)) & actual_taken_flag
            minus_base = (old_base_ctr != Bits(2)(0)) & (~actual_taken_flag)
            new_base_ctr = plus_base.select(
                (old_base_ctr.bitcast(Int(2)) + Int(2)(1)).bitcast(Bits(2)),
                old_base_ctr,
            )
            new_base_ctr = minus_base.select(
                (old_base_ctr.bitcast(Int(2)) - Int(2)(1)).bitcast(Bits(2)),
                new_base_ctr,
            )
            base_table[base_idx_m] = new_base_ctr

            provider_correct = provider_pred_m == actual_taken_flag
            alt_correct = alt_pred_m == actual_taken_flag

            # Update provider tagged bank (if any)
            for bank_id in range(self.num_banks):
                with Condition(provider_bank_m == Bits(2)(bank_id + 1)):
                    idx_full = idx_list[bank_id]
                    idx_narrow = idx_full[0: self.idx_bits[bank_id] - 1]
                    tag_val = tag_list[bank_id]
                    entry = tagged_tables[bank_id][idx_narrow]
                    tag_rd, ctr_rd, u_rd = self._entry_fields(entry)
                    with Condition(tag_rd == tag_val):
                        plus_c = (ctr_rd != Bits(3)(7)) & actual_taken_flag
                        minus_c = (ctr_rd != Bits(3)(0)) & (~actual_taken_flag)
                        new_ctr = plus_c.select(
                            (ctr_rd.bitcast(Int(3)) + Int(3)(1)).bitcast(Bits(3)),
                            ctr_rd,
                        )
                        new_ctr = minus_c.select(
                            (ctr_rd.bitcast(Int(3)) - Int(3)(1)).bitcast(Bits(3)),
                            new_ctr,
                        )
                        new_u = u_rd
                        with Condition(provider_correct & (~alt_correct)):
                            new_u = Bits(1)(1)
                        with Condition((~provider_correct) & alt_correct & (u_rd != Bits(1)(0))):
                            new_u = (u_rd.bitcast(Int(1)) -
                                     Int(1)(1)).bitcast(Bits(1))
                        tagged_tables[bank_id][idx_narrow] = self._pack_entry(
                            tag_rd, new_ctr, new_u)

            # Allocation on mispredict, priority longest -> shortest
            alloc_mask = Bits(1)(1)
            for bank_id in reversed(range(self.num_banks)):
                cond_alloc = (provider_correct == Bits(1)(0)) & alloc_mask & (
                    Bits(2)(bank_id + 1) > provider_bank_m)
                with Condition(cond_alloc):
                    idx_full = idx_list[bank_id]
                    idx_narrow = idx_full[0: self.idx_bits[bank_id] - 1]
                    tag_val = tag_list[bank_id]
                    entry = tagged_tables[bank_id][idx_narrow]
                    tag_rd, ctr_rd, u_rd = self._entry_fields(entry)
                    with Condition(u_rd == Bits(1)(0)):
                        weak_ctr = actual_taken_flag.select(
                            Bits(3)(4), Bits(3)(3))
                        tagged_tables[bank_id][idx_narrow] = self._pack_entry(
                            tag_val, weak_ctr, Bits(1)(0))
                    with Condition(u_rd != Bits(1)(0)):
                        tagged_tables[bank_id][idx_narrow] = self._pack_entry(
                            tag_rd,
                            ctr_rd,
                            (u_rd.bitcast(Int(1)) - Int(1)(1)).bitcast(Bits(1)),
                        )
                alloc_mask = alloc_mask & (~cond_alloc)

            # GHR update
            ghr_old = ghr[0].bitcast(UInt(self.ghr_bits))
            ghr_shifted = (ghr_old << UInt(self.ghr_bits)(
                1)) | actual_taken_flag.bitcast(UInt(self.ghr_bits))
            ghr_mask = (1 << self.ghr_bits) - 1
            ghr_new = Bits(self.ghr_bits)(
                ghr_shifted & UInt(self.ghr_bits)(ghr_mask))
            ghr[0] = ghr_new

            self.log(
                "TAGE Update PC=0x{:08x} provider_bank={} provider_correct={} alt_correct={} new_ghr=0x{:x}",
                rob_pc,
                provider_bank_m.bitcast(UInt(2)),
                provider_correct.bitcast(UInt(1)),
                alt_correct.bitcast(UInt(1)),
                ghr_new.bitcast(UInt(self.ghr_bits)),
            )

        return predict_taken[0], predicted_pc[0]
