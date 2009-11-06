use strict;
use warnings FATAL => 'all';

sub rhind {
    open(my $fh, 't/rhind.txt') or die $!;
    my @rhind;
    while (<$fh>) {
        next if /^\s*#/;
        next unless /\S/;
        push @rhind, [ split(' ',$_) ];
    }
    return @rhind;
}

1;
