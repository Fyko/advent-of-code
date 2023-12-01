#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);

use constant INPUT_PATH => "../inputs/day01.txt";

my %digits = (
	"one" => 1,
	"two" => 2,
	"three" => 3,
	"four" => 4,
	"five" => 5,
	"six" => 6,
	"seven" => 7,
	"eight" => 8,
	"nine" => 9,
);

sub part_one {
	my $sum = 0;
   	open(my $FI, "<", INPUT_PATH) or die "Unable to open file ".INPUT_PATH.": $!.\n";
	while (<$FI>) {
		chomp;
		my @numbers = $_ =~ /(\d)/g;
		my $formatted = $numbers[0] * 10 + $numbers[-1];
		$sum += $formatted;
	}
	close($FI);

	return $sum;
}

sub part_two {
	my $keys_regex = join("|",  keys %digits);
	my $regex = "(\\d|$keys_regex)";
	print "regex: $regex\n";

	my $sum = 0;
	open (my $FI, "<", INPUT_PATH) or die "Unable to open file ".INPUT_PATH.": $!.\n";
	while (<$FI>) {
		chomp;
		my @numbers = $_ =~ /$regex/g;
		my @mapped = map { exists $digits{$_} ? $digits{$_} : $_ } @numbers;
		my $formatted = $mapped[0] * 10 + $mapped[-1];
		$sum += $formatted;
		# print "(@numbers)->(@mapped)->($formatted)\n";
	}
	close($FI);

	return $sum;
}

my $alpha = part_one();
print "part one: $alpha\n";

my $bravo = part_two();
print "(BROKEN) part two: $bravo\n";
