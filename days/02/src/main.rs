mod util;

use crate::util::{game::Game, outcome::OutcomeChar, play::PlayChar};
use std::str::FromStr;

pub const ROCK_POINTS: u8 = 1;
pub const PAPER_POINTS: u8 = 2;
pub const SCISSORS_POINTS: u8 = 3;

pub const LOST_POINTS: u8 = 0;
pub const DRAW_POINTS: u8 = 3;
pub const WIN_POINTS: u8 = 6;

fn main() -> anyhow::Result<()> {
	match part_one() {
		Ok(res) => println!("Day 02, part 1: {:#?}", res),
		Err(e) => panic!("Day 02, part 1 paniced: {}", e),
	}

	match part_two() {
		Ok(res) => println!("Day 02, part 2: {:#?}", res),
		Err(e) => panic!("Day 02, part 2 paniced: {}", e),
	}

	Ok(())
}

// Calculate final human score
pub fn part_one() -> anyhow::Result<u32> {
	/// Parse the input lines into Games
	fn parse() -> anyhow::Result<Vec<Game>> {
		let data = include_str!("./input.txt");

		let matches: Vec<Game> = data
			.clone()
			.lines()
			.map(|line| {
				let parts: Vec<PlayChar> = line
					.split(" ")
					.map(|x| PlayChar::from_str(x).expect("Failed to parse char into PlayChar"))
					.collect();

				Game::from_plays(parts[0], parts[1])
			})
			.collect();

		Ok(matches)
	}

	if let Ok(matches) = parse() {
		let sum = matches
			.iter()
			.fold(0 as u32, |acc, x| acc + x.human_score as u32);

		return Ok(sum);
	}

	Err(anyhow::anyhow!("Failed to parse each elves calories"))
}

// Calculate final human score (clarified data format)
pub fn part_two() -> anyhow::Result<u32> {
	/// Parse the input lines into Games
	fn parse() -> anyhow::Result<Vec<Game>> {
		let data = include_str!("./input.txt");

		let matches: Vec<Game> = data
			.lines()
			.map(|line| {
				let parts: Vec<&str> = line.split(" ").collect();

				Game::from_outcome(
					PlayChar::from_str(parts[0]).expect("Failed to parse into Play"),
					OutcomeChar::from_str(parts[1]).expect("Failed to parse into Outcome"),
				)
			})
			.collect();

		Ok(matches)
	}

	if let Ok(matches) = parse() {
		let sum = matches
			.iter()
			.fold(0 as u32, |acc, x| acc + x.human_score as u32);

		return Ok(sum);
	}

	Err(anyhow::anyhow!("Failed to parse each elves calories"))
}
