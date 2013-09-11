#!perl

use strict;
use warnings;

use mop;

use Plack;
use Plack::Request;

use React::Observable;
use React::Observer::Debug;
use React::AnyEvent::Subscription::Watcher;

use AnyEvent;

class PlackObservableNumberStream extends React::Observable {

    has $!size                 = die "Must specify a size for the number stream";
    has $!producer is ro, lazy = $_->build_producer;
    has $!subscription;

    method init_subscription ($watcher) {
        $!subscription = React::AnyEvent::Subscription::Watcher->new(
            watcher => $watcher
        );
    }

    method unsubscribe { $!subscription->unsubscribe }

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
            $self->init_subscription( $w );
        }
    }
}

class PlackStreamingObserver with React::Core::Observer {
    has $!writer;

    method on_next ($val) {
        warn "on_next $val";
        $!writer->write( "$val\n" );
    }

    method on_completed {
        warn "on_completed";
        $!writer->close;
    }

    method on_error ($e) {
        warn "on_error $e";
        $!writer->write("Got an error: $e\n");
        $!writer->close;
    }
}

sub {
    my $r = Plack::Request->new( shift );

    warn "This app needs a server that supports psgi.streaming"
        unless $r->env->{'psgi.streaming'};

    my $o = PlackObservableNumberStream->new( size => $r->param('size') || 10 );

    return sub {
        my $respond = shift;
        my $writer  = $respond->([ 200, [ 'Content-Type' => 'text/plain' ]]);
        $o->subscribe( PlackStreamingObserver->new( writer => $writer ) );
    };
}













