package React::Observer;
use v5.16;
use warnings;
use mop;

class Debug with React::Observer {

    has $!name is ro;

    submethod BUILD {
        warn '>>>' . $!name . " started subscribing\n";
    }

    method on_completed {
        warn $!name . " COMPLETED\n";
    }

    method on_error ($exception) {
        warn $!name . " GOT ERROR: $exception\n";
    }

    method on_next ($value) {
        warn $!name . " GOT VALUE: $value\n";
    }
}

__END__

=pod

=cut