package ReactX::AnyEvent::Subscription;
use v5.16;
use warnings;
use mop;

use React::Core;

class Watcher with React::Core::Subscription {
    has $!watcher;

    method unsubscribe { undef $!watcher }
}

__END__

=pod

=cut