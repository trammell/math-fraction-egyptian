package Math::Fraction::Egyptian;

use strict;
use warnings;
use POSIX 'ceil';

our $VERSION = '0.01';

=head1 NAME

Math::Fraction::Egyptian -

=head1 SYNOPSIS

    use Math::Fraction::Egyptian;

=head1 DESCRIPTION

From L<wikipedia|http://en.wikipedia.org/wiki/Egyptian_fractions>:

=over 4

An Egyptian fraction is the sum of distinct unit fractions, such as

    1/2 + 1/3 + 1/16

That is, each fraction in the expression has a numerator equal to 1 and a
denominator that is a positive integer, and all the denominators differ from
each other. The sum of an expression of this type is a positive rational number
C<a/b>; for instance the Egyptian fraction above sums to C<43/48>.

Every positive rational number can be represented by an Egyptian fraction. Sums
of this type, and similar sums also including C<2/3> and C<3/4> as summands,
were used as a serious notation for rational numbers by the ancient Egyptians,
and continued to be used by other civilizations into medieval times.

In modern mathematical notation, Egyptian fractions have been superseded by
L<vulgar fractions|http://en.wikipedia.org/wiki/Vulgar_fraction> and decimal
notation.  However, Egyptian fractions continue to be an object of study in
modern number theory and recreational mathematics, as well as in modern
historical studies of ancient mathematics.

=back

This module implements ...

=head1 FUNCTIONS

=head2 make_frac($numerator, $denominator)

=cut

sub make_frac {
    my ($n,$d) = @_;




}

=head2 greedy($x,$y)

Implements Fibonacci's greedy algorithm for computing Egyptian fractions:

    x/y =>  1/ceil(y/x) + (-y%x)/(y*ceil(y/x))

The return value 

Example:

    my ($g, $n, $d) = greedy(2,3);

=cut

sub greedy {
    my ($n,$d) = @_;
    my $c = ceil( $d / $n );
    return ($c, (-1 * $d) % $n, $d * $c);
}

=head2 GCD($x,$y)

Returns the Greatest Common Denominator of C<$x> and C<$y>.

=cut

sub GCD {
    my ($x, $y) = @_;
    return ($y) ? GCD($y, $x % $y) : $x;
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

