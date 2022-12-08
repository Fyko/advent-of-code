/// this code just barely works. if you want to run it, dont.
use nanoid::nanoid;

macro_rules! println {
    ($($rest:tt)*) => {
        if std::env::var("DEBUG").is_ok() {
            std::println!($($rest)*);
        }
    }
}

static INPUT: &str = include_str!("input.txt");

fn main() {
	print!("Day 07, part 1: {}", part_one(INPUT));
	print!("Day 07, part 2: {}", part_two(INPUT));
}

fn part_one(input: &'static str) -> usize {
	let landscape = parse(input);

	let sum = landscape
		.trees
		.iter()
		.filter(|tree| landscape.tree_is_visible(tree))
		.count();

	sum as usize
}

fn part_two(input: &'static str) -> usize {
	let landscape = parse(input);

	let scores = landscape.trees.iter().map(|tree| landscape.tree_score(tree));

	scores.max().unwrap()
}

struct Landscape {
	trees: Vec<Tree>,
}

impl Landscape {
	/// Iterate through all the trees and return a vec of trees to the TBLR of the given tree
	fn tree_sides(&self, tree: &Tree) -> Vec<Vec<&Tree>> {
		let tree_to_top = self.trees.iter().filter(|t| t.y < tree.y && t.x == tree.x).collect::<Vec<&Tree>>();
		let tree_to_bottom = self.trees.iter().filter(|t| t.y > tree.y && t.x == tree.x).collect::<Vec<&Tree>>();
		let tree_to_left = self.trees.iter().filter(|t| t.x < tree.x && t.y == tree.y).collect::<Vec<&Tree>>();
		let tree_to_right = self.trees.iter().filter(|t| t.x > tree.x && t.y == tree.y).collect::<Vec<&Tree>>();

		fn reverse(vec: Vec<&Tree>) -> Vec<&Tree> {
			let mut vec = vec;
			vec.reverse();
			vec
		}

		vec![reverse(tree_to_top), reverse(tree_to_bottom), reverse(tree_to_left), reverse(tree_to_right)]
	}

	fn tree_score(&self, tree: &Tree) -> usize {
		if tree.is_edge() {
			return 0;
		}

		let sides = self.tree_sides(tree);

		tree.viewing_distance(sides)
	}

	fn tree_is_visible(&self, tree: &Tree) -> bool {
		if tree.is_edge() {
			return true;
		}

		let sides = self.tree_sides(tree);
	
		tree.visible(sides)
	}
}

#[derive(Debug)]
struct Tree {
	id: String,
	x: u8,
	y: u8,
	height: usize,
	edge: bool,
}

impl Tree {
	fn is_edge(&self) -> bool {
		self.edge
	}

	// calculate how many trees are in each direction with a height less than the current tree
	fn viewing_distance(&self, sides: Vec<Vec<&Tree>>) -> usize {
		println!("got {} sides", sides.len());
		println!("sides: {:#?}", sides);

		// test_two
		// top 2
		// bottom 1
		// left 2
		// right 2
		let scores = sides.iter().enumerate().map(|(side_i, side)| {
			println!("now checking side {side_i}");

			let mut i = 0;
			'outer: for (tree_i, tree) in side.iter().enumerate() {
				println!("[side {}] checking tree {} ({})", side_i, tree.id, tree.height);
				if tree.height < self.height {
					println!("[side {}] side tree {} ({}) shorter!", side_i, tree.id, tree.height);
					i += 1;
				}

				// blocked by a tree! add one and break
				if tree.height == self.height || tree.height > self.height {
					println!("[side {}] blocked by tree {} ({}) breaking with i: {}", side_i, tree.id, tree.height, i);
					i += 1;
					
					break 'outer;
				}
			}

			println!("side {side_i} score: {}\n", i);
			
			i
		}).collect::<Vec<usize>>();

		// println!("tree sides: {:#?}", sides);
		println!("tree scores: {:#?}", scores);

		scores.iter().product()
	}

	fn visible(&self, sides: Vec<Vec<&Tree>>) -> bool {
		// we handle checking is_edge at a higher scope, so we dont need to do it again
		sides.iter().any(|side| side.iter().all(|tree| tree.height < self.height))
	}
}

// parse each line into "points" (x, y, height) as the fourth quadrant
fn parse(data: &'static str) -> Landscape {
	let mut trees = vec![];
	let data_height = data.lines().count();

	for (y, line) in data.lines().enumerate() {
		for (x, height) in line.chars().enumerate() {
			let height = height.to_digit(10).expect("Failed to parse height") as usize;
			trees.push(Tree {
				id: nanoid!(),
				x: x as u8,
				y: y as u8,
				height,
				edge: y == 0 || x == 0 || y == data_height - 1 || x == data_height - 1,
			});
		}
	}

	Landscape { trees }
}

#[test]
fn test_visibility() {
	let input = include_str!("demo.txt");
	let landscape = parse(input);
	assert_eq!(landscape.trees.len(), 25);

	let edges = landscape
		.trees
		.iter()
		.filter(|tree| tree.is_edge())
		.collect::<Vec<&Tree>>();
	assert_eq!(edges.len(), 16);

	let visible = landscape
		.trees
		.iter()
		.filter(|tree| landscape.tree_is_visible(tree))
		.collect::<Vec<&Tree>>();

	assert_eq!(visible.len(), 21);
}

#[test]
fn test_score_one() {
	let input = include_str!("demo.txt");
	let landscape = parse(input);
	
	let tree = landscape.trees.iter().find(|tree| tree.x == 2 && tree.y == 1 && tree.height == 5).expect("Failed to find demo tree");
	println!("{:?}", tree);
	
	assert_eq!(landscape.tree_score(tree), 4);
}

#[test]
fn test_score_two() {
	let input = include_str!("demo.txt");
	let landscape = parse(input);

	let tree = landscape.trees.iter().find(|tree| tree.x == 2 && tree.y == 3 && tree.height == 5).expect("Failed to find demo tree");
	println!("{:?}", tree);
	
	assert_eq!(landscape.tree_score(tree), 8);
}
