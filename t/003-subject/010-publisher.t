#!perl

use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use Test::More;

use React;
use React::Subject::Publisher;
use Test::React::Observer::Recorder;

my $p = React::Subject::Publisher->new;
isa_ok($p, 'React::Subject');
isa_ok($p, 'React::Observable');
ok($p->roles::DOES('React::Observer'), '... this object does React::Observer');

my $r1 = Test::React::Observer::Recorder->new;
my $r2 = Test::React::Observer::Recorder->new;
my $r3 = Test::React::Observer::Recorder->new;

my $s1 = $p->subscribe( $r1 );
ok($s1->roles::DOES('React::Subscription'), '... this is a React::Subscription');

$p->on_next(10);
$p->on_next(20);

my $s2 = $p->subscribe( $r2 );
ok($s2->roles::DOES('React::Subscription'), '... this is a React::Subscription');

$p->on_next(30);
$p->on_next(40);

is_deeply($r1->values, [ 10, 20, 30, 40 ], '... got the expected values in the first observer');
is_deeply($r2->values, [ 30, 40 ], '... got the expected values in the second observer');

ok(!$r1->is_completed, '... the first observer is not completed');
ok(!$r2->is_completed, '... the second observer is not completed');

$s1->unsubscribe;

ok($r1->is_completed, '... the first observer is now completed (because they unsubscribed)');
ok(!$r2->is_completed, '... the second observer is still not completed');

$p->on_next(50);
$p->on_next(60);
$p->on_completed;

is_deeply($r1->values, [ 10, 20, 30, 40 ], '... the first observer unsubscribed');
is_deeply($r2->values, [ 30, 40, 50, 60 ], '... the second observer kept getting values');

ok($r2->is_completed, '... the second observer is now completed');

my $s3 = $p->subscribe( $r3 );
ok($s3->roles::DOES('React::Subscription'), '... this is a React::Subscription');

$p->on_next(70);
$p->on_next(80);

is_deeply($r1->values, [ 10, 20, 30, 40 ], '... the first observer is still unsubscribed');
is_deeply($r2->values, [ 30, 40, 50, 60, 70, 80 ], '... the second observer kept getting values (despite being completed)');
is_deeply($r3->values, [ 70, 80 ], '... the third observer is getting values');

ok($r2->is_completed, '... the second observer is still completed');
ok(!$r3->is_completed, '... the third observer is not completed');

done_testing;

