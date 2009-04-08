package Math::Fraction::Egyptian;

use strict;
use warnings FATAL => 'all';
use base 'Exporter';
use List::Util qw(first reduce max);

our $DEBUG = undef;

our @EXPORT_OK = qw( to_egyptian to_common );

our %EXPORT_TAGS = (all => \@EXPORT_OK);

our $VERSION = '0.01';

=head1 NAME

Math::Fraction::Egyptian - construct Egyptian representations of fractions

=head1 SYNOPSIS

    use Math::Fraction::Egyptian ':all';
    my @e = to_egyptian(43, 48);  # returns 43/48 in Egyptian format
    my @v = to_common(2, 3, 16);  # returns 1/2 + 1/3 + 1/16 in common format

=head1 DESCRIPTION

From L<Wikipedia|http://en.wikipedia.org/wiki/Egyptian_fractions>:

=over 4

An Egyptian fraction is the sum of distinct unit fractions, such as

    1/2 + 1/3 + 1/16

That is, each fraction in the expression has a numerator equal to 1 and a
denominator that is a positive integer, and all the denominators differ
from each other. The sum of an expression of this type is a positive
rational number C<a/b>; for instance the Egyptian fraction above sums to
C<43/48>.

Every positive rational number can be represented by an Egyptian fraction.
Sums of this type, and similar sums also including C<2/3> and C<3/4> as
summands, were used as a serious notation for rational numbers by the
ancient Egyptians, and continued to be used by other civilizations into
medieval times.

In modern mathematical notation, Egyptian fractions have been superseded by
L<vulgar fractions|http://en.wikipedia.org/wiki/Vulgar_fraction> and
decimal notation.  However, Egyptian fractions continue to be an object of
study in modern number theory and recreational mathematics, as well as in
modern historical studies of ancient mathematics.

=back

This module implements a handful of strategies used by the ancient
Egyptians in ...

=head1 FUNCTIONS

=head2 to_egyptian($numer, $denom, %attr)

Converts fraction C<$numer/$denom> to its Egyptian representation.

Example:

=cut

sub to_egyptian {
    my ($n,$d,%attr) = @_;
    ($n,$d) = (int($n), int($d));

    # force numerator, denominator to be positive
    if ($n < 0) {
        warn "Taking absolute value of numerator";
        $n = abs($n);
    }
    if ($d < 0) {
        warn "Taking absolute value of denominator";
        $d = abs($d);
    }

    # handle improper fractions
    if ($n > $d) {
        my $n2 = $n % $d;
        warn "$n/$d is an improper fraction; expanding $n2/$d instead";
        $n = $n2;
    }

    # perform the expansion...

    my @egypt;

    while ($n != 0) {
        STRATEGY:
        for my $s (strategies()) {
            my ($name,$coderef) = @$s;
            my @result = eval {
                $coderef->($n,$d);
            };
            if ($@) {
                next STRATEGY;
            }
            else {
                my ($n2, $d2, @e2) = @result;
                warn "$n/$d => $n2/$d2 + [@e2] ($name)\n" if $DEBUG;
                ($n,$d) = ($n2,$d2);
                push @egypt, @e2;
                last STRATEGY;
            }
        }
    }

    return @egypt;
}


=head2 to_common(@denominators)

Converts an Egyptian fraction into a common fraction.

Example:

    # determine 1/2 + 1/5 + 1/11
    my ($numer,$denom) = to_common(2,5,11);
    # 87/110

=cut

sub to_common {
    my ($n,$d) = (0,1);
    for my $a (@_) {
        ($n, $d) = simplify($a * $n + $d, $a * $d);
    }
    return ($n,$d);
}

=head2 GCD($x,$y)

Uses Euclid's algorithm to determine the greatest common denominator ("GCD") of
C<$x> and C<$y>.  Returns the GCD.

=cut

sub GCD {
    my ($x, $y) = (int($_[0]), int($_[1]));
    return ($y) ? GCD($y, $x % $y) : $x;
}

=head2 simplify($n,$d)

Reduces fraction C<$n/$d> to simplest terms.

Example:

    my @x = simplify(100,25);   # @x is now (4,1)

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

my %PRIMES = map { $_ => 1 } primes();

=head2 prime_factors($n)

Returns a list of (prime,multiplicity) pairs for C<$n>, sorted by
magnitude.

Example:

    my @pf = prime_factors(120);
    # @pf = ([2,3],[3,1],[5,1]);

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

# see http://en.wikipedia.org/wiki/Divisor_function
sub sigma {
    my @pairs = @_;
    my $term = sub {
        my ($p,$a) = @_;
        return (($p ** ($a + 1)) - 1) / ($p - 1);
    };
    return reduce { $a * $b } map { $term->(@$_) } @pairs;
}

=head1 STRATEGIES

