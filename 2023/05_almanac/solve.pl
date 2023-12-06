#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use lib './lib';

use Data::Dumper;
use List::Util qw(first min max);
use AOC::Base  qw(main);

sub parse_almanac {
    my ($input) = @_;

    my @segments = map {
        s/^\s+|\s+$//g;
        my $line = (split(/:\s/, $_))[1];
        [split /\n/, $line];
    } split /\n\n/, $input;

    my @seeds = split /\s/, shift(@segments)->[0];

    return \@seeds, \@segments;
}

sub process_input {
    my (@lines) = @_;
    return join "\n", @lines;
}

sub part_one {
    my (@lines) = @_;
    my $input = process_input(@lines);

    my ($seeds, $segments) = parse_almanac($input);

    sub determine_range_value {
        my ($value, @ranges) = @_;

        foreach my $range (@ranges) {
            my ($destination, $source, $length) = split /\s/, $range;
            my $outval = $destination + ($value - $source);

            return $outval if $value >= $source && $value < $source + $length;
        }

        return $value;
    }

    my @values = map {
        my $value = $_;
        foreach my $segment (@$segments) {
            ($value) = determine_range_value($value, @$segment);
        }

        $value;
    } @$seeds;

    return min(@values);
}

sub part_two {
    my (@lines) = @_;
    my $input = process_input(@lines);

    my ($seed_ranges, $segments) = parse_almanac($input);

    sub determine_range_value_skip {
        my ($value, @ranges) = @_;

        my @sources = ();

        foreach my $range (@ranges) {
            my ($destination, $source, $length) = split /\s/, $range;
            push @sources, $source;

            my $outval  = $destination + ($value - $source);
            my $outskip = ($source + $length - 1) - $value;

            return $outval, $outskip if $value >= $source && $value < $source + $length;
        }

        my @sorted_sources = sort { $a <=> $b } @sources;
        my $skip           = first { $_ > $value } @sorted_sources;
        $skip = "inf" if !defined $skip;

        return $value, $skip;
    }

    my $best = "inf";
    for (my $i = 0 ; $i < @$seed_ranges ; $i += 2) {
        my ($start, $length) = @{ $seed_ranges }[$i, $i + 1];
        my $skip_window = $length;

        for (my $offset = 0 ; $offset < $length ; $offset += max(1, $skip_window)) {
            my $value = $start + $offset;
            $skip_window = $length - $offset;

            foreach my $segment (@$segments) {
                my ($new_value, $skip) = determine_range_value_skip($value, @$segment);
                $value       = $new_value;
                $skip_window = min($skip, $skip_window) if $skip < $length - $offset;
            }
            $best = min($best, $value);
        }
    }

    return $best;
}

main("05_almanac", \&part_one, \&part_two);
