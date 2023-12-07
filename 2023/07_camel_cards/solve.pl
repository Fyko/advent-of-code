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

sub part_one {
    my (@lines) = @_;
    my %cards = map { split /\h/ } @lines;

    # hand => rank
    my %rankings = ();
    while (my ($hand, $bid) = each %cards) {
        my $rank  = 0;
        my @chars = split //, $hand;

        my %count;
        $count{ $_ }++ foreach @chars;

        if (grep { $_ == 5 } values %count) {
            $rank = RANK_FIVE_OF_A_KIND;
        } elsif (grep { $_ == 4 } values %count) {
            $rank = RANK_FOUR_OF_A_KIND;
        } elsif ((grep { $_ == 3 } values %count) && (grep { $_ == 2 } values %count)) {
            $rank = RANK_FULL_HOUSE;
        } elsif (grep { $_ == 3 } values %count) {
            $rank = RANK_THREE_OF_A_KIND;
        } elsif ((scalar grep { $_ == 2 } values %count) == 2) {
            $rank = RANK_TWO_PAIR;
        } elsif ((scalar grep { $_ == 2 } values %count) == 1) {
            $rank = RANK_PAIR;
        } elsif (scalar grep { $_ == 1 } values %count == 5) {
            $rank = RANK_HIGH_CARD;
        }

        $rankings{ $hand } = $rank;
    }

    my %chunks;
    while (my ($hand, $rank) = each %rankings) {
        push @{ $chunks{ $rank } }, $hand;
    }

    my %card_rankings = (
        'A' => 14,
        'K' => 13,
        'Q' => 12,
        'J' => 11,
        'T' => 10,
    );

    while (my ($rank, $hands) = each %chunks) {
        @{ $chunks{ $rank } } = sort {
            my @as = split //, $a;
            my @bs = split //, $b;

            my $i = 0;
            while ($i < scalar @as) {
                my $as  = $as[$i];
                my $bs  = $bs[$i];
                my $cmp = (looks_like_number($as) ? $as : $card_rankings{ $as }) <=> (looks_like_number($bs) ? $bs : $card_rankings{ $bs });
                return $cmp if $cmp != 0;
                ++$i;
            }

            return 0;
        } @{ $chunks{ $rank } };
    }

    say Dumper \%chunks;

    my @sorted_hands = map { @{ $chunks{ $_ } } } sort { $a <=> $b } keys %chunks;

    say Dumper \@sorted_hands;

    my $sum = 0;
    while (my ($index, $hand) = each @sorted_hands) {
        my $rank = $index + 1;
        my $bid  = $cards{ $hand };
        my $diff = $rank * $bid;
        say "$rank: $hand +$diff (\$$bid)";
        $sum += $diff;
    }

    return $sum;
}

sub part_two {
    my (@lines) = @_;
    return 0;
}

main("07_camel_cards", \&part_one, \&part_two);
