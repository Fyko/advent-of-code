from aoc.util.input import get_input
from typing import Sequence
from .part1 import is_monotonic_with_bounded_diff


def is_safe_with_pop(nums: Sequence[int], index_to_pop: int | None = None) -> bool:
    """tests if sequence is valid after optionally popping an index"""
    if index_to_pop is not None:
        # create new list without the popped element
        nums = [x for i, x in enumerate(nums) if i != index_to_pop]

    return is_monotonic_with_bounded_diff(nums)


def solve(input_data=None):
    if input_data is None:
        input_data = get_input("02")

    reports = [[int(x) for x in line.split()] for line in input_data.splitlines()]

    return sum(
        is_safe_with_pop(report)
        or any(is_safe_with_pop(report, i) for i in range(len(report)))
        for report in reports
    )


if __name__ == "__main__":
    result = solve()
    print(f"part 2: {result}")
