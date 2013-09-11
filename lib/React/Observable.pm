package React;
use v5.16;
use warnings;
use mop;

use Module::Runtime qw[ use_module ];

use React::Core;

class Observable with React::Core::Observable {

    has $!producer;

    method subscribe ($observer) {
        $!producer->( $observer );
    }

    method take ( $n ) { use_module('React::Observable::Take')->new( sequence => $self, n => $n ) }
    method map  ( $f ) { use_module('React::Observable::Map' )->new( sequence => $self, f => $f ) }
}

__END__

=pod

=cut
