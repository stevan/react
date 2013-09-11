#!perl

use strict;
use warnings;

use AnyEvent;

use React::Observable;
use React::Observer::Debug;

use mop;

class Subscription::AnyEventWatcher with React::Core::Subscription {
    has $!w;

    method unsubscribe { undef $!w }
}

## ------------------------------------
## Test body
## ------------------------------------

my $cv = AnyEvent->condvar;

my $o = React::Observable->new(
    producer => sub {
        my $observer = shift;
        my $x = 0;
        my $w = AnyEvent->timer(
            after    => 0.5,
            interval => 0.5,
            cb       => sub { $observer->on_next( $x++ ) }
        );
        Subscription::AnyEventWatcher->new( w => $w );
    }
);

my $m = $o->map(sub { $_[0] * 100 });
my $t = $m->take(5);

my $sub1 = $o->subscribe( React::Observer::Debug->new(name => 'simple1') );
my $sub2 = $m->subscribe( React::Observer::Debug->new(name => 'map    ') );
my $sub3 = $t->subscribe( React::Observer::Debug->new(name => 'take   ') );

my ($sub4, $w3);

my $w1 = AnyEvent->timer(after => 10, cb => sub {
    $sub1->unsubscribe;
    $sub4 = $o->subscribe( React::Observer::Debug->new(name => 'simple2') );
    $w3 = AnyEvent->timer(after => 25, cb => sub {
        $sub4->unsubscribe;
        #warn $w3;
        $cv->send;
    });
});

my $w2 = AnyEvent->timer(after => 15, cb => sub {
    $sub2->unsubscribe;
    $sub3->unsubscribe;
});

$cv->recv;


1;


