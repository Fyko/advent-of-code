static INPUT: &str = include_str!("input.txt");

fn main() {
	println!("Day 07, part 1: {}", part_one(INPUT));
	println!("Day 07, part 2: {}", part_two(INPUT));
}

fn part_one(input: &'static str) -> usize {
	let dir = parse(input);

	dir.sizes().iter()
		.filter(|size| **size <= 100000)
		.sum::<usize>()
}

fn part_two(input: &'static str) -> usize {
	let dir = parse(input);

	let available = 70_000_000;
	let needs = 30_000_000;
	let unused = available - dir.size();
	let target = needs - unused;

	*dir.sizes().iter().find(|s| **s >= target).unwrap()
}

#[derive(Debug)]
struct FileSystem {
	subdirs: Vec<FileSystem>,
	files: Vec<usize>,
}

impl FileSystem {
	fn new() -> FileSystem {
		FileSystem {
			subdirs: Vec::new(),
			files: Vec::new(),
		}
	}

    fn size(&self) -> usize {
        let file_size = self.files.iter().sum::<usize>();
        let dir_size = self
            .subdirs
            .iter()
            .map(|dir| dir.size())
            .sum::<usize>();

        file_size + dir_size
    }

    fn sizes(&self) -> Vec<usize> {
        self.subdirs
            .iter()
            .flat_map(|dir| dir.sizes())
            .chain([self.size()])
            .collect()
    }
}

fn parse(data: &'static str) -> FileSystem {
	let mut state = vec![FileSystem::new()];

	for line in data.lines() {
		match line {
			"$ ls" => (),
			"$ cd /" => (),
			"$ cd .." => {
				let dir = state.pop().unwrap();
				state.last_mut().unwrap().subdirs.push(dir);
			}
			line if line.starts_with("$ cd ") => {
				state.push(FileSystem::new());
			}
			line if line.starts_with("dir ") => (),
			line => {
				let file = line
					.split_once(' ')
					.map(|(size, _)| size.parse().unwrap())
					.unwrap();
				state.last_mut().unwrap().files.push(file);
			}
		}
	}

	while state.len() > 1 {
		let dir = state.pop().unwrap();
		state.last_mut().unwrap().subdirs.push(dir);
	}

	state.into_iter().next().unwrap()
}
