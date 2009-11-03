use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

use_ok('Math::Fraction::Egyptian::Trivial');

local *trivial = sub {
    Math::Fraction::Egyptian::Trivial->expand($_[0],$_[1]);
};

# 1/9 expands trivially to 0/1 + 1/9
is_deeply([trivial(1,9)],[0,1,9]);

# the "trivial" algorithm does not apply to 2/9
throws_ok { trivial(2,9) } qr/unsuitable strategy/;

