package Math::Fraction::Egyptian::Trivial;

use strict;
use warnings FATAL => 'all';

our $VERSION = '0.01';

=head1 NAME

Math::Fraction::Egyptian::Trivial - trivial expansion strategy

=head1 SYNOPSIS

    use Math::Fraction::Egyptian::Trivial;

=head1 DESCRIPTION

=cut

=head1 STRATEGIES

Fibonacci, in his Liber Abaci, identifies seven different methods for
converting common to Egyptian fractions:

=over 4

=item 1.

=item 2.

For small odd prime denominators p, the expansion 2/p = 2/(p + 1) + 2/p(p +
1) was used.

=item 3.

For larger prime denominators, an expansion of the form 2/p = 1/A +
(2A-p)/Ap was used, where A is a number with many divisors (such as a
practical number) in the range p/2 < A < p. The remaining term
(2A-p)/Ap was expanded by representing the number 2A-p as a sum of
divisors of A and forming a fraction d/Ap for each such divisor d in
this sum (Hultsch 1895, Bruins 1957). As an example, Ahmes' expansion
2/37 = 1/24 + 1/111 + 1/296 fits this pattern, with A = 24 and 2A-p =
11 = 3+8, since 3 and 8 are divisors of 24. There may be many
different expansions of this type for a given p; however, as K. S.
Brown observed, the expansion chosen by the Egyptians was often the
one that caused the largest denominator to be as small as possible,
among all expansions fitting this pattern.

=item 4.

For composite denominators, factored as p×q, one can expand 2/pq using the
identity 2/pq = 1/aq + 1/apq, where a = (p+1)/2. For instance, applying
this method for pq = 21 gives p = 3, q = 7, and a = (3+1)/2 = 2, producing
the expansion 2/21 = 1/14 + 1/42 from the Rhind papyrus. Some authors have
preferred to write this expansion as 2/A × A/pq, where A = p+1 (Gardner,
2002); replacing the second term of this product by p/pq + 1/pq, applying
the distributive law to the product, and simplifying leads to an expression
equivalent to the first expansion described here. This method appears to
have been used for many of the composite numbers in the Rhind papyrus
(Gillings 1982, Gardner 2002), but there are exceptions, notably 2/35,
2/91, and 2/95 (Knorr 1982).

=item 5.

One can also expand 2/pq as 1/pr + 1/qr, where r = (p+q)/2. For instance,
Ahmes expands 2/35 = 1/30 + 1/42, where p = 5, q = 7, and r = (5+7)/2 = 6.
Later scribes used a more general form of this expansion, n/pq = 1/pr +
1/qr, where r =(p + q)/n, which works when p + q is a multiple of n (Eves,
1953).

=item 6.

For some other composite denominators, the expansion for 2/pq has the form
of an expansion for 2/q with each denominator multiplied by p. For
instance, 95=5×19, and 2/19 = 1/12 + 1/76 + 1/114 (as can be found using
the method for primes with A = 12), so 2/95 = 1/(5×12) + 1/(5×76) +
1/(5×114) = 1/60 + 1/380 + 1/570 (Eves, 1953). This expression can be
simplified as 1/380 + 1/570 = 1/228 but the Rhind papyrus uses the
unsimplified form.

=item 7.

The final (prime) expansion in the Rhind papyrus, 2/101, does not fit any
of these forms, but instead uses an expansion 2/p = 1/p + 1/2p + 1/3p +
1/6p that may be applied regardless of the value of p. That is, 2/101 =
1/101 + 1/202 + 1/303 + 1/606. A related expansion was also used in the
Egyptian Mathematical Leather Roll for several cases.

=back

The strategies as implemented below have the following features in common:

=over 4

=item *

Each function call has a signature of the form C<I<strategy>($numerator,
$denominator)>.

=item *

The return value from a successful strategy call is the list C<($numerator,
$denominator, @egyptian)>: the new numerator, the new denominator, and
zero or more new Egyptian factors extracted from the input fraction.

=item *

Some strategies are not applicable to all inputs.  If the strategy
determines that it cannot determine the next number in the expansion, it
throws an exception (via C<die()>) to indicate the strategy is unsuitable.

=back

=cut

=head2 $class->expand($n,$d)

Strategy for dealing with "trivial" expansions--if C<$n> is C<1>, then this
fraction is already in Egyptian form.

Example:

    my @x = $class->expand(1,5);     # @x = (0,1,5)

=cut

sub expand {
    my ($class,$n,$d) = @_;
    if (defined($n) && $n == 1) {
        return (0,1,$d);
    }
    die "unsuitable strategy";
}

1;

