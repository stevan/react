package React::Subscription;
use v5.16;
use warnings;
use mop;

use React::Core;

class Callback with React::Core::Subscription {
    has $!cb;

    method unsubscribe { $!cb->() }
}

__END__

=pod

=cut