package Math::Fraction::Egyptian::Composite;

use strict;
use warnings FATAL => 'all';
use Math::Fraction::Egyptian::Utils qw/ decompose primes /;

my %PRIMES = map { $_ => undef } primes();

=pod

=head1 NAME

s_composite($n,$d)

From L<http://en.wikipedia.org/wiki/Egyptian_fraction>:

=over 4

For composite denominators, factored as p×q, one can expand 2/pq using the
identity 2/pq = 1/aq + 1/apq, where a = (p+1)/2.  Clearly p must be odd.

For instance, applying this method for d = pq = 21 gives p=3, q=7, and
a=(3+1)/2=2, producing the expansion 2/21 = 1/14 + 1/42.

=back

=cut

sub expand {
    my ($class,$n,$d) = @_;
    die "unsuitable strategy" if exists $PRIMES{$d};
    my ($p,$q) = decompose($d);

    # is $p odd
    if ($p % 2 == 1) {
        my $a = ($p + 1) / 2;
        return (0, 1, $a * $q, $a * $p * $q);
    }

    # is $q odd
    if ($q % 2 == 1) {
        my $a = ($q + 1) / 2;
        return (0, 1, $a * $p, $a * $p * $q);
    }

    die "unsuitable strategy";
}

1;

