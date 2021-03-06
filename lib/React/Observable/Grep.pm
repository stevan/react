package React::Observable;
use v5.16;
use warnings;
use mop;

use React::Observer::Simple;

class Grep extends React::Observable {
    has $!sequence is required;
    has $!f        is required;

    method build_producer {
        return sub {
            my $observer = shift;
            $!sequence->subscribe(
                React::Observer::Simple->new(
                    on_completed => sub { $observer->on_completed      },
                    on_error     => sub { $observer->on_error( $_[0] ) },
                    on_next      => sub {
                        local $_ = $_[0];
                        $observer->on_next( $_[0] ) if $!f->( $_[0] )
                    },
                )
            )
        }
    }
}

__END__

=pod

=cut