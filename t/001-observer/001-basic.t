#!perl

use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use Test::More;

use React;

can_ok('React::Observer', $_) foreach qw[ on_next on_completed on_error ];

done_testing;
