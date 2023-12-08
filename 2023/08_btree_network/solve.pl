#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use feature 'say';
use lib './lib';

use Data::Dumper;
use AOC::Base qw(main);
use AOC::Math qw(lcm);

sub create_tree {
    my ($lines) = @_;

    my %tree;
    for my $line (@{ $lines }) {
        my ($parent, $child) = split / = /, $line;
        my ($left, $right) = $child =~ /(\w+), (\w+)/;
        $tree{ $parent } = [$left, $right];
    }

    return %tree;
}

sub part_one {
    my (@lines)    = @_;
    my @directions = split //, shift @lines;
    shift @lines;    # blank line
    my %tree = create_tree(\@lines);

    my $steps = 0;
    my $node  = "AAA";
    while (1) {
        my $direction = $directions[$steps % scalar @directions];
        $steps += 1;
        $node = $tree{ $node }->[$direction eq 'L' ? 0 : 1];
        last if $node eq "ZZZ";
    }

    return $steps;
}

sub part_two {
    my (@lines)    = @_;
    my @directions = split //, shift @lines;
    shift @lines;    # blank line
    my %tree = create_tree(\@lines);

    my @a_nodes      = grep { /A$/ } keys %tree;
    my @node_history = (0) x scalar @a_nodes;

    my $steps = 0;
    while (1) {
        my $direction = $directions[$steps % scalar @directions];

        while (my ($ni, $node) = each @a_nodes) {
            $node_history[$ni] = $steps if $node =~ /Z$/;
            $a_nodes[$ni]      = $tree{ $node }->[$direction eq 'L' ? 0 : 1];
        }
        $steps += 1;

        last if (grep { $_ == 0 } @node_history) == 0;
    }

    $steps = lcm(@node_history);
    return $steps;
}

main("08_btree_network", \&part_one, \&part_two);
