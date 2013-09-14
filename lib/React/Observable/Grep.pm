package React::Observable;
use v5.16;
use warnings;
use mop;

use React::Observer::Simple;

class Grep extends React::Observable {
    has $!sequence is ro = die '$!sequence is required';
    has $!f        is ro = die '$!f is required';

    method new (%args) {
        $self = $class->next::method(
            %args,
            producer => sub {
                my $observer = shift;
                $self->sequence->subscribe(
                    React::Observer::Simple->new(
                        on_completed => sub { $observer->on_completed      },
                        on_error     => sub { $observer->on_error( $_[0] ) },
                        on_next      => sub {
                            local $_ = $_[0];
                            $observer->on_next( $_[0] ) if $self->f->( $_[0] )
                        },
                    )
                )
            }
        );
    }
}

__END__

=pod

=cut