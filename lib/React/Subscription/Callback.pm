package React::Subscription;
use v5.16;
use warnings;
use mop;

class Callback with React::Subscription {
    has $!cb;

    method unsubscribe { $!cb->() }
}

__END__

=pod

=cut