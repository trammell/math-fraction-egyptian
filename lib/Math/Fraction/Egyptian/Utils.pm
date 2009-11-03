package Math::Fraction::Egyptian::Utils;

use strict;
use warnings FATAL => 'all';
use base 'Exporter';
use List::Util qw(first reduce max);

our @EXPORT_OK = qw( decompose GCD simplify primes );
our %EXPORT_TAGS = (all => \@EXPORT_OK);
my %PRIMES = map { $_ => undef } primes();

=head1 NAME

Math::Fraction::Egyptian::Utils - common Egyptian fraction utilities

=head1 SYNOPSIS

    use Math::Fraction::Egyptian::Utils ':all';



=head1 FUNCTIONS

=head2 GCD($x,$y)

Uses Euclid's algorithm to determine the greatest common denominator
("GCD") of integers C<$x> and C<$y>.  Returns the GCD, a positive integer.

=cut

sub GCD {
    my ($x, $y) = (int($_[0]), int($_[1]));
    return ($y) ? GCD($y, $x % $y) : $x;
}

=head2 simplify($n,$d)

Reduces fraction C<$n/$d> to simplest terms.  Returns a list containing two
values, the numerator and denominator.

Example:

    my @x = simplify(25,100);   # @x is (1,4)

=cut

sub simplify {
    my ($n, $d) = @_;
    my $gcd = GCD($n,$d);
    return ($n / $gcd, $d / $gcd);
}

=head2 primes()

Returns a list of all prime numbers below 1000.

=cut

sub primes {
    return qw(
        2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89
        97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179
        181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271
        277 281 283 293 307 311 313 317 331 337 347 349 353 359 367 373 379
        383 389 397 401 409 419 421 431 433 439 443 449 457 461 463 467 479
        487 491 499 503 509 521 523 541 547 557 563 569 571 577 587 593 599
        601 607 613 617 619 631 641 643 647 653 659 661 673 677 683 691 701
        709 719 727 733 739 743 751 757 761 769 773 787 797 809 811 821 823
        827 829 839 853 857 859 863 877 881 883 887 907 911 919 929 937 941
        947 953 967 971 977 983 991 997
    );
}

=head2 prime_factors($n)

Factors integer C<$n>.  Returns the prime factors of C<$n> as a list of
(prime,multiplicity) pairs.  The list is sorted by increasing prime number.

Example:

    my @pf = prime_factors(120);
    # Note: 120 = 2 * 2 * 2 * 3 * 5
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

=head2 decompose($n)

If C<$n> is a composite number, returns ($p,$q) such that:

    * $p != 1
    * $q != 1
    * $p x $q == $n

Otherwise, return list C<(1,$n)>.

=cut

sub decompose {
    my @pf = reverse map { ($_->[0]) x $_->[1] } prime_factors($_[0]);
    my ($p, $q) = (1, 1);
    for my $f (@pf) {
        if ($p < $q) { $p *= $f }
        else         { $q *= $f }
    }
    my @sorted = sort { $a <=> $b } $p, $q;
    return @sorted;
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

=head2 s_practical($n,$d)

Attempts to find a multiplier C<$M> such that the scaled denominator C<$M *
$d> is a practical number.  This lets us break up the scaled numerator C<$M
* $numer> as in this example:

    examining 2/9:
        9 * 2 is 18, and 18 is a practical number
        choose $M = 2

    scale 2/9 => 4/18
              =  3/18 + 1/18
              =  1/6 + 1/18

By definition, all numbers N < P, where P is practical, can be represented
as a sum of distinct divisors of P.

=cut

sub s_practical {
    my ($n,$d) = @_;

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

=head2 s_practical_strict($n,$d)




=cut

sub s_practical_strict {
    my ($N,$D) = @_;

    # find multiples of $d that are practical numbers
    my @mult = grep { is_practical($_ * $D) } 1 .. $D;

    die "unsuitable strategy" unless @mult;

    MULTIPLE:
    for my $M (@mult) {
        my $n = $N * $M;
        my $d = $D * $M;

        # find the divisors of $d
        my @div = grep { $d % $_ == 0 } 1 .. $d;

        # expand $n into a sum of divisors of $d
        my @N;
        while ($n) {
            next MULTIPLE unless @N;
            @div = grep { $_ <= $n } @div;
            my $x = max @div;
            push @N, $x;
            $n -= $x;
            @div = grep { $_ < $x } @div;
        }
        my @e = map { $d / $_ } @N;

        next MULTIPLE if $e[0] != $M;
        next MULTIPLE if grep { $d % $_ } @e[1 .. $#e]; # FIXME

# o
#    4. As an observation a1, ..., ai were always divisors of the
#       denominator a of the first partition 1/a

        return (0, 1, @e);
    }
    die "unsuitable strategy";
}

=head2 is_practical($n)

Returns a true value if C<$n> is a practical number.

=cut

my $_practical;
sub is_practical {
    my $n = shift;
    unless (exists $_practical->{$n}) {
        $_practical->{$n} = _is_practical($n);
    }
    return $_practical->{$n};
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


1;

