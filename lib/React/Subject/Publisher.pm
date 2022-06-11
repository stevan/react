package React::Subject::Publisher;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use React::Subscription::Callback;

use parent 'React::Subject';
use slots (
    _observer_subcription_map => sub { +{} },
);

sub build_producer ($self) {
    return sub {
        my $observer = shift;

        my $subscription;
        $subscription = React::Subscription::Callback->new( cb => sub {
            (delete $self->{_observer_subcription_map}->{ $subscription })->on_completed
        });

        $self->{_observer_subcription_map}->{ $subscription } = $observer;
        $subscription;
    }
}

sub on_completed ($self) {
    map { $_->on_completed } values %{ $self->{_observer_subcription_map} }
}

sub on_error ($self, $e) {
    map { $_->on_error($e) } values %{ $self->{_observer_subcription_map} }
}

sub on_next ($self, $val) {
    map { $_->on_next($val) } values %{ $self->{_observer_subcription_map} }
}

1;

__END__

=pod

=cut
