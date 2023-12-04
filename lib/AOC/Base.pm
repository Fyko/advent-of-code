package AOC::Base;

use strict;
use warnings;
use Benchmark qw(:all);

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = (
	'all' => [qw(
		iter_file
        main
	)],
);

our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});

sub iter_file {
    open(my $FI, "<", "./input.txt") or die "Unable to open input file: $!.\n";
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

sub read_lines {
    open(my $FI, "<", "./input.txt") or die "Unable to open input file: $!.\n";
    my @lines = map { chomp; $_ } <$FI>;
    close($FI);

    return @lines;
}

sub main {
    my ($alpha, $bravo) = @_;

    my @input = read_lines();

    my $alpha_res = $alpha->(@input);
    print "part one: $alpha_res\n";
    my $bravo_res = $bravo->(@input);
    print "part two: $bravo_res\n";

    # return if argv does not contain word bench
    return if (grep { $_ eq "bench" } @ARGV) == 0;

    my $results = timethese(0, {
        'part one' => sub { $alpha->(@input) },
        'part two' => sub { $bravo->(@input) },
    }, 'none');

    foreach my $part (keys %$results) {
        print "$part result:", timestr($results->{$part}), "\n";
    }
}
