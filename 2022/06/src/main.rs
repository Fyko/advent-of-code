use std::collections::HashSet;

const DATA: &str = include_str!("./input.txt");

fn main() {
	println!("Day 06, part 1: {}", find_packet_start(DATA, 4));
	println!("Day 06, part 2: {}", find_packet_start(DATA, 14));
}

fn find_packet_start(data: &str, size: usize) -> usize {
	let chars = data.chars().collect::<Vec<char>>();
	let found = chars
		.windows(size)
		.enumerate()
		.find(|(_, xs)| {
			let filtered: HashSet<_> = xs.iter().collect();
			filtered.len() >= size
		})
		.unwrap();

	found.0 + size
}
