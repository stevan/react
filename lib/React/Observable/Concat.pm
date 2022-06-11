package React::Observable::Concat;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use React::Observer::Simple;
use React::Subscription::Wrapper;
use React::Subscription::Callback;

use parent 'React::Observable';
use slots (
    observables => sub { [] },
);

sub build_producer ($self) {
    return sub {
        my $observer    = shift;
        my @observables = $self->{observables}->@*;
        my @subscriptions;

        my $reusable_observer;
        $reusable_observer = React::Observer::Simple->new(
            on_error     => sub ($e)   { $observer->on_error( $e ) },
            on_next      => sub ($val) { $observer->on_next( $val )  },
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

1;

__END__

=pod

=cut
