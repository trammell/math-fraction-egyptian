use strict;
use warnings;

#use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian','to_egyptian');

my @tests = (
    [ 43, 48 => 2, 3, 16 ],     # 43/48 = 1/2 + 1/3 + 1/16
);

for my $i (0 .. $#tests) {
    my ($n, $d, @correct) = @{ $tests[$i] };
    my @actual = to_egyptian($n,$d);
    is_deeply( \@actual, \@correct );
}

