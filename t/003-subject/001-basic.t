#!perl

use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use Test::More;

use React;

isa_ok('React::Subject', 'React::Observable');
ok(React::Subject->roles::DOES('React::Observer'), '... React::Subject does the React::Observer role');

done_testing;
