package Math::Fraction::Egyptian;

use strict;
use warnings;
use base 'Exporter';
use POSIX 'ceil';

our @EXPORT_OK = qw( to_egyptian to_common );

our %EXPORT_TAGS = (all => \@EXPORT_OK);

our $VERSION = '0.01';

=head1 NAME

Math::Fraction::Egyptian - construct Egyptian representations of common fractions

=head1 SYNOPSIS

    use Math::Fraction::Egyptian ':all';
    my @e = to_egyptian(43, 48);  # returns 43/48 in Egyptian format
    my @v = to_common(2, 3, 16);  # returns 1/2 + 1/3 + 1/16 in common format

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

=head2 to_egyptian($numerator, $denominator, %attr)

Converts fraction C<$numerator/$denominator> to its Egyptian representation.

=cut

sub to_egyptian {
    my $n = shift;
    my $d = shift;
    my %attr = @_;

    my @e;

    while (1) {
        if ($n == 1) {
            push @e, $d;
            last;
        }
        (my $term, $n, $d) = greedy($n,$d);
        push @e, $term;
    }

    return @e;
}

=head2 to_common(@denominators)

=cut

sub to_common {
    my ($n,$d) = (0,1);
    for my $a (@_) {
        ($n, $d) = simplify($a * $n + $d, $a * $d);
    }
    return ($n,$d);
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
    my $e = ceil( $d / $n );
    ($n, $d) = simplify((-1 * $d) % $n, $d * $e);
    return ($e, $n, $d);
}

=head2 GCD($x,$y)

Returns the Greatest Common Denominator of C<$x> and C<$y>.

=cut

sub GCD {
    my ($x, $y) = @_;
    return ($y) ? GCD($y, $x % $y) : $x;
}

=head2 simplify($x,$y)

Example:

    my @x = simplify(100,25);   # @x is now (4,1)

=cut

sub simplify {
    my ($n, $d) = @_;
    my $gcd = GCD($n,$d);
    return ($n / $gcd, $d / $gcd);
}

sub is_practical {
    my $n = shift;

}

sub factors {
    my $n = shift;

}

sub primes {
    return qw(
        2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
        101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191
        193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283
        293 307 311 313 317 331 337 347 349 353 359 367 373 379 383 389 397 401
        409 419 421 431 433 439 443 449 457 461 463 467 479 487 491 499 503 509
        521 523 541 547 557 563 569 571 577 587 593 599 601 607 613 617 619 631
        641 643 647 653 659 661 673 677 683 691 701 709 719 727 733 739 743 751
        757 761 769 773 787 797 809 811 821 823 827 829 839 853 857 859 863 877
        881 883 887 907 911 919 929 937 941 947 953 967 971 977 983 991 997
        1009 1013 1019 1021 1031 1033 1039 1049 1051 1061 1063 1069 1087 1091
        1093 1097 1103 1109 1117 1123 1129 1151 1153 1163 1171 1181 1187 1193
        1201 1213 1217 1223 1229 1231 1237 1249 1259 1277 1279 1283 1289 1291
        1297 1301 1303 1307 1319 1321 1327 1361 1367 1373 1381 1399 1409 1423
        1427 1429 1433 1439 1447 1451 1453 1459 1471 1481 1483 1487 1489 1493
        1499 1511 1523 1531 1543 1549 1553 1559 1567 1571 1579 1583 1597 1601
        1607 1609 1613 1619 1621 1627 1637 1657 1663 1667 1669 1693 1697 1699
        1709 1721 1723 1733 1741 1747 1753 1759 1777 1783 1787 1789 1801 1811
        1823 1831 1847 1861 1867 1871 1873 1877 1879 1889 1901 1907 1913 1931
        1933 1949 1951 1973 1979 1987 1993 1997 1999
    );
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

