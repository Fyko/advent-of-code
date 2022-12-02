use std::str::FromStr;

/// The goal outcome
#[derive(Debug, Clone, PartialEq, Eq, Copy)]
pub enum OutcomeChar {
	/// If the letter is `X`
	Lose,
	/// If the letter is `Y`
	Draw,
	/// If the letter is `Z`
	Win,
}

impl FromStr for OutcomeChar {
	type Err = ();

	fn from_str(input: &str) -> std::result::Result<OutcomeChar, Self::Err> {
		match input {
			"X" => Ok(OutcomeChar::Lose),
			"Y" => Ok(OutcomeChar::Draw),
			"Z" => Ok(OutcomeChar::Win),
			_ => Err(()),
		}
	}
}
