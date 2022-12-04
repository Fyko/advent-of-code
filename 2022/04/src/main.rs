use anyhow::Result;

fn main() -> Result<()> {
	match part_one() {
		Ok(res) => println!("Day 04, part 1: {:#?}", res),
		Err(e) => panic!("Day 04, part 1 panicked: {}", e),
	}

	match part_two() {
		Ok(res) => println!("Day 04, part 2: {:#?}", res),
		Err(e) => panic!("Day 04, part 2 panicked: {}", e),
	}

	Ok(())
}

fn part_one() -> Result<u32> {
	let data = parse_input()?;

	let mut overlapping = 0;

	for pair in data.iter() {
		if pair.a.contains(pair.b) || pair.b.contains(pair.a) {
			overlapping += 1;
		}
	}

	Ok(overlapping)
}

fn part_two() -> Result<u32> {
	let data = parse_input()?;

	let mut overlapping = 0;

	for pair in data.iter() {
		if pair.a.overlaps(pair.b) {
			overlapping += 1;
		}
	}

	Ok(overlapping)
}

#[derive(Debug, Clone, Copy)]
struct Range {
	to: u32,
	from: u32,
}

impl Range {
	fn contains<T>(self, other: T) -> bool
	where
		T: Into<Self>,
	{
		let other = other.into();
		other.to >= self.to && other.from <= self.from
	}

	/// Determine if they overlap AT ALL
	fn overlaps(self, other: Self) -> bool {
		self.contains(other.to)
			|| self.contains(other.from)
			|| other.contains(self.to)
			|| other.contains(self.from)
	}
}

impl From<u32> for Range {
	fn from(n: u32) -> Self {
		Self { to: n, from: n }
	}
}

impl From<Vec<u32>> for Range {
	fn from(v: Vec<u32>) -> Self {
		Self {
			to: v[0],
			from: v[1],
		}
	}
}

#[derive(Debug, Clone)]
struct Pair {
	a: Range,
	b: Range,
}

fn parse_input() -> Result<Vec<Pair>> {
	let input = include_str!("input.txt");
	let lines: Vec<Pair> = input
		.lines()
		.map(|l| l.split_once(","))
		.map(|xs| {
			let (a, b) = xs.unwrap();
			fn parse(s: &str) -> Range {
				s.split('-')
					.map(|n| n.parse::<u32>().unwrap())
					.collect::<Vec<_>>()
					.into()
			}

			Pair {
				a: parse(a),
				b: parse(b),
			}
		})
		.collect();

	Ok(lines)
}
