from aoc.util.input import get_input
from typing import Sequence


def is_monotonic_with_bounded_diff(nums: Sequence[int]) -> bool:
    if len(nums) <= 1:
        return True

    # get direction from first pair
    diffs = [b - a for a, b in zip(nums, nums[1:])]
    first_diff = diffs[0]

    # all diffs must have same sign and be within bounds
    return all(
        0 < d <= 3
        if first_diff > 0
        else -3 <= d < 0
        if first_diff < 0
        else False  # zero diff = cringe
        for d in diffs
    )


def solve(input_data=None):
    if input_data is None:
        input_data = get_input("02")

    reports = [[int(x) for x in line.split()] for line in input_data.splitlines()]

    return sum(1 for r in reports if is_monotonic_with_bounded_diff(r))


if __name__ == "__main__":
    result = solve()
    print(f"part 1: {result}")
