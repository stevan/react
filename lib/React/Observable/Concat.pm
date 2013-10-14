package React::Observable;
use v5.16;
use warnings;
use mop;

use React::Observer::Simple;
use React::Subscription::Wrapper;
use React::Subscription::Callback;

class Concat extends React::Observable {
    has $!observables is required;

    method build_producer {
        return sub {
            my $observer    = shift;
            my @observables = @{ $!observables };
            my @subscriptions;

            my $reusable_observer;
            $reusable_observer = React::Observer::Simple->new(
                on_error     => sub { $observer->on_error( $_[0] ) },
                on_next      => sub { $observer->on_next( $_[0] )  },
                on_completed => sub {
                    # unsubscribe the last sequence
                    (pop @subscriptions)->unsubscribe if @subscriptions;
                    if (my $current = shift @observables) {
                        # grab the next subscription ...
                        push @subscriptions => $current->subscribe( $reusable_observer );
                    } else {
                        $observer->on_completed;
                    }
                },
            );

            # kick off the whole process
            push @subscriptions => (shift @observables)->subscribe( $reusable_observer );

            React::Subscription::Callback->new(
                cb => sub { $_->unsubscribe for @subscriptions }
            );
        }
    }
}

__END__

=pod

=cut