#!perl

use strict;
use warnings;

use mop;

use AnyEvent;

use Plack;
use Plack::Builder;
use Plack::Request;

use React;
use React::Subject::Publisher;
use ReactX::Plack::Observer::Streaming;

my $p = React::Subject::Publisher->new;

# NOTE:
# this is kinda silly, but
# AnyEvent really wants me
# to do it.
# - SL
AnyEvent->condvar->begin;

builder {
    mount '/talk' => sub {
        my $r = Plack::Request->new( shift );
        $p->on_next( $r->param('message') );
        [ 200, [ 'Content-Type' => 'text/plain' ], [ "thank you for your message\n" ]];
    };

    mount '/listen' => sub {
        my $r = Plack::Request->new( shift );
        warn "This app needs a server that supports psgi.streaming"
            unless $r->env->{'psgi.streaming'};

        return sub {
            my $w = $_[0]->([ 200, [ 'Content-Type' => 'text/plain' ]]);
            $w->write("listening ...\n");
            $p->map(sub { $_ . "\n" })->subscribe(
                ReactX::Plack::Observer::Streaming->new( writer => $w )
            );
        };
    };
}

