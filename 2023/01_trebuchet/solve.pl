#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use builtin qw(indexed);
use lib './lib';

use AOC::Base qw(main);

sub part_one {
    my (@lines) = @_;

    my $sum = 0;
    foreach my $line (@lines) {
        my @numbers   = $line =~ /(\d)/g;
        my $formatted = $numbers[0] * 10 + $numbers[-1];
        $sum += $formatted;
    }

    return $sum;
}

sub part_two {
    my (@lines) = @_;

    my @digits = qw(zero one two three four five six seven eight nine);
    my %digits = reverse indexed @digits;
    my $regex  = join('|', '\d', %digits);

    my $sum = 0;
    while (@lines) {
        my ($first) = /($regex)/;
        my ($last)  = /.*($regex)/;
        for ($first, $last) {
            $_ = $digits{ $_ } if !/\d/;
        }
        $sum += "$first$last";
    }

    return $sum;
}

main("01_trebuchet", \&part_one, \&part_two);
