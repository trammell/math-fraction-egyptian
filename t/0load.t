use Test::More tests => 8;
use_ok('Math::Fraction::Egyptian');
my $v = $Math::Fraction::Egyptian::VERSION;
diag("\nTesting Math::Fraction::Egyptian, Version $v");
diag("Perl $], $^X");

use_ok('Math::Fraction::Egyptian::Composite');
use_ok('Math::Fraction::Egyptian::Greedy');
use_ok('Math::Fraction::Egyptian::Practical');
use_ok('Math::Fraction::Egyptian::Prime');
use_ok('Math::Fraction::Egyptian::Strategy');
use_ok('Math::Fraction::Egyptian::Trivial');
use_ok('Math::Fraction::Egyptian::Utils');

