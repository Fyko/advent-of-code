#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use feature 'say';
use lib './lib';

use Data::Dumper;
use AOC::Base qw(main);

sub part_one {
    my (@lines)   = @_;
    my @times     = grep { /^\d+$/ } split /\h/, shift @lines;
    my @distances = grep { /^\d+$/ } split /\h/, shift @lines;
    my %games     = map  { $times[$_] => $distances[$_] } 0 .. $#times;

    my $total = 1;
    while (my ($time, $record) = each %games) {
        my $methods = 0;

        # determine every solution from 0 to $time
        for my $xcharging (0 .. $time) {
            ++$methods if ($time - $xcharging) * $xcharging > $record;
        }
        $total *= $methods;
    }

    return $total;
}

sub part_two {
    my (@lines)   = @_;
    my @times     = grep { /^\d+$/ } split /\h/, shift @lines;
    my @distances = grep { /^\d+$/ } split /\h/, shift @lines;
    my $time      = join '', @times;
    my $record    = join '', @distances;

    my $lower_bp;
    for my $xcharging (0 .. $time / 2) {
        if (($time - $xcharging) * $xcharging > $record) {
            $lower_bp = $xcharging;
            last;
        }
    }
    my $upper_bp = $time - $lower_bp;

    return $upper_bp - $lower_bp + 1;
}

main("06_boat_races", \&part_one, \&part_two);
