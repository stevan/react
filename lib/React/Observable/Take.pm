package React::Observable;
use v5.16;
use warnings;
use mop;

class Take extends React::Observable {
    has $!sequence;
    has $!n;
    has $!subscription;

    method subscribe ($observer) {
        $!subscription = $!sequence->subscribe(
            React::Observable::Take::Observer->new(
                observer => $observer,
                num      => $!n,
                parent   => $self
            )
        )
    }

    method unsubscribe {
        $!subscription->unsubscribe;
    }
}

package React::Observable::Take;
use v5.16;
use warnings;
use mop;

use React::Core;

class Observer with React::Core::Observer {
    has $!parent;
    has $!observer;
    has $!counter = 0;
    has $!num;

    method on_error ($e) {
        $!observer->on_error( $e )
            if $!counter < $!num;
    }

    method on_completed {
        $!observer->on_completed()
            if $!counter < $!num;
    }

    method on_next ($v) {
        $!counter++;
        if ( $!counter <= $!num ) {
            $!observer->on_next( $v );
            if ( $!counter == $!num ) {
                $!observer->on_completed;
            }
        }
        if ( $!counter >= $!num ) {
            $!parent->unsubscribe;
        }
    }
}

__END__

=pod

=cut