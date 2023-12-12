#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use feature 'say';
use lib './lib';

use Data::Dumper;
use AOC::Base qw(main read_lines);
use AOC::Math qw(lcm);

sub flat(@) {
    return map { ref eq 'ARRAY' ? @$_ : $_ } @_;
}

my @lines = read_lines("11_cosmic_expansion");

my @grid     = ();
my @galaxies = ();
my @steps_x  = ();
my @steps_y  = ();

while (my ($y, $line) = each @lines) {
    my @parts = split // => $line;
    push @grid, \@parts;
    push @steps_y, ('#' ~~ @parts) ? 1 : 2;

    for my $x (0 .. $#parts) {
        push @galaxies, [$x, $y] if $parts[$x] eq '#';
    }
}

for my $i (0 .. $#{ $grid[0] }) {
    my @col = map { $_->[$i] } @grid;

    push @steps_x, ('#' ~~ @col ? 1 : 2);
}

my $part_1 = 0;
my $part_2 = 0;

foreach my $x (0 .. $#galaxies) {
    foreach my $y ($x + 1 .. $#galaxies) {
        my ($x1, $y1) = @{ $galaxies[$x] };
        my ($x2, $y2) = @{ $galaxies[$y] };
        ($x1, $x2) = ($x2, $x1) if $x1 > $x2;
        ($y1, $y2) = ($y2, $y1) if $y1 > $y2;

        for my $i ($x1 + 1 .. $x2) {
            my $cost = $steps_x[$i];

            $part_1 += $cost;
            $part_2 += ($cost == 1) ? 1 : 1_000_000;
        }

        for my $i ($y1 + 1 .. $y2) {
            my $cost = $steps_y[$i];

            $part_1 += $cost;
            $part_2 += ($cost == 1) ? 1 : 1_000_000;
        }
    }
}

say "part_1: $part_1";
say "part_2: $part_2";
