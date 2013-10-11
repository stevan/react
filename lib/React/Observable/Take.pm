package React::Observable;
use v5.16;
use warnings;
use mop;

use React::Observer::Simple;
use React::Subscription::Wrapper;

class Take extends React::Observable {
    has $!sequence = die '$!sequence is required';
    has $!n        = die '$!n is required';

    method build_producer {
        return sub {
            my $observer = shift;
            my $counter  = 0;

            my $take_subscription = React::Subscription::Wrapper->new;
            my $take_observer     = React::Observer::Simple->new(
                on_completed => sub { $observer->on_completed      if $counter < $!n },
                on_error     => sub { $observer->on_error( $_[0] ) if $counter < $!n },
                on_next      => sub {
                    $counter++;
                    if ( $counter <= $!n ) {
                        $observer->on_next( $_[0] );
                        if ( $counter == $!n ) {
                            $observer->on_completed;
                        }
                    }
                    if ( $counter >= $!n ) {
                        $take_subscription->unsubscribe;
                    }
                },
            );
            $take_subscription->wrap( $!sequence->subscribe( $take_observer ) );
        }
    }
}

__END__

=pod

=cut