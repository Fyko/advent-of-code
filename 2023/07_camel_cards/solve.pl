#!/usr/bin/perl -d:NYTProf

use strict;
use warnings;
use feature 'say';
use lib './lib';

use Data::Dumper;
use Scalar::Util qw(looks_like_number);
use AOC::Base    qw(main);

use constant {
    RANK_HIGH_CARD       => 1,
    RANK_PAIR            => 2,
    RANK_TWO_PAIR        => 3,
    RANK_THREE_OF_A_KIND => 4,
    RANK_FULL_HOUSE      => 5,
    RANK_FOUR_OF_A_KIND  => 6,
    RANK_FIVE_OF_A_KIND  => 7, };

sub compute_hand_rank {
    my ($hand, $check_jokers) = @_;

    my $jokers = $check_jokers ? () = $hand =~ /J/g : 0;

    my %count;
    foreach my $card (split // => $hand) {
        next if ($card eq 'J' && $check_jokers);
        $count{ $card }++;
    }

    my @counts = @count{ sort { $count{$b} <=> $count{$a} } keys %count };
    my ($x, $y) = @counts;

    return RANK_FIVE_OF_A_KIND if $jokers == 5 || $x + $jokers == 5;
    return RANK_FOUR_OF_A_KIND if $x + $jokers == 4;
    return RANK_FULL_HOUSE      if $x + $jokers == 3 && $y == 2;
    return RANK_THREE_OF_A_KIND if $x + $jokers == 3 && $y != 2;
    return RANK_TWO_PAIR        if $x + $jokers == 2 && $y == 2;
    return RANK_PAIR            if $x + $jokers == 2 && $y != 2;
    return RANK_HIGH_CARD;
}

sub create_card_groups {
    my ($rankings, $face_rankings) = @_;

    my %groups;
    while (my ($hand, $rank) = each %$rankings) {
        push @{ $groups{ $rank } }, $hand;
    }

    while (my ($rank, $hands) = each %groups) {
        @{ $groups{ $rank } } = sort {
            my @as = split //, $a;
            my @bs = split //, $b;

            my $i = 0;
            while ($i < scalar @as) {
                my $as  = $as[$i];
                my $bs  = $bs[$i];
                my $cmp = (looks_like_number($as) ? $as : $face_rankings->{ $as }) <=> (looks_like_number($bs) ? $bs : $face_rankings->{ $bs });
                return $cmp if $cmp != 0;
                ++$i;
            }

            return 0;
        } @{ $groups{ $rank } };
    }

    return %groups;
}

sub do_part {
    my (@lines, $face_rankings, $check_jokers) = @_;

    my %cards = map { split /\h/ } @lines;

    my %rankings = ();
    while (my ($hand, $bid) = each %cards) {
        my $rank = compute_hand_rank($hand, 0);
        $rankings{ $hand } = $rank;
    }

    my %groups = create_card_groups(\%rankings, \%$face_rankings);

    my @sorted_hands = map { @{ $groups{ $_ } } } sort { $a <=> $b } keys %groups;

    my $sum = 0;
    while (my ($index, $hand) = each @sorted_hands) {
        my $rank = $index + 1;
        my $bid  = $cards{ $hand };
        my $diff = $rank * $bid;
        $sum += $diff;
    }

    return $sum;
}

sub sum_groups {
    my ($groups, $cards) = @_;

    my @sorted_hands = map { @{ $groups->{ $_ } } } sort { $a <=> $b } keys %$groups;

    my $sum = 0;
    while (my ($index, $hand) = each @sorted_hands) {
        my $rank = $index + 1;
        my $bid  = %$cards{ $hand };
        my $diff = $rank * $bid;
        $sum += $diff;
    }

    return $sum;
}

sub part_one {
    my (@lines) = @_;
    my %cards = map { split /\h/ } @lines;

    my %rankings = map { my $rank = compute_hand_rank($_, 0); $_ => $rank } keys %cards;

    my %face_rankings = (
        'A' => 14,
        'K' => 13,
        'Q' => 12,
        'J' => 11,
        'T' => 10,
    );
    my %groups = create_card_groups(\%rankings, \%face_rankings);

    return sum_groups(\%groups, \%cards);
}

sub part_two {
    my (@lines) = @_;
    my %cards = map { split /\h/ } @lines;

    my %rankings = map { my $rank = compute_hand_rank($_, 1); $_ => $rank } keys %cards;

    my %card_rankings = (
        'A' => 14,
        'K' => 13,
        'Q' => 12,
        'J' => 1,
        'T' => 10,
    );
    my %groups = create_card_groups(\%rankings, \%card_rankings);

    return sum_groups(\%groups, \%cards);
}

main("07_camel_cards", \&part_one, \&part_two);
