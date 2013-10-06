#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

use React;
use ReactX::AnyEvent::Subscription::Watcher;

use AnyEvent;

{
    my $x = 0;
    my $s = do {
        my $w = AnyEvent->timer(
            after    => 0.5,
            cb       => sub { $x++ }
        );
        ReactX::AnyEvent::Subscription::Watcher->new( watcher => $w );
    };

    isa_ok($s, 'ReactX::AnyEvent::Subscription::Watcher');
    ok($s->does('React::Subscription'), '... this does React::Subscription');

    ok(!$s->is_unsubscribed, '... this is not yet unsubscribed');
    $s->unsubscribe;
    ok($s->is_unsubscribed, '... this is unsubscribed');

    diag "wait a moment to show something doesn't actually happen";

    my $cv = AnyEvent->condvar;
    my $w  = AnyEvent->timer( after => 1.0, cb => sub {
        is($x, 0, '... the value was not updated');
        $cv->send;
    });

    $cv->recv;
}

{
    my $s = do {
        my $s = ReactX::AnyEvent::Subscription::Watcher->new;
        my $w = AnyEvent->timer(
            after    => 0.5,
            cb       => sub { $s->unsubscribe }
        );
        $s->watch( $w );
    };

    isa_ok($s, 'ReactX::AnyEvent::Subscription::Watcher');
    ok($s->does('React::Subscription'), '... this does React::Subscription');

    ok(!$s->is_unsubscribed, '... this is not yet unsubscribed');

    diag "wait a moment to show something does actually happen";
    my $cv = AnyEvent->condvar;
    my $w  = AnyEvent->timer( after => 1.0, cb => sub {
        ok($s->is_unsubscribed, '... this is unsubscribed');
        $cv->send;
    });

    $cv->recv;
}

done_testing;