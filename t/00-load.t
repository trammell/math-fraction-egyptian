#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Math::Fraction::Egyptian' );
}

diag( "Testing Math::Fraction::Egyptian $Math::Fraction::Egyptian::VERSION, Perl $], $^X" );
