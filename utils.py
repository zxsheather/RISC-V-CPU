from assassyn.frontend import *


def write_1hot(arrs, idx_val, payload):
    """writes to a list of 1-deep RegArrays, similar to 1-hot gating.

    Args:
        arrs (list(Array)): RegArray list
        idx_val (Bits(32)): index
        payload (Value):
    """
    for i, arr in enumerate(arrs):
        with Condition(idx_val == Bits(32)(i)):
            arr[0] = payload


def read_mux(arrs, idx_val):
    """reads from a list of 1-deep RegArrays.

    Args:
        arrs (list(Array)): RegArray list
        idx_val (Bits(32)): index

    Note: this function is NOT SAFE against index out-of-bound
    """
    return idx_val.case({Bits(32)(i): arrs[i][0] for i, arr in enumerate(arrs)} | {None: arrs[0][0]})


class Logger:
    """
    A wrapper around the assassyn log function that allows enabling/disabling logging.
    """
    def __init__(self, enabled=True):
        self.enabled = enabled

    def __call__(self, fmt, *args):
        if self.enabled:
            log(fmt, *args)

    def set_enabled(self, enabled):
        self.enabled = enabled


def priority_select_tree(valids, indices):
    """Tree-based priority select (lower index wins).

    This builds a balanced tournament tree so the resulting combinational depth
    is O(log N) rather than a linear chain.

    Args:
        valids: list of Bits(1) (or 1-bit Values). Each entry indicates whether
            the corresponding candidate is eligible.
        indices: list of Bits(k) indices for each candidate (same length).

    Returns:
        (out_valid, out_index)
    """
    if len(valids) != len(indices):
        raise ValueError("valids and indices must have same length")
    if len(valids) == 0:
        raise ValueError("valids must be non-empty")

    def _rec(vs, is_):
        if len(vs) == 1:
            return vs[0], is_[0]

        mid = len(vs) // 2
        left_v, left_i = _rec(vs[:mid], is_[:mid])
        right_v, right_i = _rec(vs[mid:], is_[mid:])

        out_v = left_v | right_v
        out_i = left_v.select(left_i, right_i)
        return out_v, out_i

    return _rec(valids, indices)

FetcherLogEnabled = False
DecoderLogEnabled = False
ALULogEnabled = False
RSLogEnabled = False
ROBLogEnabled = False
LSQLogEnabled = False
BPULogEnabled = False
