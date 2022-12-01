use anyhow::{Result, anyhow};
use std::collections::HashMap;

fn main() -> Result<()> {
    match day_01_p1() {
        Ok(res) => println!("Day 01, part 1: {:#?}", res),
        Err(e) => panic!("Day 01, part 1 paniced: {}", e)
    }

    match day_01_p2() {
        Ok(res) => println!("Day 01, part 2: {:#?}", res),
        Err(e) => panic!("Day 01, part 2 paniced: {}", e)
    }

    Ok(())
}

// Turn the input into a HashMap of `elf_id:calories`
fn calculate_elf_calories() -> Result<HashMap<usize, u32>> {
    let data = include_str!("./d01.txt");
    let data = data.replace("\n", ",");

    let mut elves: HashMap<usize, u32> = HashMap::new();
    for (i, elf_data) in data.split(",,").enumerate() {
        let split = elf_data.split(",");
        let calories = split.map(|x| x.parse::<u32>().unwrap()).collect::<Vec<u32>>();
        let sum = calories.iter().fold(0, |acc, v| acc + v);
        
        elves.insert(i, sum);
    }

    Ok(elves)
}

// Find greatest
fn day_01_p1() -> Result<u32> {
    if let Ok(elves) = calculate_elf_calories() {
        if let Some((_, calories)) = elves.iter().max_by(|a, b| a.1.cmp(&b.1)) {
            return Ok(*calories);
        }
    
        return Err(anyhow!("Failed to pull greatest"))
    }

    Err(anyhow!("Failed to parse each elves calories"))
}

// Sum of Top 3
fn day_01_p2() -> Result<u32> {
    if let Ok(elves) = calculate_elf_calories() {
        let mut sorted: Vec<_> = elves.iter().collect();
        sorted.sort_by(|(_, a), (_, b)| a.cmp(b).reverse());
        
        let first_three = sorted.drain(0..3).fold(0, |acc, (_, v)| acc + v);
        return Ok(first_three);
    }

    Err(anyhow!("Failed to parse each elves calories"))
}
