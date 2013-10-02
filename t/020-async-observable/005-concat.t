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

my $o1 = React::Observable->new(
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
isa_ok($o1, 'React::Observable');

my $o2 = React::Observable->new(
    producer => sub {
        my $observer = shift;
        my $x = 11;
        my $w = AnyEvent->timer(
            after    => 0.0,
            interval => 0.1,
            cb       => sub {
                if ($x <= 20) {
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
isa_ok($o2, 'React::Observable');

my $c = $o1->concat( $o2 );

my $r = Test::React::Observer::Recorder->new;
ok($r->does('React::Observer'), '... this object does React::Observer');

my $s = $c->subscribe( $r );
ok($s->does('React::Subscription'), '... this object does React::Subscription');

diag "pause for a moment ...";

my ($s2, $r2);

my $w1 = AnyEvent->timer(after => 2.5, cb => sub {
    #use Data::Dumper; warn Dumper( $r->values );
    is_deeply( $r->values, [ 0 .. 20 ], '... got the expected values');
    ok($r->is_completed, '... and we have been completed');

    $r2 = Test::React::Observer::Recorder->new;
    $s2 = $c->subscribe( $r2 );

    diag "pause again for a moment ...";
});

my $w2 = AnyEvent->timer(after => 5, cb => sub {
    #use Data::Dumper; warn Dumper( $r2->values );
    is_deeply( $r2->values, [ 0 .. 20 ], '... got the expected values');
    ok($r2->is_completed, '... and we have been completed');
    $s2->unsubscribe;
    $cv->send;
});

$cv->recv;

done_testing;

