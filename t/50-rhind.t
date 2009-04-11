use strict;
#use warnings;
use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian','to_egyptian');

sub dispatch {



}


# these test values come from the Rhind Mathematical Papyrus; see e.g.
# http://rmprectotable.blogspot.com/2008/07/rmp-2n-table.html

is_deeply([to_egyptian(2,5)], [3,15], '2/5 => (3,15)');
is_deeply([to_egyptian(2,7)], [4,28], '2/7 => (4,28)');
is_deeply([to_egyptian(2,9)], [6,18], '2/7 => (6,18)');
is_deeply([to_egyptian(2,11)], [6,66], '2/11 => (6,66)');

TODO: {
    local $TODO = "2/13 => 8,52,104";
    local $Math::Fraction::Egyptian::DEBUG = 1;
    is_deeply([ to_egyptian(2,13) ], [ 8, 52, 104 ], "2/13 => 8,52,104" );
}

is_deeply([to_egyptian(2,15)], [10,30], '2/15 => (10,30)');
is_deeply([to_egyptian(2,17)], [12,51,68], '2/17 => (12,51,68)');
is_deeply([to_egyptian(2,19)], [12,76,114], '2/19 => (12,76,114)');

