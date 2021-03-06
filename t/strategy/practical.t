use strict;
use warnings FATAL => 'all';
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian::Practical');

local *practical = sub {
    Math::Fraction::Egyptian::Practical->expand(@_);
};

is_deeply([practical(2,9)], [0,1,6,18], "2/9 => 0/1 + 1/6 + 1/18");
is_deeply([practical(2,13)], [0,1,8,52,104], "2/13 => 0/1 + 1/8 + 1/52 + 1/104");

