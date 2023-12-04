#!/usr/bin/perl
# cpanm Array::Utils

use strict;
use warnings;

use constant INPUT_PATH => "../inputs/day04.txt";

sub open_file {
    open(my $FI, "<", INPUT_PATH) or die "Unable to open file " . INPUT_PATH . ": $!.\n";
    return sub {
        if (my $line = <$FI>) {
            return $line;
        }
        else {
            close($FI);
            return;
        }
    };
}

sub read_cards {
    my @cards = ();
    my $lines = open_file();
    while (defined(my $line = $lines->())) {
        chomp $line;
        my ($card_number, $winners, $ours) = $line =~ /Card\s+(\d+):\s+([\d\s]+)\|\s+([\d\s]+)/;

        my @winners = split /\s+/, $winners;
        my @ours = split /\s+/, $ours;

        my %e = map { $_ => undef } @winners;
        my @matches = grep { exists( $e{$_} ) } @ours;
        my $count = scalar @matches;

        push(@cards, $count);
    }

    return @cards;
}

sub part_one {
    my $sum    = 0;
    # my %cards = read_cards();
    my @cards = read_cards();

    while (my ($card_number, $count) = each @cards) {
    # while (my $card = shift @cards) {
        next if $count == 0;

        my $points = ($count > 1) ? 2 ** ($count - 1) : 1;
        $sum += $points;
    }

    return $sum;
}

my $alpha = part_one();
print "part one: $alpha\n";

sub part_two {
    my $sum    = 0;
    my @cards = read_cards();

    # stores the cards we've already seen so we dont have to recalculate
    my %store = ();
    while (my ($card_number, $count) = each @cards) {
        $sum += ($store{$card_number} // 0) + 1;
        next if $count == 0;

        for (my $i = 0; $i < $count; $i++) {
            my $next = $card_number + $i + 1;
            my $value = ($store{$next} // 0) + ($store{$card_number} // 0) + 1;

            $store{$next} = $value;
        }
    }

    return $sum;
}

my $bravo = part_two();
print "part two: $bravo\n";
