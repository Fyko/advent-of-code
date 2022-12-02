use std::str::FromStr;

use crate::{PAPER_POINTS, ROCK_POINTS, SCISSORS_POINTS};

/// A guess character
#[derive(Debug, Clone, PartialEq, Eq, Copy)]
pub enum PlayChar {
	/// If the letter is `A`
	Rock,
	/// If the letter is `B`
	Paper,
	/// If the letter is `C`
	Scissors,
}

impl FromStr for PlayChar {
	type Err = ();

	fn from_str(input: &str) -> std::result::Result<PlayChar, Self::Err> {
		match input {
			"A" => Ok(PlayChar::Rock),
			"X" => Ok(PlayChar::Rock),

			"B" => Ok(PlayChar::Paper),
			"Y" => Ok(PlayChar::Paper),

			"C" => Ok(PlayChar::Scissors),
			"Z" => Ok(PlayChar::Scissors),

			_ => Err(()),
		}
	}
}

impl PlayChar {
	/// How many points the player will receive from a specific `PlayChar`
	pub fn points(&self) -> u8 {
		match self {
			PlayChar::Rock => ROCK_POINTS,
			PlayChar::Paper => PAPER_POINTS,
			PlayChar::Scissors => SCISSORS_POINTS,
		}
	}

	/// Which `PlayChar` `self` will lose to
	pub fn loses_to(&self) -> PlayChar {
		match self {
			PlayChar::Rock => PlayChar::Paper,
			PlayChar::Paper => PlayChar::Scissors,
			PlayChar::Scissors => PlayChar::Rock,
		}
	}

	/// Which `PlayChar` `self` will defeat
	pub fn defeats(&self) -> PlayChar {
		match self {
			PlayChar::Rock => PlayChar::Scissors,
			PlayChar::Paper => PlayChar::Rock,
			PlayChar::Scissors => PlayChar::Paper,
		}
	}
}
