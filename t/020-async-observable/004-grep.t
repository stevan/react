#!perl

use strict;
use warnings;
use mop;

use Test::More;

use React;
use Test::React::Observer::Recorder;
use ReactX::AnyEvent::Subscription::Watcher;

use AnyEvent;

my $cv = AnyEvent->condvar;

my $o = React::Observable->new(
    producer => sub {
        my $observer = shift;
        my $x = 0;
        my $w = AnyEvent->timer(
            after    => 0.0,
            interval => 0.1,
            cb       => sub {
                if ($x <= 10) {
                    #warn $x;
                    $observer->on_next( $x++ );
                } else {
                    $observer->on_completed;
                }
            }
        );
        ReactX::AnyEvent::Subscription::Watcher->new( watcher => $w );
    }
);
isa_ok($o, 'React::Observable');

my $g = $o->grep(sub { ($_ % 2) == 0 });

my $r = Test::React::Observer::Recorder->new;
ok($r->does('React::Observer'), '... this object does React::Observer');

my $s = $g->subscribe( $r );
ok($s->does('React::Subscription'), '... this object does React::Subscription');

diag "pause for approx. 2 seconds ...";

my $w = AnyEvent->timer(after => 2, cb => sub {
    is_deeply( $r->values, [ 0, 2, 4, 6, 8, 10 ], '... got the expected values');
    ok($r->is_completed, '... and we have been completed');
    $s->unsubscribe;
    $cv->send;
});

$cv->recv;

done_testing;

