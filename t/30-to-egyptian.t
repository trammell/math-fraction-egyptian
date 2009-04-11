use strict;
use warnings;

#use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian','to_egyptian');

is_deeply( [ to_egyptian(0,1) ], []);
is_deeply( [ to_egyptian(0,3) ], []);
is_deeply( [ to_egyptian(0,4) ], []);
is_deeply( [ to_egyptian(1,3) ], [3]);
is_deeply( [ to_egyptian(1,4) ], [4]);

# 43/48 = 1/2 + 1/3 + 1/16
is_deeply( [ to_egyptian(43,48) ], [2,3,16]);

