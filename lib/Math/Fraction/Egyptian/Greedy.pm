package Math::Fraction::Egyptian::Greedy;
use strict;
use warnings FATAL => 'all';

=pod

=head1 NAME

Math::Fraction::Egyptian::Greedy - "greedy" expansion strategy

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 $class->expand($n,$d)

Implements Fibonacci's greedy algorithm for computing Egyptian fractions:

    n/d => 1 / ceil(d/n) + ((-d) % n)/(d * ceil(d/n))

1. find the largest integer C<j> such that (1 / j) is not greater than
C<n/d>.

2. calculate the remainder R: (n/d) - (1/j)

    n/d  =  1/j + R

    R = n/d - 1/j
      = n/d - 1/ceil(d/n)
      = nj/dj - d/dj
      = (nj-d) / dj

      n * ceil(d/n) - d

Example:

    # performing the greedy expansion of 3/7:
    #   ceil(7/3) = 3
    #   new numerator = (-7)%3 = 2
    #   new denominator = 7 * 3 = 21
    # so 3/7 => 1/3 + 2/21

    my ($n,$d,$e) = greedy(2,7);
    print "$n/$d ($e)";     # prints "2/21 (3)"

=cut

use Math::Fraction::Egyptian 'simplify';
use POSIX 'ceil';

sub expand {
    my ($class,$n,$d) = @_;
    my $e = ceil( $d / $n );
    ($n, $d) = simplify(($n - $d) % $n, $d * $e);
    return ($n, $d, $e);
}

1;

