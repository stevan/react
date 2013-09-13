package React::Observable;
use v5.16;
use warnings;
use mop;

use React::Observer::Simple;
use React::Subscription::Wrapper;

class Take extends React::Observable {
    has $!sequence is ro = die '$!sequence is required';;
    has $!n        is ro = die '$!n is required';;

    method new (%args) {
        $self = $class->next::method(
            %args,
            producer => sub {
                my $observer = shift;
                my $counter  = 0;

                my $take_subscription = React::Subscription::Wrapper->new;
                my $take_observer     = React::Observer::Simple->new(
                    on_completed => sub { $observer->on_completed      if $counter < $self->n },
                    on_error     => sub { $observer->on_error( $_[0] ) if $counter < $self->n },
                    on_next      => sub {
                        $counter++;
                        if ( $counter <= $self->n ) {
                            $observer->on_next( $_[0] );
                            if ( $counter == $self->n ) {
                                $observer->on_completed;
                            }
                        }
                        if ( $counter >= $self->n ) {
                            $take_subscription->unsubscribe;
                        }
                    },
                );
                $take_subscription->wrap( $self->sequence->subscribe( $take_observer ) );
            }
        );
    }
}

__END__

=pod

=cut