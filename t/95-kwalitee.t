use strict;
use warnings FATAL => 'all';
use Test::More;
eval "use Test::Kwalitee tests => '-have_meta_yml';";
plan(skip_all => 'Test::Kwalitee not installed; skipping') if $@;
