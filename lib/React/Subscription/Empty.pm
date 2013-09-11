package React::Subscription;
use v5.16;
use warnings;
use mop;

use React::Core;

class Empty with React::Core::Subscription {
    method unsubscribe {}
}

__END__

=pod

=cut