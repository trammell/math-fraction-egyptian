package Math::Fraction::Egyptian::Prime;

use strict;
use warnings FATAL => 'all';
use Math::Fraction::Egyptian::Utils 'primes';

my %PRIMES = map { $_ => 1 } primes();

=head1 NAME

Math::Fraction::Egyptian::Prime - construct Egyptian representations of
fractions with prime denominators

=head1 SYNOPSIS

    use Math::Fraction::Egyptian::Prime;
    @e = Math::Fraction::Egyptian::Prime->expand(13,23);

=head2 $class->expand($n,$d)

For a numerator of 2 with odd prime denominator d, one can use this
expansion:

    2/d = 2/(d + 1) + 2/d(d + 1)

=cut

sub expand {
    my ($class,$n,$d) = @_;
    if ($n == 2 && $d > 2 && $PRIMES{$d}) {
        my $x = ($d + 1) / 2;
        return (0, 1, $x, $d * $x);
    }
    else {
        die "unsuitable strategy";
    }
}

1;

