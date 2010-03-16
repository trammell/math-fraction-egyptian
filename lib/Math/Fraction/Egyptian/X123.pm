package Math::Fraction::Egyptian::X123;
use strict;
use warnings FATAL => 'all';

=head1 NAME

Math::Fraction::Egyptian::X123 - "123" expansion strategy

=head1 SYNOPSIS

It's always possible to decompose a fraction C<2/n> as follows:

    2/n = 12 / 6n
        = 6/6n + 3/6n + 2/6n + 1/6n
        = 1/n + 1/2n + 1/3n + 1/6n

=head1 DESCRIPTION

=head2 $class->applies($n,$d)

=cut

sub applies {
    my ($class, $n, $d) = @_;
    return $n == 2;
}

=head2 $class->expand($n,$d)

Example:

    # the 123 expansion of 2/9 is:
    #   2/9 = 1/9 + 1/18 + 1/27 + 1/54

    my ($n,$d,@e) = greedy(2,9);
    print "$n/$d (@e)";     # prints "0/1 (9 18 27 54)"

=cut

sub expand {
    my ($class,$n,$d) = @_;
    return (0, 1, $n, 2 * $n, 3 * $n, 6 * $n);
}

1;

