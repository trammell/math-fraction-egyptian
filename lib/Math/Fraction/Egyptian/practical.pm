package Math::Fraction::Egyptian::practical;

use strict;
use warnings FATAL => 'all';
use List::Util qw(first max reduce);
use Math::Fraction::Egyptian 'primes';

my $PRACTICAL = {};

=head2 $class->expand($n,$d)

Attempts to find an integer multiplier C<$M> such that the scaled
denominator C<$M * $d> is a practical number.  This lets us decompose the
scaled numerator C<$M * $numer> as in this example:

    examining 2/9:

        9 is not a practical number
        however 2 * 9 = 18, a practical number
        choose $M = 2

    rewrite 2/9 as 4/18
        4/18 = 3/18 + 1/18
             = 1/6 + 1/18

By definition, all numbers N < P, where P is practical, can be represented
as a sum of distinct divisors of P.

=cut

sub expand {
    my ($class,$n,$d) = @_;

    # look for a multiple of $d that is a practical number
    my $M = first { is_practical($_ * $d) } 1 .. $d;
    die "unsuitable strategy" unless $M;

    $n *= $M;
    $d *= $M;

    my @divisors = grep { $d % $_ == 0 } 1 .. $d;

    my @N;
    my %seen;
    while ($n) {
        @divisors = grep { $_ <= $n } @divisors;
        my $x = max @divisors;
        push @N, $x;
        $n -= $x;
        @divisors = grep { $_ < $x } @divisors;
    }
    my @e = map { $d / $_ } @N;
    return (0, 1, @e);
}

=head2 is_practical($n)

Returns a true value if C<$n> is a practical number.

=cut

sub is_practical {
    my $n = shift;
    unless (exists $PRACTICAL->{$n}) {
        $PRACTICAL->{$n} = _is_practical($n);
    }
    return $PRACTICAL->{$n};
}

sub _is_practical {
    my $n = shift;
    return 1 if $n == 1;        # edge case
    return 0 if $n % 2 == 1;    # no odd practicals except 1
    my @pf = prime_factors($n);
    foreach my $i (1 .. $#pf) {
        my $p = $pf[$i][0];
        return 0 if ($p > 1 + sigma( @pf[0 .. $i-1]));
    }
    return 1;
}


=head2 prime_factors($n)

Returns the prime factors of C<$n> as a list of (prime,multiplicity) pairs.
The list is sorted by increasing prime number.

Example:

    my @pf = prime_factors(120);    # 120 = 2 * 2 * 2 * 3 * 5
    # @pf = ([2,3],[3,1],[5,1])

=cut

sub prime_factors {
    my $n = shift;
    my @primes = primes();
    my %pf;
    for my $i (0 .. $#primes) {
        my $p = $primes[$i];
        while ($n % $p == 0) {
            $pf{$p}++;
            $n /= $p;
        }
        last if $n == 1;
    }
    return unless $n == 1;
    return map { [ $_, $pf{$_} ] } sort { $a <=> $b } keys %pf;
}

=head2 sigma(@pairs)

Helper function for determining whether a number is "practical" or not.

=cut

sub sigma {
    # see http://en.wikipedia.org/wiki/Divisor_function
    my @pairs = @_;
    my $term = sub {
        my ($p,$a) = @_;
        return (($p ** ($a + 1)) - 1) / ($p - 1);
    };
    return reduce { $a * $b } map { $term->(@$_) } @pairs;
}

1;

