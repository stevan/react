#!perl

use strict;
use warnings;
use mop;

use Test::More;

use React;
use React::Subject::Publisher;
use Test::React::Observer::Recorder;

my $p = React::Subject::Publisher->new;
isa_ok($p, 'React::Subject');
isa_ok($p, 'React::Observable');
ok($p->does('React::Observer'), '... this object does React::Observer');

my $r1 = Test::React::Observer::Recorder->new;
my $r2 = Test::React::Observer::Recorder->new;

my $s1 = $p->subscribe( $r1 );
ok($s1->does('React::Subscription'), '... this is a React::Subscription');

$p->on_next(10);
$p->on_next(20);
$p->on_completed;

my $s2 = $p->subscribe( $r2 );
ok($s2->does('React::Subscription'), '... this is a React::Subscription');

$p->on_next(30);
$p->on_next(40);

is_deeply($r1->values, [ 10, 20, 30, 40 ], '... got the expected values in the first observer');
is_deeply($r2->values, [ 30, 40 ], '... got the expected values in the second observer');

ok($r1->is_completed, '... the first observer is completed');
ok(!$r2->is_completed, '... the second observer is not completed');

$s1->unsubscribe;

$p->on_next(50);
$p->on_next(60);

is_deeply($r1->values, [ 10, 20, 30, 40 ], '... the first observer unsubscribed');
is_deeply($r2->values, [ 30, 40, 50, 60 ], '... the second observer kept getting values');

done_testing;