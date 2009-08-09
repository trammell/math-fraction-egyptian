package Math::Fraction::Egyptian::StrictPractical;

use strict;
use warnings FATAL => 'all';

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

1;

