package AOC::Base;

use strict;
use warnings;
use feature 'say';
use Term::ANSIColor;
use Time::HiRes qw(time);
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

# iterates over the lines of a file, returning a closure
sub iter_file {
    open(my $FI, "<", "./input") or die "Unable to open input file: $!.\n";
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

# reads the lines of a file into an array
sub read_lines {
    open(my $FI, "<", "./input") or die "Unable to open input file: $!.\n";
    my @lines = map { chomp; $_ } <$FI>;
    close($FI);

    return @lines;
}

# main function for running the advent of code
# provide `bench` when running cli to benchmark
sub main {
    my ($alpha, $bravo) = @_;

    my @input = read_lines();
    say "part one: ".colored( ['bold green'], $alpha->(@input));
    say "part two: ".colored( ['bold green'], $bravo->(@input));

    return if (grep { $_ eq "bench" } @ARGV) == 0;

    my $n_seconds = 5; # run for n seconds, modify as needed

    my %benchmarks = (
        'part one' => sub { $alpha->(@input) },
        'part two' => sub { $bravo->(@input) },
    );

    foreach my $part (keys %benchmarks) {
        my $start_time = time();
        my $end_time = $start_time + $n_seconds;
        my $iterations = 0;
        my $total_time_ms = 0;
        my @iteration_times_ms;

        while (time() < $end_time) {
            my $start = time();
            $benchmarks{$part}->();
            my $end = time();
            my $duration_ms = ($end - $start) * 1_000;
            $total_time_ms += $duration_ms;
            $iterations++;
        }

        my $avg_time_per_iteration_ms = $total_time_ms / $iterations;
        say "$part: took ".sprintf("%.3f", $total_time_ms)."ms (avg ".(sprintf "%.3f", $avg_time_per_iteration_ms)."ms) (n=$iterations)";
    }
}
