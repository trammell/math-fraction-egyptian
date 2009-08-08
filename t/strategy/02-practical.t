use strict;
use warnings;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian::practical');

local *practical = sub {
    Math::Fraction::Egyptian::practical->expand(@_);
};

is_deeply([practical(2,9)], [0,1,6,18], "2/9 => 0/1 + 1/6 + 1/18");

