use std::collections::VecDeque;

static INPUT: &str = include_str!("input.txt");

fn main() {
	println!("Day 07, part 1: {}", part1(INPUT));
	println!("Day 07, part 2: {}", part2(INPUT));
}

fn part1(input: &'static str) -> usize {
    let dirs = parse_dirs(input);
    dirs.iter().filter(|c| **c <= 100000).sum::<usize>()
}

fn part2(input: &'static str) -> usize {
    let dirs = parse_dirs(input);

    let available = 70000000;
    let needs = 30000000;
    let unused = available - dirs.last().unwrap();
    let target = needs - unused;

    *dirs.iter().find(|s| **s >= target).unwrap()
}

fn parse_dirs(input: &'static str) -> Vec<usize> {
    let root = Element::from(input);

    let mut dirs = Vec::new();
    walk(&root, &mut dirs);
    dirs.sort();

    dirs
}

fn walk(node: &Element, dirs: &mut Vec<usize>) {
    dirs.push(node.size());

    for sub in node.subdirs().unwrap() {
        walk(sub, dirs);
    }
}

#[derive(Debug)]
enum Command {
    Cd(&'static str),
    Ls(Vec<&'static str>),
}

#[derive(Debug)]
enum Element {
    Dir(Vec<Element>),
    File(usize),
}

impl Element {
    fn size(&self) -> usize {
        match self {
            Element::Dir(contents) => contents.iter().map(|e| e.size()).sum::<usize>(),
            Element::File(s) => *s,
        }
    }

    fn is_dir(&self) -> bool {
        match self {
            Element::Dir(_) => true,
            Element::File(_) => false,
        }
    }

    fn subdirs(&self) -> Option<Vec<&Element>> {
        match self {
            Element::Dir(contents) => Some(contents.iter().filter(|e| e.is_dir()).collect()),
            Element::File(_) => None,
        }
    }
}

impl From<&'static str> for Element {
    fn from(data: &'static str) -> Self {
        let mut commands = data
            .split("$ ")
            .skip(1)
            .map(|l| match &l[..=1] {
                "cd" => Command::Cd(l.split_whitespace().last().unwrap()),
                "ls" => Command::Ls(l.lines().skip(1).collect()),
                _ => panic!(),
            })
            .collect::<VecDeque<_>>();

        fn handle_cmd(commands: &mut VecDeque<Command>) -> Vec<Element> {
            let mut cwd = Vec::new();

            while let Some(cmd) = commands.pop_front() {
                match cmd {
                    Command::Cd(path) if path == ".." => return cwd,
                    Command::Cd(_) => cwd.push(Element::Dir(handle_cmd(commands))),
                    Command::Ls(listing) => {
                        for file in listing.iter().filter_map(|l| {
                            let (a, _) = l.split_once(' ').unwrap();
                            if let Ok(bytes) = a.parse::<usize>() {
                                Some(Element::File(bytes))
                            } else {
                                None
                            }
                        }) {
                            cwd.push(file);
                        }
                    }
                }
            }

            cwd
        }

        let mut elements = handle_cmd(&mut commands);
        elements.remove(0)
    }
}
