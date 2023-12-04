#!/usr/bin/perl

use strict;
use warnings;
use lib '../../lib';
use AOC::Base qw(main);
use List::Util 'max';

use constant INPUT_PATH => "./input.txt";
use constant RED_LIMIT   => 12;
use constant GREEN_LIMIT => 13;
use constant BLUE_LIMIT  => 14;

sub match_games {
    my $line          = shift;
    my ($game_number) = $line =~ /^Game\s(\d+):/;
    my %colors        = (red => [], green => [], blue => []);

    while ($line =~ /(\d+)\s+(red|green|blue)/g) {
        push @{ $colors{$2} }, $1;
    }

    return ($game_number, @colors{qw(red green blue)});
}

sub part_one {
    my (@lines) = @_;

    my $sum = 0;
    foreach my $line (@lines) {
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
    my (@lines) = @_;

    my $sum = 0;
    foreach my $line (@lines) {
        my ($game_number, $reds, $greens, $blues) = match_games($line);
        $sum += (max @$reds) * (max @$greens) * (max @$blues);
    }

    return $sum;
}

main(\&part_one, \&part_two);
