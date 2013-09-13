package React;
use v5.16;
use warnings;
use mop;

use Module::Runtime qw[ use_module ];

class Observable {

    has $!producer is ro;

    method subscribe ($observer) {
        $self->producer->( $observer );
    }

    method take ( $n ) { use_module('React::Observable::Take')->new( sequence => $self, n => $n ) }
    method map  ( $f ) { use_module('React::Observable::Map' )->new( sequence => $self, f => $f ) }
}

__END__

=pod

=cut
