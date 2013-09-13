#!perl

use strict;
use warnings;
use mop;

use Test::More;

use React;

ok(mop::get_meta('React::Observer')->isa('mop::role'), '... Observer is a role');

done_testing;