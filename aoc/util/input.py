from pathlib import Path
from typing import Literal


def get_input(day: str, variant: Literal["input", "example"] = "input") -> str:
    """gets your input and it SLAPS"""
    root = Path(__file__).parent.parent
    problem_dirs = list((root / "problems").glob(f"{day}_*"))
    if not problem_dirs:
        raise ValueError(f"bestie where's the problem dir for day {day}?")

    input_path = problem_dirs[0] / f"{variant}.txt"
    if not input_path.exists():
        raise FileNotFoundError(f"{variant}.txt is ghosting us in {problem_dirs[0]}")

    return input_path.read_text().strip()
