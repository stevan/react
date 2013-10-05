package React::Observable;
use v5.16;
use warnings;
use mop;

class From extends React::Observable {
    has $!values = [];

    method build_producer {
        my @values = @{ $!values };
        return sub {
            my $observer = shift;
            $observer->on_next( $_ ) for @values;
            $observer->on_completed;
        }
    }

}

__END__

=pod

=cut