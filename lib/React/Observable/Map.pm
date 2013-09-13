package React::Observable;
use v5.16;
use warnings;
use mop;

class Map extends React::Observable {

    has $!sequence;
    has $!f;

    method subscribe ($observer) {
        $!sequence->subscribe(
            React::Observable::Map::Observer->new(
                observer => $observer,
                f        => $!f
            )
        )
    }
}

package React::Observable::Map;
use v5.16;
use warnings;
use mop;

class Observer with React::Observer {
    has $!observer;
    has $!f;

    method on_completed  { $!observer->on_completed() }
    method on_error ($e) { $!observer->on_error( $e ) }
    method on_next  ($v) {
        local $_ = $v;
        $!observer->on_next( $!f->( $v ) )
    }
}

__END__

=pod

=cut