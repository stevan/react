#!perl

use strict;
use warnings;

use mop;

use Data::Dumper;

use React::Observable;
use React::Observer::Debug;
use React::Subscription::Empty;

use EV;
use AnyEvent;
use AnyEvent::Filesys::Notify;


my $o = React::Observable->new(
    producer => sub {
        my $observer = shift;
        my $notifier = AnyEvent::Filesys::Notify->new(
            dirs     => [ qw[ /Users/stevan/Desktop/react/ ] ],
            interval => 1,
            cb       => sub { $observer->on_next( $_ ) foreach @_ },
        );
        React::Subscription::Empty->new;
    }
);

my $sub = $o->map(sub {
    Dumper( $_[0] )
})->subscribe( React::Observer::Debug->new( name => 'filesys-notify' ) );

EV::loop;

#done_testing;