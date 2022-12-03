use anyhow::Result;

fn main() -> Result<()> {
	match part_one() {
		Ok(res) => println!("Day 03, part 1: {:#?}", res),
		Err(e) => panic!("Day 01, part 1 panicked: {}", e),
	}

	match part_two() {
		Ok(res) => println!("Day 03, part 2: {:#?}", res),
		Err(e) => panic!("Day 03, part 2 panicked: {}", e),
	}

	Ok(())
}

fn part_one() -> Result<usize> {
	let data = include_str!("./input.txt");

	let priority = data
		.lines()
		.map(|line| {
			line.split_at(line.chars().count() / 2)
		})
		.map(|parts| find_common_char(&vec![parts.0, parts.1]))
		.map(char_to_priority)
		.sum();

	Ok(priority)
}

fn part_two() -> Result<usize> {
	let data = include_str!("./input.txt");
	let lines = data.lines().collect::<Vec<&str>>();

	Ok(lines
		.chunks(3)
		.map(find_common_char)
		.map(char_to_priority)
		.sum())
}

fn find_common_char(data: &[&str]) -> char {
	let mut common_char: char = 'x';
	for letter in data[0].chars() {
		let every = data.iter().all(|x| x.contains(letter));
		if every {
			common_char = letter;
			break;
		}
	}

	common_char
}

fn char_to_priority(letter: char) -> usize {
	match letter {
		'a' => 1,
		'b' => 2,
		'c' => 3,
		'd' => 4,
		'e' => 5,
		'f' => 6,
		'g' => 7,
		'h' => 8,
		'i' => 9,
		'j' => 10,
		'k' => 11,
		'l' => 12,
		'm' => 13,
		'n' => 14,
		'o' => 15,
		'p' => 16,
		'q' => 17,
		'r' => 18,
		's' => 19,
		't' => 20,
		'u' => 21,
		'v' => 22,
		'w' => 23,
		'x' => 24,
		'y' => 25,
		'z' => 26,
		'A' => 27,
		'B' => 28,
		'C' => 29,
		'D' => 30,
		'E' => 31,
		'F' => 32,
		'G' => 33,
		'H' => 34,
		'I' => 35,
		'J' => 36,
		'K' => 37,
		'L' => 38,
		'M' => 39,
		'N' => 40,
		'O' => 41,
		'P' => 42,
		'Q' => 43,
		'R' => 44,
		'S' => 45,
		'T' => 46,
		'U' => 47,
		'V' => 48,
		'W' => 49,
		'X' => 50,
		'Y' => 51,
		'Z' => 52,
		_ => 0,
	}
}
