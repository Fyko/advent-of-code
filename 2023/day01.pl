#!/usr/bin/perl

use strict;
use warnings;
use experimental 'builtin';
use builtin 'indexed';

use constant INPUT_PATH => "../inputs/day01.txt";

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
	my @digits = qw(zero one two three four five six seven eight nine);
	my %digits = reverse indexed @digits;
	my $regex = join('|', '\d', %digits);

	my $sum = 0;
	open (my $FI, "<", INPUT_PATH) or die "Unable to open file ".INPUT_PATH.": $!.\n";
	while (<$FI>) {
		chomp;
		my ($first) = /($regex)/;
		my ($last)  = /.*($regex)/;
		for ($first, $last) {
			$_ = $digits{$_} if !/\d/;
		}
		$sum += "$first$last";
	}
	close($FI);

	return $sum;
}

my $alpha = part_one();
print "part one: $alpha\n";

my $bravo = part_two();
print "part two: $bravo\n";
