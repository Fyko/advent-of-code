#!/usr/bin/perl

use strict;
use warnings;
use List::Util 'max';

use constant INPUT_PATH => "../inputs/day02.txt";
use constant RED_LIMIT => 12;
use constant GREEN_LIMIT => 13;
use constant BLUE_LIMIT => 14;

sub open_file {
    open(my $FI, "<", INPUT_PATH) or die "Unable to open file ".INPUT_PATH.": $!.\n";
    return sub {
        if (my $line = <$FI>) {
            return $line;
        } else {
            close($FI);
            return;
        }
    };
}

sub match_games {
    my $line = shift;
    my ($game_number) = $line =~ /^Game\s(\d+):/;
    my %colors = (red => [], green => [], blue => []);

    while ($line =~ /(\d+)\s+(red|green|blue)/g) {
        push @{$colors{$2}}, $1;
    }

    return ($game_number, @colors{qw(red green blue)});
}

sub part_one {
	my $sum = 0;

	my $lines = open_file();
	while (defined(my $line = $lines->())) {
		chomp $line;
		my ($game_number, $reds, $greens, $blues) = match_games($line);

		# skip "impossible" games
		next if grep { $_ > RED_LIMIT } @$reds;
		next if grep { $_ > GREEN_LIMIT } @$greens;
		next if grep { $_ > BLUE_LIMIT } @$blues;
		$sum += $game_number;
	}

	return $sum;
}

sub part_two {
	my $sum = 0;

   	my $lines = open_file();
	while (defined(my $line = $lines->())) {
		chomp $line;
		my ($game_number, $reds, $greens, $blues) = match_games($line);
		$sum += (max @$reds) * (max @$greens) * (max @$blues);
	}

	return $sum;
}

my $alpha = part_one();
print "part one: $alpha\n";

my $bravo = part_two();
print "part two: $bravo\n";
