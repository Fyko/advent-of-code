#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use lib './lib';

use AOC::Base qw(main);

sub match_part_number {
    my ($value, $x, $y, $gears, @lines) = @_;

    # check bounds
    return 0 if $x < 0 || $x >= (scalar @lines);
    return 0 if $y < 0 || $y >= length($lines[0]);

    my $char = substr($lines[$y], $x, 1);
    return 0 if ($char =~ /[\d|.]/i);    # skip numbers and periods

    # we can take advantage of this data to populate our gears
    # hash during part one
    if ($char eq "*") {
        my $i = length($lines[0]) * $y + $x;

        $gears->{ $i } = [] if (not defined $gears->{ $i });
        push(@{ $gears->{ $i } }, $value);
    }

    return 1;
}

my %gears = ();

sub part_one {
    my (@lines) = @_;
    my $sum     = 0;
    my @angles  = ([1, 1], [1, -1], [-1, 1], [-1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]);

    # iter over each line of the symbols
    while (my ($iline, $line) = each @lines) {
        while ($line =~ /(\d+)/g) {
          outer: foreach my $col ($-[0] .. $+[0] - 1) {

                # look in every dirction
                foreach my $angle (@angles) {
                    my $match = match_part_number($1, $col + @{ $angle }[1], $iline + @{ $angle }[0], \%gears, @lines);

                    if ($match) {
                        $sum += $1;
                        last outer;
                    }
                }
            }
        }
    }

    return $sum;
}

sub part_two {
    my $sum = 0;

    foreach my $value (values %gears) {
        $sum += (@{ $value }[0] * @{ $value }[1]) if (scalar @{ $value } == 2);
    }

    return $sum;
}

main("03_gear_ratios", \&part_one, \&part_two);