Fibonacci, in his Liber Abaci, identifies seven different methods for
converting common to Egyptian fractions.

The strategies as implemented below have the following features in common:

=over 4

=item *

Each function call is of the form C<I<strategy>($numer,$denom)>.

=item *

The return value from a successful strategy call is the list C<($numer,
$denom, @egypt)>: the new numerator, the new denominator, and one or more
new Egyptian factors extracted from the input fraction.

=item *

There's no guarantee that a strategy will apply to a given fraction.  If
the strategy determines that it cannot determine the next number in the
expansion, it throws an exception (via C<die()>) to indicate the strategy
is unsuitable.

=back

=cut

=head2 strategies()

Returns a list of strategies to apply to a given fraction.

=cut

sub strategies {
    return (
        [ trivial          => \&strat_trivial, ],
        [ small_prime      => \&strat_small_prime, ],
        [ practical_strict => \&strat_practical_strict, ],
        [ practical        => \&strat_practical, ],
        [ greedy           => \&strat_greedy, ],
    );
}

=head2 strat_trivial($n,$d)

If C<$n> is C<1>, then this fraction is already in Egyptian form.

=cut

sub strat_trivial {
    my ($n,$d) = @_;
    if (defined($n) && $n == 1) {
        return (0,1,$d);
    }
    else {
        die "unsuitable strategy";
    }
}

=head2 strat_small_prime($n,$d)

For a numerator of 2 with small odd prime denominators p, use the
expansion:

    2/p = 2/(p + 1) + 2/p(p + 1)

=cut

sub strat_small_prime {
    my ($n,$d) = @_;
    if ($n == 2 && $d > 2 && $d < 13 && $PRIMES{$d}) {
        return (2, $d * ($d + 1), ($d + 1) / 2 );
    }
    else {
        die "unsuitable strategy";
    }
}

sub strat_practical_strict {
    my ($N,$D) = @_;

    # find multiples of $d that are practical numbers
    my @multiples = grep { is_practical($_ * $D) } 1 .. $D;

    warn "mult = @multiples\n" if $DEBUG;

    die "unsuitable strategy" unless @multiples;

    MULTIPLE:
    for my $M (@multiples) {
        my $n = $N * $M;
        my $d = $D * $M;
        warn "trying M=$M, n=$n, d=$d\n" if $DEBUG;

        # find the divisors of $d
        my @div = grep { $d % $_ == 0 } 1 .. $d;
        warn " => divisors=(@div)\n" if $DEBUG;

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

o
    4. As an observation a1, ..., ai were always divisors of the
       denominator a of the first partition 1/a

        return (0, 1, @e);
    }
    die "unsuitable strategy";
}

=head2 strat_practical($numer,$denom)

Attempts to find a multiplier C<$M> such that C<$M * $denom> is a practical
number.  This lets us break up the scaled numerator C<$M * $numer> as in
the following example:

    2/9 => 9 * 2 is 18, a practical number

    2/9 = 2/9 * 2/2 = 4/18
                    = 3/18 + 1/18
                    = 1/6 + 1/18

=cut

sub strat_practical {
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

=head2 is_practical($n)

Returns a true value if C<$n> is a practical number.

=cut

my %practical;
sub is_practical {
    my $n = shift;
    unless (exists $practical{$n}) {
        $practical{$n} = _is_practical($n);
    }
    return $practical{$n};
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


=head2 strat_greedy($n,$d)

Implements Fibonacci's greedy algorithm for computing Egyptian fractions:

    n/d =>  1/ceil(d/n) + (-d%n)/(d*ceil(d/n))

The function returns a list of three integers: the new numerator, the new
denominator, and the next calculated value in the Egyptian expansion.

Example:

    # calculate the next term in the greedy expansion of 2/7

    my ($n,$d,$e) = greedy(2,7);

=cut

sub strat_greedy {
    use POSIX 'ceil';
    my ($n,$d) = @_;
    my $e = ceil( $d / $n );
    ($n, $d) = simplify((-1 * $d) % $n, $d * $e);
    return ($n, $d, $e);
}

=head1 AUTHOR

John Trammell, C<< <johntrammell <at> gmail <dot> com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-math-fraction-egyptian at
rt.cpan.org>, or through
the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-Fraction-Egyptian>.  I
will be notified, and then you'll automatically be notified of progress on your
bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::Fraction::Egyptian

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-Fraction-Egyptian>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Math-Fraction-Egyptian>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Math-Fraction-Egyptian>

=item * Search CPAN

L<http://search.cpan.org/dist/Math-Fraction-Egyptian/>

=back

=head1 ACKNOWLEDGEMENTS

Thanks to Project Euler, L<http://projecteuler.net/>, for stretching my mind
into obscure areas of mathematics.  C<:-)>

=head1 COPYRIGHT & LICENSE

Copyright 2008 John Trammell, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

