package ReactX::AnyEvent::Subscription;
use v5.16;
use warnings;
use mop;

class Watcher with React::Subscription {
    has $!watcher;

    method watch ($w)      { $!watcher = $w; $self }
    method unsubscribe     { $!watcher = undef     }
    method is_unsubscribed { not defined $!watcher }
}

__END__

=pod

=cut