from part2 import solve
from aoc.util.input import get_input


def test_example():
    example_input = get_input("02", variant="example")
    solved = solve(example_input)
    assert solved == 4
