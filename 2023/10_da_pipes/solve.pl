#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use feature 'say';
use lib './lib';

use Data::Dumper;
use AOC::Base qw(main);
use AOC::Math qw(lcm);
use POSIX;
use Math::Polygon;    # cpanm Math::Polygon

sub determine_direction_from_pipe_and_direction {
    my ($pipe, $dir) = @_;

    # simple
    return "N" if $pipe eq "|" and $dir eq "N";
    return "S" if $pipe eq "|" and $dir eq "S";
    return "E" if $pipe eq "-" and $dir eq "E";
    return "W" if $pipe eq "-" and $dir eq "W";

    return "N" if $pipe eq "L" and $dir eq "W";
    return "E" if $pipe eq "L" and $dir eq "S";

    return "W" if $pipe eq "J" and $dir eq "S";
    return "N" if $pipe eq "J" and $dir eq "E";

    return "W" if $pipe eq "7" and $dir eq "N";
    return "S" if $pipe eq "7" and $dir eq "E";

    return "E" if $pipe eq "F" and $dir eq "N";
    return "S" if $pipe eq "F" and $dir eq "W";
}

my @points = ();
my %grid   = ();

sub part_one {
    my (@lines) = @_;

    while (my ($i, $line) = each @lines) {
        my @parts = split // => $line;
        $grid{ $i } = \@parts;
    }

    my ($x, $y) = (0, 0);
    while ($grid{ $y }[$x] ne 'S') {
        $x++;
        if ($x == scalar @{ $grid{ $y } }) {
            $x = 0;
            $y++;
        }
    }
    say "animal at ($x, $y)";
    push @points, "$x,$y";

    my $starting_direction = "";
    my %okay               = (
        N => [qw(| 7 F)],
        E => [qw(- J 7)],
        S => [qw(| L J)],
        W => [qw(- L F)],
    );
    for my $dir (keys %okay) {
        my $next = "";
        if ($dir eq 'N') {
            $next = $grid{ $y - 1 }[$x];
        } elsif ($dir eq 'E') {
            $next = $grid{ $y }[$x + 1];
        } elsif ($dir eq 'S') {
            $next = $grid{ $y + 1 }[$x];
        } elsif ($dir eq 'W') {
            $next = $grid{ $y }[$x - 1];
        }

        if (grep { $_ eq $next } @{ $okay{ $dir } }) {
            $starting_direction = $dir;
            last;
        }
    }

    say "starting direction: $starting_direction";
    $x += $starting_direction eq 'E' ? 1 : $starting_direction eq 'W' ? -1 : 0;
    $y += $starting_direction eq 'S' ? 1 : $starting_direction eq 'N' ? -1 : 0;
    push @points, "$x,$y";

    my $dir   = $starting_direction;
    my $steps = 1;
    while (1) {
        my $cell = $grid{ $y }[$x];
        push @points, "$x,$y";
        last if $cell eq 'S' or $cell eq ' ';
        $steps++;

        $dir = determine_direction_from_pipe_and_direction($cell, $dir);

        $y++ if $dir eq 'S';
        $y-- if $dir eq 'N';
        $x++ if $dir eq 'E';
        $x-- if $dir eq 'W';
    }

    return floor $steps / 2;
}

sub part_two {
    my (@lines) = @_;

    my $sum     = 0;
    my @points  = map { [split /,/] } @points;
    my $polygon = Math::Polygon->new(points => \@points);

    say "part two is slow as fuck.. be patient";
    while (my ($y, $line) = each %grid) {
        while (my ($x, $cell) = each @{ $line }) {
            next   if grep { $_ eq "$x,$y" } @points;
            $sum++ if $polygon->contains([$x, $y]);
        }
    }

    return $sum;
}

main("10_da_pipes", \&part_one, \&part_two);
