use strict;
use warnings;
use Test::More 'no_plan';
use Test::Exception;

use_ok('Math::Fraction::Egyptian::SmallPrime');

local *small_prime = sub {
    Math::Fraction::Egyptian::SmallPrime->expand(@_);
};

# 2/p = 2/(p + 1) + 2/p(p + 1)
# the "small prime" algorithm does not apply to 3/10
throws_ok { small_prime(3,10) } qr/unsuitable strategy/,
    'input 3/10 should be rejected';

# 2/5 => 1/3 + 1/15
is_deeply([small_prime(2,5)],[0,1,3,15]);

# 2/11 => 2/12 + 2/(11)(12) = 0/1 + 1/6 + 1/66
is_deeply([small_prime(2,11)],[0,1,6,66]);

