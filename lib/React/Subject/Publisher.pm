package React::Subject;
use v5.16;
use warnings;
use mop;

use React::Subscription::Callback;

class Publisher extends React::Subject {
    has $!_observer_subcription_map is ro = {};

    method new {
        $self = $class->next::method(
            producer => sub {
                my $observer = shift;

                my $subscription;
                $subscription = React::Subscription::Callback->new( cb => sub {
                    (delete $self->_observer_subcription_map->{ $subscription })->on_completed
                });

                $self->_observer_subcription_map->{ $subscription } = $observer;
                $subscription;
            }
        );
    }

    method on_completed {
        map { $_->on_completed } values %{ $!_observer_subcription_map }
    }

    method on_error ($e) {
        map { $_->on_error($e) } values %{ $!_observer_subcription_map }
    }

    method on_next ($val) {
        map { $_->on_next($val) } values %{ $!_observer_subcription_map }
    }
}

__END__

=pod

=cut