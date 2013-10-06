package React::Subscription;
use v5.16;
use warnings;
use mop;

class Callback with React::Subscription {
    has $!cb;
    has $!unsubscribed = 0;

    method unsubscribe {
        $!unsubscribed++;
        $!cb->();
    }

    method is_unsubscribed { $!unsubscribed }
}

__END__

=pod

=cut