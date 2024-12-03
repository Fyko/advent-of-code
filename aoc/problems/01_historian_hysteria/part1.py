from aoc.util.input import get_input


def solve(input_data=None):
    if input_data is None:
        input_data = get_input("01")

    left, right = map(
        list,
        zip(
            *(
                map(int, line.split())
                for line in input_data.splitlines()
                if line.strip()
            )
        ),
    )
    left.sort()
    right.sort()

    res = 0
    for l, r in zip(left, right):
        res += abs(l - r)

    return res


if __name__ == "__main__":
    result = solve()
    print(f"part 1: {result}")
