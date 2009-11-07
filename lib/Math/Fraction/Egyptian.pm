package Math::Fraction::Egyptian;

use strict;
use warnings FATAL => 'all';
use base 'Exporter';
use Math::Fraction::Egyptian::Utils 'simplify';

our $VERSION     = '0.01';
our @EXPORT_OK   = qw/ to_egyptian to_common /;
our %EXPORT_TAGS = (all => \@EXPORT_OK);

=pod

=head1 NAME

Math::Fraction::Egyptian - construct Egyptian representations of fractions

=head1 SYNOPSIS

    use Math::Fraction::Egyptian ':all';
    my @e = to_egyptian(43, 48);  # returns 43/48 in Egyptian format
    my @v = to_common(2, 3, 16);  # returns 1/2 + 1/3 + 1/16 in common format

=head1 DESCRIPTION

From L<http://en.wikipedia.org/wiki/Egyptian_fractions>:

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
vulgar fractions (see e.g. L<http://en.wikipedia.org/wiki/Vulgar_fraction>)
and decimal notation.  However, Egyptian fractions continue to be an object
of study in modern number theory and recreational mathematics, as well as
in modern historical studies of ancient mathematics.

=back

A common fraction has an infinite number of different Egyptian fraction
representations.  This package implements a selection of conversion
strategies for conversion of common fractions to Egyptian form; see section
L<STRATEGIES> below for details.

=head1 FUNCTIONS

=head2 to_egyptian($numer, $denom, %attr)

Converts fraction C<$numer/$denom> to its Egyptian representation.

Example:

    my @egypt = to_egyptian(5,9);   # converts 5/9 to 1/2 + 1/18
    print "@egypt";                 # prints "2 18"

=cut

sub to_egyptian {
    my ($n,$d,%attr) = @_;
    ($n,$d) = (abs(int($n)), abs(int($d)));
    $attr{dispatch} ||= \&mfe_dispatch;

    # handle 1/0 gracefully
    if ($d == 0) {
        die "can't convert $n/$d";
    }

    # handle improper fractions gracefully
    if ($n >= $d) {
        $_ = $n % $d;
        warn "$n/$d is an improper fraction; expanding $_/$d instead";
        $n = $_;
    }

    # attempt to convert the fraction
    my @egypt;
    while ($n && $n != 0) {
        ($n, $d, my @e) = $attr{dispatch}->($n,$d);
        push @egypt, @e;
    }
    return @egypt;
}

=head2 mfe_dispatch($numer,$denom)

Default strategy dispatcher for function C<to_egyptian>.  The following
strategies are attempted, in this order:

    Trivial
    Prime
    Practical
    Greedy

The result of the first applicable strategy is returned.

=cut

sub mfe_dispatch {
    my ($numer, $denom) = @_;
    my @egypt;

    # construct a list of strategy classes to apply
    my @strategies = map "Math::Fraction::Egyptian::$_", qw(
        Trivial
        Prime
        Practical
        Greedy
    );

    STRATEGY:
    for my $s (@strategies) {
        eval "use $s;";     ## no critic
        die $@ if $@;
        unless ($s->can('expand')) {
            warn "Skipping bad strategy class '$s'\n";
            next STRATEGY;
        }
        my @result = eval { $s->expand($numer,$denom); };
        next STRATEGY if $@;
        my ($n, $d, @e) = @result;
        ($numer,$denom) = ($n,$d);
        push @egypt, @e;
        last STRATEGY;
    }
    return $numer, $denom, @egypt;
}

=head2 to_common(@denominators)

Converts an Egyptian fraction into a common fraction, expressed in simplest
terms.

Example:

    my ($num,$den) = to_common(2,5,11);     # 1/2 + 1/5 + 1/11 = ?
    print "$num/$den";                      # prints "87/110"

=cut

sub to_common {
    my ($n,$d) = (0,1);
    for my $a (@_) {
        ($n, $d) = simplify($a * $n + $d, $a * $d);
    }
    return ($n,$d);
}



=head1 STRATEGIES

The following classes implement distinct strategies for converting common
fractions to Egyptian fractions:

=over 4

=item L<Math::Fraction::Egyptian::Trivial>

=item L<Math::Fraction::Egyptian::Greedy>

=item L<Math::Fraction::Egyptian::Practical>

=item Math::Fraction::Egyptian::StrictPractical

=item Math::Fraction::Egyptian::Composite

=item Math::Fraction::Egyptian::Prime

=back

=head2

The strategies as implemented below have the following features in common:

=over 4

=item *

Each function call has a signature of the form
C<I<$class>-E<gt>>expand($numerator,$denominator)>.

=item *

The return value from a successful strategy call is the list C<($numerator,
$denominator, @egyptian)>: the new numerator, the new denominator, and
zero or more new Egyptian factors extracted from the input fraction.

=item *

Some strategies are not applicable to all inputs.  If the strategy
determines that it cannot determine the next number in the expansion, it
throws an exception (via C<die()>) to indicate the strategy is unsuitable.

=back




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

=head1 AUTHOR

John Trammell, C<< <johntrammell <at> gmail <dot> com> >>

=head1 BUGS

Please report any bugs or feature requests to C<<
bug-math-fraction-egyptian at rt.cpan.org >>, or through the web interface
at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-Fraction-Egyptian>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::Fraction::Egyptian

You can also look for information at:

=over 4

=item * GitHub

L<http://github.com/trammell/math-fraction-egyptian>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-Fraction-Egyptian>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Math-Fraction-Egyptian>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Math-Fraction-Egyptian>

=item * Search CPAN

L<http://search.cpan.org/dist/Math-Fraction-Egyptian/>

=back

=head1 RESOURCES

=over 4

=item L<http://en.wikipedia.org/wiki/Category:Egyptian_fractions>

=item L<http://en.wikipedia.org/wiki/Common_fraction>

=item L<http://en.wikipedia.org/wiki/Rhind_Mathematical_Papyrus>

=item L<http://en.wikipedia.org/wiki/RMP_2/n_table>

=item L<http://en.wikipedia.org/wiki/Liber_Abaci>

=item L<http://en.wikipedia.org/wiki/Egyptian_fraction>

=item L<http://mathpages.com/home/kmath340/kmath340.htm>

=item L<http://mathworld.wolfram.com/RhindPapyrus.html>

=item L<http://liberabaci.blogspot.com/>

=back

=head1 ACKNOWLEDGEMENTS

Thanks to Project Euler, L<http://projecteuler.net/>, for stretching my mind
into obscure areas of mathematics.  C<< ;-) >>

=head1 COPYRIGHT & LICENSE

Copyright 2008 John Trammell, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

