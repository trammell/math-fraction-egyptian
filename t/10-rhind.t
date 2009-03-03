# $Id:$
# $Source:$

use strict;
use warnings;

package main;
use Data::Dumper;
use Test::More 'no_plan';

use_ok('Math::Fraction::Egyptian','expand');

# these test values come from the Rhind Mathematical Papyrus; see e.g.
# http://rmprectotable.blogspot.com/2008/07/rmp-2n-table.html

my @tests = (
    [ 2, 5 => 3, 15 ],      # 2/5 => 1/3 + 1/15
    [ 2, 7 => 4, 28 ],
    [ 2, 9 => 4, 28 ],
    [ 2, 11 => 4, 28 ],
    [ 2, 13 => 4, 28 ],
    [ 2, 15 => 4, 28 ],
    [ 2, 17 => 4, 28 ],
    [ 2, 19 => 4, 28 ],
);

for my $i (0 .. $#tests) {
    my ($num, $den, @correct) = @{ $tests[$i] };
    my @actual = expand($num, $den);
    is_deeply(
        \@actual,
        \@correct,
        "incorrectly expanded $num/$den to @actual -- should be @correct"
    );
}



# 2/5 = 2/5*(3/3) = (5 + 1)/15 = 1/3 + 1/15                                                       
# 2/7 = 2/7*(4/4) = (7 + 1)/28 = 1/4 + 1/28                                                       
# 2/9 = 2/9*(2/2) = (3 + 1)/18 = 1/6 + 1/18                                                       
# 2/11 = 2/11*(6/6) = (11 + 1)/66 = 1/6 + 1/66                                                    
# 2/13 = 2/13*(8/8) = (13 + 2 + 1)/104 = 1/8 + 1/52 + 1/104                                       
# 2/15 = 2/15*(2/2) = (3 + 1)/30 = 1/10 + 1/30                                                    
# 2/17 = 2/17*(12/12) = (17 + 4 + 3)/204 = 1/12 + 1/51 + 1/68                                     
# 2/19 = 2/17*(12/12) = (19 + 3 + 2)/228 = 1/12 + 1/76 + 1/114    


