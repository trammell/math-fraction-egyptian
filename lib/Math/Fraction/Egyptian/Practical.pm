package Math::Fraction::Egyptian::Practical;

use strict;
use warnings FATAL => 'all';
use List::Util qw/ first max /;
use Math::Fraction::Egyptian::Utils qw/ is_practical /;

=pod

=head1 NAME

Math::Fraction::Egyptian::Practical - Egyptian fractions via practical numbers

=head1 SYNOPSIS

    use Math::Fraction::Egyptian::Practical;
    my @e = Math::Fraction::Egyptian::Practical->expand(2,13);

=head1 DESCRIPTION

Ahmes uses the following expansion of 2/13 using the property of 8 * 13
being a practical number:

    (2/13) * (8/8) = 16/104
                   = (13 + 2 + 1)/104
                   = 1/8 + 1/52 + 1/104

When a solution with a smaller practical number exists:

    (2/13) * (6/6) = 12/78
                   = (6 + 3 + 2 + 1)/78
                   = 1/13 + 1/26 + 1/39 + 1/78

=head1 METHODS

=head2 $class->expand($numer,$denom)

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

By definition, all numbers N < P, where P is practical, can be represented as
a sum of distinct divisors of P.

=cut

sub expand {
    my ($class,$n,$d) = @_;

    # find the first integer $m that meets these criteria:
    #   => $d * $m is a practical number
    #   => $n * $m is greater than $d
    my $m = first { is_practical($_ * $d) and ($_ * $n > $d) } 1 .. $d;
    die "unsuitable strategy" unless $m;

    # break the numerator up into summands
    my @s = $class->summands($n * $m, $d * $m);
    return (0, 1, map { $d * $m / $_ } @s);
}

=head2 $class->summands($numer,$denom)



=cut

sub summands {
    my ($class,$num,$den) = @_;
    my @summands;
    my @divisors = reverse grep { $den % $_ == 0 } 1 .. $den;
    while ($num > 0) {
        my $div = shift @divisors;
        next if $div > $num;
        push @summands, $div;
        $num -= $div;
    }
    return @summands;
}





#sub expand {
#    my ($class,$N,$D) = @_;
#
#    # find multiples of $d that are practical numbers
#    my @mult = grep { is_practical($_ * $D) } 1 .. $D;
#
#    warn ">>> @mult";
#    die "unsuitable strategy" unless @mult;
#
#    MULTIPLE:
#    for my $M (@mult) {
#        my $n = $N * $M;
#        my $d = $D * $M;
#
#        # find the divisors of $d
#        my @div = grep { $d % $_ == 0 } 1 .. $d;
#
#        # expand $n into a sum of divisors of $d
#        my @N;
#        while ($n) {
#            next MULTIPLE unless @N;
#            @div = grep { $_ <= $n } @div;
#            my $x = max @div;
#            push @N, $x;
#            $n -= $x;
#            @div = grep { $_ < $x } @div;
#        }
#        my @e = map { $d / $_ } @N;
#
#        next MULTIPLE if $e[0] != $M;
#        next MULTIPLE if grep { $d % $_ } @e[1 .. $#e]; # FIXME
#
## o
##    4. As an observation a1, ..., ai were always divisors of the
##       denominator a of the first partition 1/a
#
#        return (0, 1, @e);
#    }
#    die "unsuitable strategy";
#}

1;
