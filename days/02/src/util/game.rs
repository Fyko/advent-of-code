use crate::{DRAW_POINTS, WIN_POINTS, LOST_POINTS};

use super::{play::PlayChar, outcome::OutcomeChar};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Game {
    pub human_play: PlayChar,
    pub elf_play: PlayChar,

    pub human_score: u8,
    pub outcome: Option<OutcomeChar>,
}

impl Game {
    // For the part1 input 'assumption'
    pub fn from_plays(elf_play: PlayChar, human_play: PlayChar) ->  Self {
        let human_score = Game::calculate_score(human_play, elf_play);

        Game {
            human_play,
            elf_play,
            human_score,
            outcome: None,
        }
    }

    // For the part2 input clarification
    pub fn from_outcome(elf_play: PlayChar, outcome: OutcomeChar) -> Self {
        let human_play = Game::calculate_human_play(elf_play, outcome);
        let human_score = Game::calculate_score(human_play, elf_play);

        Game {
            elf_play,
            outcome: Some(outcome),

            human_play,
            human_score,
        }
    }

    /// Converts the elf's play and the desiered outcome to the `PlayChar`
    /// the human should throw
    fn calculate_human_play(elf_play: PlayChar, outcome: OutcomeChar) -> PlayChar {
        match outcome {
            OutcomeChar::Lose => elf_play.defeats(),
            OutcomeChar::Draw => elf_play,
            OutcomeChar::Win => elf_play.loses_to(),
        }
    }

    /// score = shape + outcome
    fn calculate_score(human_play: PlayChar, elf_play: PlayChar) -> u8 {
        let shape_points = human_play.points();

        let human_points = match (human_play, elf_play) {

            // draws
            (PlayChar::Rock, PlayChar::Rock) => DRAW_POINTS,
            (PlayChar::Paper, PlayChar::Paper) => DRAW_POINTS,
            (PlayChar::Scissors, PlayChar::Scissors) => DRAW_POINTS,

            // wins
            (PlayChar::Rock, PlayChar::Scissors) => WIN_POINTS,
            (PlayChar::Paper, PlayChar::Rock) => WIN_POINTS,
            (PlayChar::Scissors, PlayChar::Paper) => WIN_POINTS,

            // losses
            (PlayChar::Rock, PlayChar::Paper) => LOST_POINTS,
            (PlayChar::Paper, PlayChar::Scissors) => LOST_POINTS,
            (PlayChar::Scissors, PlayChar::Rock) => LOST_POINTS,
        };

        shape_points + human_points
    }
}
