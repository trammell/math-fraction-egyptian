use strict;
use warnings;
use ExtUtils::MakeMaker;

my %params = (
    NAME          => 'Math::Fraction::Egyptian',
    AUTHOR        => 'John Trammell <johntrammell@gmail.com>',
    VERSION_FROM  => 'lib/Math/Fraction/Egyptian.pm',
    ABSTRACT_FROM => 'lib/Math/Fraction/Egyptian.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'List::Util'      => 0,
        'Test::More'      => 0,
        'Test::Exception' => 0,
        'Test::Warn'      => 0,
    },
    dist => {
        COMPRESS => 'gzip -9f',
        SUFFIX => 'gz',
    },
    clean => {
        FILES => [ qw/ cover_db Debian_* Math-Fraction-Egyptian-* *.bak / ],
    },
    test => {
        TESTS => 't/*.t t/strategy/*.t',
    },
    LICENSE => 'perl',
);

# add coverage to makefile
sub MY::postamble {
    return "\ntestcover:\n\tcover -test\n\n";
}

WriteMakefile(%params);
