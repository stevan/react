package React;
use v5.16;
use warnings;
use mop;

role Observer {
    method on_completed;
    method on_error;
    method on_next;
}

__END__

=pod

=cut