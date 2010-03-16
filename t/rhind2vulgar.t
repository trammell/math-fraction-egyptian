use strict;
use warnings FATAL => 'all';
use Test::More 'no_plan';

# verify that 'to_common()' (converts Egyptian fractions to common) works
# correctly for all Rhind entries

use_ok('Math::Fraction::Egyptian','to_common');
require 't/rhind.pl';

for my $r (rhind()) {
    my ($denom, @e) = @$r;
    my @actual = to_common(@e);
    is_deeply(\@actual, [ 2, $denom ] ) or
        BAIL_OUT("got (@e) => $actual[0]/$actual[1], not 2/$denom");
}

