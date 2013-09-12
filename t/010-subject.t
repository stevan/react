#!perl

use strict;
use warnings;
use mop;

use AnyEvent;

use React;
use React::Observer::Debug;
use React::Subject::Publisher;

my $s = React::Subject::Publisher->new;

my $x  = 0;
my $cv = AnyEvent->condvar;
my $w  = AnyEvent->timer(
    after    => 0,
    interval => 0.5,
    cb       => sub {
        $s->on_next( $x++ );
        if ( $x == 20 ) {
            $s->on_completed;
            $cv->send;
        }
    }
);

my ($s1, $s2);

$s1 = $s->subscribe( React::Observer::Debug->new(name => 'simple1') );

my $w1 = AnyEvent->timer( after => 2, cb => sub {
    $s2 = $s->subscribe( React::Observer::Debug->new(name => 'simple2') );
});

my $w2 = AnyEvent->timer( after => 4, cb => sub {
    warn "unsubscribing simple1";
    $s1->unsubscribe;
});

$cv->recv;

warn "goodbye";








