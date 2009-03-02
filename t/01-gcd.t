# $Id:$
# $Source:$

use strict;
use warnings;

package main;
use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian');

local *gcd = \&Math::Fraction::Egyptian::GCD;

is(gcd(7,11),1);
is(gcd(15,25),5);

