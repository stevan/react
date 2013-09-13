package ReactX::AnyEvent::Subscription;
use v5.16;
use warnings;
use mop;

class Watcher with React::Subscription {
    has $!watcher;

    method unsubscribe { undef $!watcher }
}

__END__

=pod

=cut