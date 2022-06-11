package React::Observable::Materialize;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use React::Notification;
use React::Observer::Simple;

use parent 'React::Observable';
use slots (
    sequence => sub {},
);

sub build_producer ($self) {
    return sub {
        my $observer = shift;
        $self->{sequence}->subscribe(
            React::Observer::Simple->new(
                on_completed => sub {
                    $observer->on_next( React::Notification->new );
                    $observer->on_completed;
                },
                on_error => sub ($e) {
                    $observer->on_next( React::Notification->new( error => $e ) );
                    $observer->on_error( $e )
                },
                on_next => sub ($val) {
                    $observer->on_next( React::Notification->new( value => $val ) );
                },
            )
        )
    }
}

1;

__END__

=pod

=cut
