use strict;
use warnings FATAL => 'all';
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian::StrictPractical');

local *sp = sub {
    Math::Fraction::Egyptian::StrictPractical->expand(@_);
};

is_deeply([sp(2,13)], [0,1,8,52,104], "2/13 => 0/1 + 1/8 + 1/52 + 1/104");

