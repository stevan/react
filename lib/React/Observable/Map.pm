package React::Observable::Map;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use React::Observer::Simple;

use parent 'React::Observable';
use slots (
    sequence => sub {},
    f        => sub {},
);

sub build_producer ($self) {
    return sub {
        my $observer = shift;
        $self->{sequence}->subscribe(
            React::Observer::Simple->new(
                on_completed => sub { $observer->on_completed      },
                on_error     => sub ($e) { $observer->on_error( $e ) },
                on_next      => sub ($val) {
                    local $_ = $val;
                    $observer->on_next( $self->{f}->( $val ) )
                },
            )
        )
    }
}

1;

__END__

=pod

=cut
