use strict;
use warnings;

#use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian');

local *greedy = \&Math::Fraction::Egyptian::greedy;

my @expansions = (
    [ 5, 121 => 25, 4, 3025 ],    # 5/121 => 1/25 + 4/3025
    [ 4, 13  => 4,  3, 52 ],      # 4/13 => 1/4 + 3/52
    [ 3, 52  => 18,  1, 468 ],      # 3/52 => 1/18 + 1/468
);

for my $i (0 .. $#expansions) {
    my ($n1, $d1, @correct) = @{ $expansions[$i] };
    my ($e, $n2, $d2) = @correct;
    my @actual = greedy($n1,$d1);
    is_deeply(
        \@actual,
        \@correct,
        "expanded $n1/$d1 to @actual, should be @correct"
    );
    my $x1 = $n1 / $d1;
    my $x2 = (1.0 / $e) + ($n2 / $d2);
    cmp_ok(abs($x1 - $x2), q(<), 1e-9);
}

