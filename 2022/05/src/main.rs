#![feature(drain_filter)]
use anyhow::Result;
use std::{
	str::FromStr,
};

fn main() {
	println!("Day 05, part 1: {:#?}", part_one());
	println!("Day 05, part 2: {:#?}", part_two());
}

fn part_one() -> String {
	let (mut stacks, instructions) = parse_input();
	logic(&mut stacks, instructions, false);

	top_crates(&stacks)
}

fn part_two() -> String {
	let (mut stacks, instructions) = parse_input();
	logic(&mut stacks, instructions, true);

	top_crates(&stacks)
}

#[derive(Debug, Clone)]
struct Instruction {
	// move $count from $from to $to
	count: u8,
	from: u8,
	to: u8,
}

impl FromStr for Instruction {
	type Err = anyhow::Error;

	fn from_str(s: &str) -> Result<Self, Self::Err> {
		// match the instruction "move $count from $from to $to"
		let re = regex::Regex::new(r"move (\d+) from (\d+) to (\d+)")?;
		let caps = re
			.captures(s)
			.ok_or(anyhow::anyhow!("Invalid instruction"))?;

		let count: u8 = caps.get(1).unwrap().as_str().parse()?;
		let from: u8 = caps.get(2).unwrap().as_str().parse()?;
		let to: u8 = caps.get(3).unwrap().as_str().parse()?;

		Ok(Instruction { count, from: from - 1, to: to - 1 })
	}
}

fn parse_input() -> (Vec<Vec<String>>, Vec<Instruction>) {
	let input = include_str!("./input.txt").lines();
	let mut input = input.collect::<Vec<&str>>();

	let crates = input.drain(0..8).rev().collect::<Vec<&str>>();
	let re1 = regex::Regex::new(r"\[([A-Z])\]").unwrap();
	let stack_count = re1.captures_iter(crates[0]).count();
	let mut stacks = vec![Vec::new(); stack_count];

	for line in crates {
		for cap in re1.captures_iter(line) {
			let value = cap.get(1).unwrap().as_str();
			let index = (cap.get(1).unwrap().start() as i32 / 4).abs();
			stacks[index as usize].push(value.to_string());
		}
	}

	input.drain(0..2);
	let instruction = input
		.iter()
		.map(|x| Instruction::from_str(x.to_owned()).unwrap())
		.collect::<Vec<Instruction>>();

	return (stacks, instruction);
}

fn logic(stacks: &mut Vec<Vec<String>>, instructions: Vec<Instruction>, p_2: bool) {
	for instruction in instructions {
		if p_2 {
			let mut tmp = Vec::new();
			for _ in 0..instruction.count {
				let v = stacks[instruction.from as usize].pop().unwrap();
				tmp.push(v);
			}

			for _ in 0..instruction.count {
				stacks[instruction.to as usize].push(tmp.pop().unwrap());
			}
		} else {
			for _ in 0..instruction.count {
				let v = stacks[instruction.from as usize].pop().unwrap();
				stacks[instruction.to as usize].push(v);
			}
		}
	}
}

fn top_crates(stacks: &Vec<Vec<String>>) -> String {
	let mut top = String::new();
	for stack in stacks {
		if stack.len() > 0 {
			top.push_str(&stack[stack.len() - 1]);
		}
	}

	top
}
