#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use feature 'say';
use lib './lib';

use Data::Dumper;
use List::Util qw(sum);
use AOC::Base  qw(main);
use AOC::Math  qw(lcm);

sub compute_sum {
    my ($lines_ref, $compute_func) = @_;
    my $sum = 0;

    foreach my $line (@$lines_ref) {
        my @numbers = split / /, $line;
        my $compute_prediction;
        $compute_prediction = sub {
            my (@nums) = @_;
            return 0 if keys %{ { map { $_ => 1 } @nums } } == 1 && $nums[0] == 0;
            return $compute_func->($nums[-1], $compute_prediction, @nums);
        };

        $sum += $compute_prediction->(@numbers);
    }

    return $sum;
}

sub part_one {
    my (@lines) = @_;
    return compute_sum(
        \@lines,
        sub {
            my ($last_num, $compute_prediction, @nums) = @_;
            return $last_num + $compute_prediction->(map { $nums[$_ + 1] - $nums[$_] } 0 .. $#nums - 1);
        });
}

sub part_two {
    my (@lines) = @_;
    return compute_sum(
        \@lines,
        sub {
            my ($_last_num, $compute_prediction, @nums) = @_;
            return $nums[0] - $compute_prediction->(map { $nums[$_ + 1] - $nums[$_] } 0 .. $#nums - 1);
        });
}

main("09_oasis", \&part_one, \&part_two);
