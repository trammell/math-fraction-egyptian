use strict;
use warnings;

#use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian');

my $greedy = sub { return Math::Fraction::Egyptian::greedy(@_); };

{
    my ($n,$d,$e) = $greedy->(5,121);
    warn "$n $d $e";
}

{
    my ($n,$d,$e) = $greedy->(4,13);
    warn "4/13 => 1/$e + $n/$d";
}

