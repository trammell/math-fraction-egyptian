use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Math::Fraction::Egyptian',
    AUTHOR              => 'John Trammell <johntrammell <at> gmail <dot> com>',
    VERSION_FROM        => 'lib/Math/Fraction/Egyptian.pm',
    ABSTRACT_FROM       => 'lib/Math/Fraction/Egyptian.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => [ 'Math-Fraction-Egyptian-*', '*.bak' ]},
);

