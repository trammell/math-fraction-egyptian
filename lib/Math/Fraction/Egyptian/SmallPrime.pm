package Math::Fraction::Egyptian::SmallPrime;

use strict;
use warnings FATAL => 'all';
use Math::Fraction::Egyptian 'primes';

our $VERSION = '0.01';

my %PRIMES = map { $_ => 1 } primes();

=head1 NAME

Math::Fraction::Egyptian::small_prime - construct Egyptian representations of fractions

=head1 SYNOPSIS

    use Math::Fraction::Egyptian ':all';
    my @e = to_egyptian(43, 48);  # returns 43/48 in Egyptian format
    my @v = to_common(2, 3, 16);  # returns 1/2 + 1/3 + 1/16 in common format

=head2 $class->expand($n,$d)

For a numerator of 2 with odd prime denominator d, one can use this
expansion:

    2/d = 2/(d + 1) + 2/d(d + 1)

=cut

sub expand {
    my ($class,$n,$d) = @_;
    if ($n == 2 && $d > 2 && $d < 30 && $PRIMES{$d}) {
        my $x = ($d + 1) / 2;
        return (0, 1, $x, $d * $x);
    }
    else {
        die "unsuitable strategy";
    }
}

1;

