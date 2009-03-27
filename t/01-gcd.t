# $Id:$
# $Source:$

use strict;
use warnings;
use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian');

local *gcd = \&Math::Fraction::Egyptian::GCD;

is(gcd(7,11),1);
is(gcd(15,25),5);

local *reduce = \&Math::Fraction::Egyptian::reduce;

is_deeply([reduce(7,11)],[7,11]);
is_deeply([reduce(15,25)],[3,5]);

