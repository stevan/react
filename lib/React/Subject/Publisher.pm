package React::Subject;
use v5.16;
use warnings;
use mop;

use React::Subject;
use React::Subscription::Callback;

class Publisher extends React::Subject {
    has $!observers is ro = {};

    method new {
        $self = $class->next::method(
            producer => sub {
                my $observer     = shift;
                my $subscription = React::Subscription::Callback->new( cb => sub {
                    (delete $self->observers->{ $observer })->[0]->on_completed
                });
                $self->observers->{ $observer } = [ $observer, $subscription ];
                $subscription;
            }
        );
    }

    method on_completed {
        map { $_->on_completed } map { $_->[0] } values %{ $!observers }
    }

    method on_error ($e) {
        map { $_->on_error($e) } map { $_->[0] } values %{ $!observers }
    }

    method on_next ($val) {
        map { $_->on_next($val) } map { $_->[0] } values %{ $!observers }
    }
}

__END__

=pod

=cut