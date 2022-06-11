#!perl

use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use Test::More tests => 16;

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

my $r1 = Test::React::Observer::Recorder->new;
ok($r1->roles::DOES('React::Observer'), '... this object does React::Observer');

my $s1 = $c->subscribe( $r1 );
ok($s1->roles::DOES('React::Subscription'), '... this object does React::Subscription');

ok(!$s1->is_unsubscribed, '... we are not yet unsubscribed');

my $w1 = AnyEvent->timer(after => 1, cb => sub {
    ok(!$s1->is_unsubscribed, '... we are (still) not yet unsubscribed (after 1 second)');
});

diag "pause for approx. 3 seconds ...";

my ($s2, $r2);

my $w2 = AnyEvent->timer(after => 3, cb => sub {
    is_deeply( $r1->values, [ 0 .. 20 ], '... got the expected values');
    ok($r1->is_completed, '... and we have been completed');

    ok(!$s1->is_unsubscribed, '... we are (still) not yet unsubscribed (after 3 seconds)');
    $s1->unsubscribe;
    ok($s1->is_unsubscribed, '... we are now unsubscribed');

    $r2 = Test::React::Observer::Recorder->new;
    ok($r2->roles::DOES('React::Observer'), '... this object does React::Observer');

    $s2 = $c->subscribe( $r2 );
    ok($s2->roles::DOES('React::Subscription'), '... this object does React::Subscription');

    ok(!$s2->is_unsubscribed, '... we are not yet unsubscribed');

    diag "pause again for another 3 seconds ...";
});

my $w3 = AnyEvent->timer(after => 4, cb => sub {
    ok(!$s2->is_unsubscribed, '... we are (still) not yet unsubscribed');
});

my $w4 = AnyEvent->timer(after => 6, cb => sub {
    is_deeply( $r2->values, [ 0 .. 20 ], '... got the expected values');
    ok($r2->is_completed, '... and we have been completed');
    $s2->unsubscribe;
    $cv->send;
});

$cv->recv;

1;

