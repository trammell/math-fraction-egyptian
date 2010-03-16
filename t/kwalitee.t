use strict;
use warnings FATAL => 'all';
use Test::More;
eval "use Test::Kwalitee tests => ['-has_meta_yml'];";
warn $@ if $@;
plan(skip_all => 'Test::Kwalitee not installed; skipping') if $@;
