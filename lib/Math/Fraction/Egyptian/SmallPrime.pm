package Math::Fraction::Egyptian::SmallPrime;

use strict;
use warnings FATAL => 'all';
use Math::Fraction::Egyptian::Utils 'primes';

my %PRIMES = map { $_ => 1 } grep { $_ < 35 } primes();

=head1 NAME

Math::Fraction::Egyptian::SmallPrime - construct Egyptian representations
of fractions

=head1 SYNOPSIS

    use Math::Fraction::Egyptian::SmallPrime;
    @e = Math::Fraction::Egyptian::SmallPrime->expand(13,21);

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

