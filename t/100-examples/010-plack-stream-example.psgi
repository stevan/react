#!perl

use strict;
use warnings;

use mop;

use Try::Tiny;
use Plack;
use Plack::Request;

use React;
use ReactX::AnyEvent::Subscription::Watcher;
use ReactX::Plack::Observer::Streaming;

use AnyEvent;

class PlackObservableNumberStream extends React::Observable {

    has $!size                 = die "Must specify a size for the number stream";
    has $!producer is ro, lazy = $_->build_producer;

    method build_producer {
        my $size = $!size;
        return sub {
            my $observer = shift;
            my $x = 0;
            my $w = AnyEvent->timer(
                after    => 0,
                interval => 0.5,
                cb       => sub {
                    $observer->on_next( $x++ );
                    if ($x > $size) {
                        $observer->on_completed;
                        $self->unsubscribe;
                    }
                }
            );
            $self->_init_subscription( $w );
        }
    }

    # FIXME:
    # we have to keep track of our own subscription here
    # because otherwise the subscription goes out of scope
    # in the Plack response and the watcher gets reaped.
    # the other option was to make the Observer handle it
    # but that really didn't seem right at all. Perhaps
    # in a more sophisticated application there will be a
    # more obvious answer as to where to manage the
    # subscription.
    # - SL

    has $!subscription;

    method _init_subscription ($w) {
        $!subscription = ReactX::AnyEvent::Subscription::Watcher->new( watcher => $w );
    }

    method unsubscribe { $!subscription->unsubscribe }
}

sub {
    my $r = Plack::Request->new( shift );

    warn "This app needs a server that supports psgi.streaming"
        unless $r->env->{'psgi.streaming'};

    my $o = PlackObservableNumberStream->new( size => $r->param('size') // 10 );

    return sub {
        my $w = $_[0]->([ 200, [ 'Content-Type' => 'text/plain' ]]);
        $o->map(sub { $_ . "\n" })->subscribe(
            ReactX::Plack::Observer::Streaming->new( writer => $w )
        );
    };
}

