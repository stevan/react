#!perl

use strict;
use warnings;
use mop;

use Test::More;

use React;
use Test::React::Observer::Recorder;

ok(mop::get_meta('React::Observer')->isa('mop::role'), '... Observer is a role');

my $o = Test::React::Observer::Recorder->new;
ok($o->does('React::Observer'), '... the object does React::Observer role');

$o->on_next(10);
$o->on_next(20);
$o->on_next(30);

is_deeply( $o->values, [ 10, 20, 30 ], '... on_next worked as expected');

ok(!$o->is_completed, '... not completed yet');

$o->on_completed;

ok($o->is_completed, '... completed now');

$o->on_error("whoops");
$o->on_error("uh-oh");

is_deeply( $o->errors, [qw[ whoops uh-oh ]], '... got the errors we expected');

done_testing;