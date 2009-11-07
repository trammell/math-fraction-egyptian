use strict;
use warnings FATAL => 'all';
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian::Greedy');

local *greedy = sub {
    Math::Fraction::Egyptian::Greedy->expand(@_);
};

my @expansions = (
    [ 2, 7   => 1, 28, 4 ],         # 2/7   => 1/28 + 1/4
    [ 3, 7   => 2, 21, 3 ],         # 3/7   => 2/21 + 1/3
    [ 3, 52  => 1, 468, 18 ],       # 3/52  => 1/468 + 1/18
    [ 4, 13  => 3, 52, 4 ],         # 4/13  => 3/52 + 1/4
    [ 5, 121 => 4, 3025, 25 ],      # 5/121 => 4/3025 + 1/25

    # 17/29 => 5/58 + 1/2 => 1/348 + 1/12 + 1/2
    [ 17, 29 => 5, 58, 2 ],
    [ 5, 58  => 1, 348, 12 ],
);

for my $i (0 .. $#expansions) {
    my ($n1, $d1, @correct) = @{ $expansions[$i] };
    my ($n2, $d2, $e) = @correct;
    my @actual = greedy($n1,$d1);
    is_deeply(\@actual, \@correct, "$n1/$d1 => (@correct)") or
        diag("expanded $n1/$d1 to @actual, should be @correct");
    my $x1 = $n1 / $d1;
    my $x2 = (1.0 / $e) + ($n2 / $d2);
    cmp_ok(abs($x1 - $x2), q(<), 1e-9);
}

