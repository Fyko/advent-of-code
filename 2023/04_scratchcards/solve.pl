#!/usr/bin/perl

use strict;
use warnings;
use lib './lib';

use AOC::Base qw(main);

sub read_cards {
    my @cards = ();
    my @lines = @_;
    foreach my $line (@lines) {
        my ($card_number, $winners, $ours) = $line =~ /Card\s+(\d+):\s+([\d\s]+)\|\s+([\d\s]+)/;

        my @winners = split /\s+/, $winners;
        my @ours    = split /\s+/, $ours;

        my %e       = map  { $_ => undef } @winners;
        my @matches = grep { exists($e{ $_ }) } @ours;
        my $count   = scalar @matches;

        push(@cards, $count);
    }

    return @cards;
}

sub part_one {
    my (@lines) = @_;

    my $sum   = 0;
    my @cards = read_cards(@lines);
    while (my ($card_number, $count) = each @cards) {
        next if $count == 0;

        my $points = ($count > 1) ? 2**($count - 1) : 1;
        $sum += $points;
    }

    return $sum;
}

sub part_two {
    my (@lines) = @_;

    my $sum   = 0;
    my @cards = read_cards(@lines);

    # stores the cards we've already seen so we dont have to recalculate
    my %store = ();
    while (my ($card_number, $count) = each @cards) {
        $sum += ($store{ $card_number } // 0) + 1;
        next if $count == 0;

        for (my $i = 0 ; $i < $count ; $i++) {
            my $next  = $card_number + $i + 1;
            my $value = ($store{ $next } // 0) + ($store{ $card_number } // 0) + 1;

            $store{ $next } = $value;
        }
    }

    return $sum;
}

main("04_scratchcards", \&part_one, \&part_two);
