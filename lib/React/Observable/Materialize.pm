package React::Observable;
use v5.16;
use warnings;
use mop;

use React::Notification;
use React::Observer::Simple;

class Materialize extends React::Observable {
    has $!sequence is required;

    method build_producer {
        return sub {
            my $observer = shift;
            $!sequence->subscribe(
                React::Observer::Simple->new(
                    on_completed => sub {
                        $observer->on_next( React::Notification->new );
                        $observer->on_completed;
                    },
                    on_error => sub {
                        $observer->on_next( React::Notification->new( error => $_[0] ) );
                        $observer->on_error( $_[0] )
                    },
                    on_next => sub {
                        $observer->on_next( React::Notification->new( value => $_[0] ) );
                    },
                )
            )
        }
    }
}

__END__

=pod

=cut