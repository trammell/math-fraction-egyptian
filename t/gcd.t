use strict;
use warnings;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian::Utils',qw/ GCD simplify /);

is(GCD(7,11),1);
is(GCD(15,25),5);

is_deeply([simplify(7,11)],[7,11]);
is_deeply([simplify(15,25)],[3,5]);

