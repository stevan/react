package React::Observable::Take;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use React::Observer::Simple;
use React::Subscription::Wrapper;

use parent 'React::Observable';
use slots (
    sequence => sub {},
    n        => sub {},
);

sub build_producer ($self) {
    return sub {
        my $observer = shift;
        my $counter  = 0;

        my $take_subscription = React::Subscription::Wrapper->new;
        my $take_observer     = React::Observer::Simple->new(
            on_completed => sub      { $observer->on_completed   if $counter < $self->{n} },
            on_error     => sub ($e) { $observer->on_error( $e ) if $counter < $self->{n} },
            on_next      => sub ($val) {
                $counter++;
                if ( $counter <= $self->{n} ) {
                    $observer->on_next( $val );
                    if ( $counter == $self->{n} ) {
                        $observer->on_completed;
                    }
                }
                if ( $counter >= $self->{n} ) {
                    $take_subscription->unsubscribe;
                }
            },
        );
        $take_subscription->wrap( $self->{sequence}->subscribe( $take_observer ) );
    }
}

1;

__END__

=pod

=cut
