use Test::More tests => 1;
use_ok('Math::Fraction::Egyptian');
my $v = $Math::Fraction::Egyptian::VERSION;
diag("\nTesting Math::Fraction::Egyptian, Version $v");
diag("Perl $], $^X");
