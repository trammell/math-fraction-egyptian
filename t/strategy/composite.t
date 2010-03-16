use strict;
use warnings FATAL => 'all';
use Test::More 'no_plan';
use Test::Exception;

use_ok('Math::Fraction::Egyptian::Composite');

local *composite = sub {
    Math::Fraction::Egyptian::Composite->expand(@_);
};

throws_ok { composite(2,11) } qr/unsuitable strategy/;

is_deeply([composite(2,21)],[0,1,14,42]);

