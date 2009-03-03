use strict;
use warnings;

#use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian','make_fraction');

my @tests = (
    [ 43, 48 => 2, 3, 16 ],     # 43/48 = 1/2 + 1/3 + 1/16
);

for my $i (0 .. $#tests) {
    my ($numer, $denom, @egypt) = @{ $tests[$i] };

    my @f = make_fraction($numer,$denom);

    is_deeply(
        [ sort { $a <=> $b } @f ],
        [ sort { $a <=> $b } @egypt ],
    );

}


