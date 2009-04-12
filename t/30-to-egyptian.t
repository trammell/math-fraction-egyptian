use strict;
use warnings;
use Test::More 'no_plan';
use Test::Exception;

use_ok('Math::Fraction::Egyptian','to_egyptian');


# test normal behavior
is_deeply([ to_egyptian(0,1) ], []);
is_deeply([ to_egyptian(0,3) ], []);
is_deeply([ to_egyptian(0,4) ], []);
is_deeply([ to_egyptian(1,3) ], [3]);
is_deeply([ to_egyptian(1,4) ], [4]);
is_deeply([ to_egyptian(43,48) ], [2,3,16]);   # 43/48 = 1/2 + 1/3 + 1/16

# test improper fraction
is_deeply([ to_egyptian(4,3) ], [3]);
is_deeply([ to_egyptian(1,1) ], []);

# test exceptions
dies_ok { to_egyptian(1,0) } qr{cannot convert fraction 1/0};

dies_ok { to_egyptian(1,0) } qr{cannot convert fraction 1/0};

# test dispatcher
my $ded = sub { die 'dies' };
dies_ok { to_egyptian(1,0, dispatcher => $ded) } qr{dies};

