default:
    @just --list

# Test a specific problem (usage: just test 01)
test day:
    poetry run pytest aoc/problems/{{day}}_*

# Test all problems
test-all:
    poetry run pytest aoc/problems

# Solve a specific problem (usage: just solve 01)
solve $day:
    #!/bin/bash
    problem_dir=$(find aoc/problems -type d -name "${day}_*")
    echo "Solving $problem_dir"
    poetry run python -m "aoc.problems.${problem_dir#aoc/problems/}.part1" solve
    poetry run python -m "aoc.problems.${problem_dir#aoc/problems/}.part2" solve
