use strict;
use warnings;
use Test::More 'no_plan';
use Test::Exception;
use Test::Warn;

use_ok('Math::Fraction::Egyptian','to_egyptian');

# test normal behavior
is_deeply([ to_egyptian(0,1) ], [], '0/1 => ()');
is_deeply([ to_egyptian(0,3) ], [], '0/3 => ()');
is_deeply([ to_egyptian(0,4) ], [], '0/4 => ()');
is_deeply([ to_egyptian(1,3) ], [3], '1/3 => (3)');
is_deeply([ to_egyptian(1,4) ], [4], '1/4 => (4)');

# test examples in POD:
#   * 43/48 => 1/2 + 1/3 + 1/16
#   * 5/9 = 1/2 + 1/18

is_deeply([ to_egyptian(43,48) ], [2,3,16], '43/48 => (2,3,16)')
    or diag("to_egyptian(43,48) => [@{[ to_egyptian(43,48) ]}]");

is_deeply([ to_egyptian(5,9) ], [2,18], '5/9 => (2,18)')
    or diag("to_egyptian(5,9) => [@{[ to_egyptian(5,9) ]}]");

# test input that is an improper fraction
{
    my @e;
    warning_like { @e = to_egyptian(1,1) } qr{1/1 is an improper},
        'correct warning from 1/1';
    is_deeply(\@e,[],'improper fraction 1/1 handled correctly');
}

{
    my @e;
    warning_like { @e = to_egyptian(4,3) } qr{4/3 is an improper},
        'correct warning from 4/3';
    is_deeply(\@e,[3],'improper fraction 4/3 handled correctly');
}


#is_deeply([ to_egyptian(4,3) ], [3]);
#is_deeply([ to_egyptian(1,1) ], []);

# test exceptions
dies_ok { to_egyptian(1,0) } qr{cannot convert fraction 1/0};

dies_ok { to_egyptian(1,0) } qr{cannot convert fraction 1/0};

# test dispatcher
my $ded = sub { die 'dies' };
dies_ok { to_egyptian(1,0, dispatcher => $ded) } qr{dies};

