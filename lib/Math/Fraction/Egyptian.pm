package Math::Fraction::Egyptian;

use strict;
use warnings;
use base 'Exporter';
use List::Util 'first';

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

From L<Wikipedia|http://en.wikipedia.org/wiki/Egyptian_fractions>:

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
            my @result = eval {
                local $SIG{'__DIE__'} = undef;
                $s->($n,$d);
            };
            if ($@) {
                next STRATEGY;
            }
            else {
                ($n,$d) = @result[0,1];
                push @egypt, $result[2];
                last STRATEGY;
            }
        }
    }

    return @egypt;
}


=head2 to_common(@denominators)

Converts an Egyptian fraction into a common fraction.

Example:

    # determine 1/2 + 1/3 + 1/4 + 1/5
    my ($numer,$denom) = to_common(2,3,4,5);

=cut

sub to_common {
    my ($n,$d) = (0,1);
    for my $a (@_) {
        ($n, $d) = reduce($a * $n + $d, $a * $d);
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

=head2 reduce($n,$d)

Reduces fraction C<$n/$d> to simplest terms.

Example:

    my @x = reduce(100,25);   # @x is now (4,1)

=cut

sub reduce {
    my ($n, $d) = @_;
    my $gcd = GCD($n,$d);
    return ($n / $gcd, $d / $gcd);
}

=head2 is_practical($n)

Returns a true value if C<$n> is a practical number.

=cut

sub is_practical {
    my $n = shift;
    return unless $n % 2 == 0;
    my @f = _factors($n);
    return unless @f;
}

# returns a list of (prime, multiplicity) pairs for the input value
sub _factors {
    my $n = shift;
    my @primes = _primes();
    my %f;
    for my $i (0 .. $#primes) {
        my $p = $primes[$i];
        while ($n % $p == 0) {
            $f{$p}++;
            $n /= $p;
        }
        last if $n == 1;
    }
    return unless $n == 1;
    return map [$_, $f{$_}], sort { $a <=> $b } keys %f;
}

# returns a list of all prime numbers below 1000
sub _primes {
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
    );
}

my %PRIMES = map { $_ => 1 } _primes();

sub _practicals {
    return qw(
        1 2 4 6 8 12 16 18 20 24 28 30 32 36 40 42 48 54 56 60 64 66 72 78
        80 84 88 90 96 100 104 108 112 120 126 128 132 140 144 150 156 160
        162 168 176 180 192 196 198 200 204 208 210 216 220 224 228 234 240
        252 256 260 264 270 272 276 280 288 294 300 304 306 308 312 320 324
        330 336 340 342 348 352 360 364 368 378 380 384 390 392 396 400 408
        414 416 420 432 440 448 450 456 460 462 464 468 476 480 486 496 500
        504 510 512 520 522 528 532 540 544 546 552 558 560 570 576 580 588
        594 600 608 612 616 620 624 630 640 644 648 660 666 672 680 684 690
        696 700 702 704 714 720 726 728 736 740 744 750 756 760 768 780 784
        792 798 800 810 812 816 820 828 832 840 858 860 864 868 870 880 882
        888 896 900 912 918 920 924 928 930 936 952 960 966 968 972 980 984
        990 992 1000 1008 1014 1020 1024 1026 1032 1036 1040 1044 1050 1056
        1064 1080 1088 1092 1100 1104 1110 1116 1120 1122 1128 1134 1140
        1144 1148 1152 1160 1170 1176 1184 1188 1200 1204 1216 1218 1224
        1230 1232 1240 1242 1248 1254 1260 1272 1280 1288 1290 1296 1300
        1302 1312 1316 1320 1326 1332 1344 1350 1352 1360 1368 1372 1376
        1380 1386 1392 1400 1404 1408 1410 1416 1428 1440 1452 1456 1458
        1464 1470 1472 1476 1480 1482 1484 1488 1496 1500 1504 1512 1518
        1520 1530 1536 1540 1548 1554 1560 1566 1568 1584 1590 1596 1600
        1620 1624 1632 1638 1640 1650 1656 1664 1672 1674 1680 1692 1696
        1700 1710 1716 1720 1722 1728 1736 1740 1760 1764 1768 1770 1776
        1782 1792 1794 1800 1806 1820 1824 1830 1836 1840 1848 1856 1860
        1872 1880 1888 1890 1900 1904 1908 1914 1920 1932 1936 1944 1950
        1952 1960 1968 1974 1976 1980 1984 1998 2000 2010 2016 2024 2028
        2040 2046 2048 2052 2058 2064 2070 2072 2080 2088 2100 2106 2112
        2120 2124 2128 2130 2142 2156 2160 2176 2178 2184 2190 2196 2200
        2208 2214 2220 2226 2232 2240 2244 2250 2256 2262 2268 2280 2288
        2296 2300 2304 2310 2320 2322 2340 2352 2360 2368 2376 2380 2392
        2394 2400 2408 2412 2418 2420 2430 2432 2436 2440 2442 2448 2460
        2464 2478 2480 2484 2496 2500 2508 2520 2538 2544 2548 2550 2552
        2556 2560 2562 2574 2576 2580 2592 2600 2604 2610 2624 2628 2632
        2640 2646 2652 2660 2664 2680 2688 2700 2704 2706 2720 2728 2730
        2736 2744 2752 2754 2760 2772 2784 2790 2800 2808 2814 2816 2820
        2832 2838 2840 2844 2850 2856 2860 2862 2880 2886 2898 2900 2904
        2912 2916 2920 2928 2940 2944 2952 2960 2964 2968 2970 2976 2982
        2988 2992 3000 3008 3016 3024 3036 3040 3042 3060 3066 3072 3078
        3080 3096 3100 3102 3108 3120 3132 3136 3150 3160 3168 3180 3186
        3192 3198 3200 3204 3216 3220 3224 3234 3240 3248 3256 3264 3276
        3280 3294 3300 3304 3312 3318 3320 3328 3330 3332 3344 3348 3354
        3360 3366 3380 3384 3388 3392 3400 3402 3408 3416 3420 3432 3440
        3444 3450 3456 3468 3472 3480 3486 3498 3500 3504 3510 3520 3528
        3536 3540 3552 3560 3564 3570 3584 3588 3600 3608 3612 3618 3630
        3640 3648 3654 3660 3666 3672 3680 3690 3696 3700 3712 3720 3724
        3726 3738 3740 3744 3750 3752 3760 3762 3776 3780 3784 3792 3800
        3808 3816 3822 3828 3834 3840 3848 3864 3870 3872 3876 3888 3894
        3900 3904 3906 3920 3936 3942 3948 3952 3960 3968 3976 3978 3984
        3990 3996 4000 4004 4020 4026 4032 4048 4050 4056 4060 4074 4080
        4088 4092 4096 4100 4104 4116 4128 4134 4136 4140 4144 4158 4160
        4176 4180 4200 4212 4224 4230 4240 4248 4256 4260 4264 4266 4272
        4284 4288 4290 4300 4312 4320 4332 4340 4350 4352 4356 4368 4374
        4380 4392 4400 4410 4416 4420 4422 4424 4428 4440 4446 4452 4464
        4472 4480 4482 4488 4500 4508 4512 4524 4536 4544 4554 4560 4576
        4590 4592 4600 4602 4608 4620 4624 4640 4644 4648 4650 4656 4662
        4664 4672 4680 4686 4692 4698 4700 4704 4720 4732 4736 4740 4752
        4758 4760 4770 4784 4788 4800 4806 4816 4818 4824 4830 4836 4840
        4848 4860 4864 4872 4880 4884 4888 4896 4900 4914 4920 4928 4940
        4944 4950 4956 4960 4968 4980 4984 4992 4998 5000 5016 5022 5040
        5056 5060 5070 5076 5082 5088 5096 5100 5104 5112 5120 5124 5130
        5136 5148 5152 5160 5166 5168 5180 5184 5192 5200 5202 5208 5214
        5220 5226 5232 5236 5238 5244 5248 5250 5256 5264 5280 5292 5300
        5304 5310 5312 5320 5328 5340 5346 5360 5368 5376 5382 5400 5408
        5412 5418 5424 5432 5440 5454 5456 5460 5472 5478 5488 5490 5500
        5504 5508 5512 5520 5538 5544 5550 5562 5568 5580 5586 5600 5610
        5616 5628 5632 5640 5656 5664 5670 5676 5680 5684 5688 5694 5696
        5700 5712 5720 5724 5740 5742 5760 5768 5772 5776 5778 5780 5796
        5800 5808 5814 5820 5824 5832 5840 5850 5852 5856 5874 5880 5886
        5888 5896 5900 5904 5916 5920 5922 5928 5936 5940 5952 5964 5976
        5980 5984 5992 5994 6000 6006 6016 6020 6030 6032 6048 6060 6072
        6076 6080 6084 6090 6100 6102 6104 6120 6132 6136 6138 6144 6150
        6156 6160 6162 6174 6180 6188 6192 6200 6204 6208 6210 6216 6240
        6248 6256 6264 6270 6272 6300 6318 6320 6324 6328 6336 6344 6348
        6360 6372 6380 6384 6390 6396 6400 6402 6408 6420 6424 6426 6432
        6440 6448 6450 6460 6464 6468 6474 6480 6496 6498
    );
}

=head1 STRATEGIES


=cut

=head2 strategies()

Function call is of the form C<strategy($numer,$denom)>.

Returns a list of three or more integers: the new numerator, the new
denominator, and one or more new Egyptian factors.

Throws an exception via C<die()> if the strategy is unsuitable.

=cut

sub strategies {
    return (
        \&strat_trivial,
        \&strat_small_prime,
        \&strat_greedy,
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

For small odd prime denominators p, use the expansion:

    2/p = 2/(p + 1) + 2/p(p + 1)

=cut

sub strat_small_prime {
    my ($n,$d) = @_;
    if ($n == 2 && $d > 2 && $d < 50 && $PRIMES{$d}) {
        return (2, $d * ($d + 1), ($d + 1) / 2 );
    }
    else {
        die "unsuitable strategy";
    }
}

=head2 strat_practical($n,$d)

=cut

sub strat_practical {
    my ($n,$d) = @_;

    # look for a multiple of $d that is a practical number
    # e.g. 2/9 => 4/18 => 3/18 + 1/18 => 1/6 + 1/18

    my $p = first { is_practical($_) } map { $_ * $d } 2 .. $d;



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
    ($n, $d) = reduce((-1 * $d) % $n, $d * $e);
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

