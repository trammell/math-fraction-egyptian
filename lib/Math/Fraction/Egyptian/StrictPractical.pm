package Math::Fraction::Egyptian::StrictPractical;

use strict;
use warnings FATAL => 'all';
use List::Util 'max';
use Math::Fraction::Egyptian::Utils 'is_practical';

=head1 NAME

Math::Fraction::Egyptian::StrictPractical - stricter usage of practical
numbers

=head1 SYNOPSIS

    use Math::Fraction::Egyptian::StrictPractical;
    my @e = Math::Fraction::Egyptian::StrictPractical->expand(2,13);

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

=cut

sub expand {
    my ($class,$N,$D) = @_;

    # find multiples of $d that are practical numbers
    my @mult = grep { is_practical($_ * $D) } 1 .. $D;

    warn ">>> @mult";
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

1;

