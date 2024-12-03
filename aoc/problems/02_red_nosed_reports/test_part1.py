from part1 import solve
from aoc.util.input import get_input


def test_example():
    """test the example input straight from the file no cap"""
    example_input = get_input("02", variant="example")
    solved = solve(example_input)
    assert solved == 2


def test_custom_one():
    input = "1 3 6 7 9"
    solved = solve(input)
    assert solved == 1
