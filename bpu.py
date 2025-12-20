from assassyn.frontend import *


class AlwaysFalseBPU(Downstream):
    def __init__(self):
        super().__init__()
        self.name = "BPU"

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
        predicted_pc[0] = pc_addr_from_d + Bits(32)(4)

        with Condition(is_branch_from_d):
            log(
                "BPU PC=0x{:08x} PredictTaken=0",
                pc_addr_from_d,
            )

        return Bits(1)(0), pc_addr_from_d + Bits(32)(4)


class AlwaysTakenBPU(Downstream):
    def __init__(self):
        super().__init__()
        self.name = "BPU"

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
            target_pc_from_d, pc_addr_from_d + Bits(32)(4)
        )
        predicted_pc[0] = predicted_pc_addr

        with Condition(is_branch_from_d):
            log(
                "BPU PC=0x{:08x} PredictTaken=1",
                pc_addr_from_d,
            )

        return is_branch_from_d, predicted_pc_addr


class TwoBitBPU(Downstream):
    def __init__(self):
        super().__init__()
        self.name = "BPU"

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
            2 : 2 + index_bits - 1
        ]  # Use bits [2:12] of PC as index

        counter = bpu_counters[pc_index]

        branch_predict_taken = counter[1:1]
        branch_predicted_pc = branch_predict_taken.select(
            target_pc_from_d, pc_addr_from_d + Bits(32)(4)
        )

        predict_taken_flag = is_branch_from_d.select(branch_predict_taken, Bits(1)(0))
        predicted_pc_addr = is_branch_from_d.select(
            branch_predicted_pc, pc_addr_from_d + Bits(32)(4)
        )

        with Condition(is_branch_from_d):
            log(
                "BPU PC=0x{:08x} Counter={} PredictTaken={}",
                pc_addr_from_d,
                counter.bitcast(UInt(2)),
                predict_taken_flag.bitcast(UInt(1)),
            )

        predicted_pc[0] = predicted_pc_addr
        predict_taken[0] = predict_taken_flag

        with Condition(commit_branch_from_rob[0]):
            rob_pc_index = pc_addr_from_rob[0][2 : 2 + index_bits - 1]
            actual_taken_flag = actual_taken_from_rob[0]

            counter = bpu_counters[rob_pc_index]

            plus_one_flag = (counter != Bits(2)(3)) & actual_taken_flag
            minus_one_flag = (counter != Bits(2)(0)) & (~actual_taken_flag)

            new_counter = plus_one_flag.select(counter + Bits(2)(1), counter)
            new_counter = minus_one_flag.select(counter - Bits(2)(1), new_counter)

            bpu_counters[rob_pc_index] = new_counter

            log(
                "BPU Update PC=0x{:08x} OldCounter={} ActualTaken={} NewCounter={}",
                pc_addr_from_rob[0],
                counter.bitcast(UInt(2)),
                actual_taken_flag.bitcast(UInt(1)),
                new_counter.bitcast(UInt(2)),
            )

        return predict_taken_flag, predicted_pc_addr
