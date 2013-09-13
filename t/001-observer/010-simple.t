#!perl

use strict;
use warnings;
use mop;

use Test::More;

use React;
use React::Observer::Simple;

my (@values, @errors, $is_completed);

my $o = React::Observer::Simple->new(
    on_next      => sub { push @values => shift },
    on_completed => sub { $is_completed = 1     },
    on_error     => sub { push @errors => shift },
);
isa_ok($o, 'React::Observer::Simple');
ok($o->does('React::Observer'), '... the object does React::Observer role');

$o->on_next(10);
$o->on_next(20);
$o->on_next(30);

is_deeply( \@values, [ 10, 20, 30 ], '... on_next worked as expected');

ok(!$is_completed, '... not completed yet');

$o->on_completed;

ok($is_completed, '... completed now');

$o->on_error("whoops");
$o->on_error("uh-oh");

is_deeply( \@errors, [qw[ whoops uh-oh ]], '... got the errors we expected');

done_testing;