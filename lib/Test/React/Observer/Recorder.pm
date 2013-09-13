package Test::React::Observer;
use v5.16;
use warnings;
use mop;

class Recorder with React::Observer {
    has $!values       is ro = [];
    has $!errors       is ro = [];
    has $!is_completed is ro = 0;

    method on_next ($val) {
        push @{ $!values } => $val;
    }

    method on_completed { $!is_completed = 1 }

    method on_error ($e) {
        push @{ $!errors } => $e;
    }
}

__END__

=pod

=cut