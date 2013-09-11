package React::Observer;
use v5.16;
use warnings;
use mop;

use React::Core;

class Debug with React::Core::Observer {

    has $!name;

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

    submethod DEMOLISH {
        warn '>>>' . $!name . " stopped subscribing\n";
    }
}

__END__

=pod

=cut