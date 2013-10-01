#!perl

use strict;
use warnings;
use mop;

use Test::More;

use React;

my $meta = mop::meta('React::Subject');
ok($meta->isa('mop::class'), '... React::Subject is a class');
ok($meta->is_abstract, '... React::Subject is an abstract class');
is($meta->superclass, 'React::Observable', '... React::Subject is a subclass of React::Observable');
ok($meta->does_role('React::Observer'), '... React::Subject does the React::Observer role');

done_testing;