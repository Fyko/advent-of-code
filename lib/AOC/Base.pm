package AOC::Base;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = (
	'all' => [qw(
		iter_file
	)],
);

our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});

sub iter_file {
	my $path = shift;
    open(my $FI, "<", $path) or die "Unable to open file " . $path . ": $!.\n";
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
