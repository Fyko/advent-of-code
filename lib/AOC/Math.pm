package AOC::Math;

use strict;
use warnings;
use feature 'say';

require Exporter;

our @ISA         = qw(Exporter);
our %EXPORT_TAGS = (
    'all' => [qw(
          gcd
          lcm
        )
    ],
);

our @EXPORT_OK = (@{ $EXPORT_TAGS{ 'all' } });

sub gcd {
    my ($a, $b) = @_;
    return $b ? gcd($b, $a % $b) : $a;
}

sub lcm {
    my $result = shift;
    foreach my $num (@_) {
        $result = abs($result * $num) / gcd($result, $num);
    }
    return $result;
}
