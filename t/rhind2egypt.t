use strict;
use warnings FATAL => 'all';
use Test::More 'no_plan';
use_ok('Math::Fraction::Egyptian','to_egyptian');
require 't/rhind.pl';

# construct a list of strategy classes to apply
my @strategies = map "Math::Fraction::Egyptian::$_",
    qw/ Trivial Prime Composite Practical Greedy /;

# load the strategy classes at startup
for my $s (@strategies) {
    eval "use $s;";     ## no critic
    die $@ if $@;
    die unless $s->can('expand');
}

sub ahmet {
    my ($numer, $denom) = @_;
    my @egypt;

    STRATEGY:
    for my $s (@strategies) {
        my @result = eval { $s->expand($numer,$denom); };
        if ($@) {
            next STRATEGY if $@ =~ /unsuitable strategy/;
            die $@;
        }
        my ($n, $d, @e) = @result;
        ($numer,$denom) = ($n,$d);
        push @egypt, @e;
        last STRATEGY;
    }
    return $numer, $denom, @egypt;
}

sub apply_strategies {
    my ($n,$d,@strategies) = @_;
    STRATEGY:
    foreach my $s (@strategies) {
        my @result = eval { $s->expand($n,$d); };
        if ($@) {
            next STRATEGY if $@ =~ /unsuitable strategy/;
            die $@;
        }
        return @result;
    }
}

my %to_do = map { $_, 1 } qw/
    13 17 19
    25 29
    31 35 37
    41 43 45 47
    53 55 59
    61 63 65 67
    71 73 75 79
    81 83 85 89
    91 95 97 99
    101
/;


# verify that the common => Egyptian conversion is correct for all Rhind
# entries, except those in %to_do.

for my $r (rhind()) {
    my ($denom, @e) = @$r;
    my $description = do {
        local $, = q(,);
        "2/$denom => (@e)";
    };
    my @actual = to_egyptian(2,$denom,dispatch => \&ahmet);
    if ($to_do{$denom}) {
        TODO: {
            local $TODO = $description;
            is_deeply(\@actual, \@e, $description) or
                diag("got 2/$denom => (@actual), expected (@e)");
        }
    }
    else {
        is_deeply(\@actual, \@e, $description) or
            diag("got 2/$denom => (@actual), expected (@e)");
    }
}

