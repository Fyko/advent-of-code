from part1 import solve
from aoc.util.input import get_input


def test_example():
    """test the example input straight from the file no cap"""
    example_input = get_input("01", variant="example")
    solved = solve(example_input)
    assert solved == 11
