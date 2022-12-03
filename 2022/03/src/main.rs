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

fn part_one() -> Result<u32> {
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

fn part_two() -> Result<u32> {
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

fn char_to_priority(letter: char) -> u32 {
	match letter {
		'A'..='Z' => 27 + (letter as u32) - ('A' as u32),
		'a'..='z' => 1 + (letter as u32) - ('a' as u32),
		_ => unreachable!("uhh..")
	}
}
