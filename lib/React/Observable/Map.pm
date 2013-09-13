package React::Observable;
use v5.16;
use warnings;
use mop;

use React::Observer::Simple;

class Map extends React::Observable {
    has $!sequence is ro;
    has $!f        is ro;

    method new (%args) {
        $self = $class->next::method(
            producer => sub {
                my $observer = shift;
                $self->sequence->subscribe(
                    React::Observer::Simple->new(
                        on_completed => sub { $observer->on_completed      },
                        on_error     => sub { $observer->on_error( $_[0] ) },
                        on_next      => sub {
                            local $_ = $_[0];
                            $observer->on_next( $self->f->( $_[0] ) )
                        },
                    )
                )
            },
            %args
        );
    }
}

__END__

=pod

=cut