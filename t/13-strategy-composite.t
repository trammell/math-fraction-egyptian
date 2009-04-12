use strict;
use warnings;
use Data::Dumper;
use Test::More 'no_plan';
use Test::Exception;

use_ok('Math::Fraction::Egyptian');

local *strat_composite = \&Math::Fraction::Egyptian::strat_composite;

throws_ok { strat_composite(2,11) } qr/unsuitable strategy/;

is_deeply([strat_composite(2,21)],[0,1,14,42]);

__END__

For composite denominators, factored as p×q, one can expand 2/pq using the
identity 2/pq = 1/aq + 1/apq, where a = (p+1)/2. For instance, applying
this method for pq = 21 gives p = 3, q = 7, and a = (3+1)/2 = 2, producing
the expansion 2/21 = 1/14 + 1/42 from the Rhind papyrus.

