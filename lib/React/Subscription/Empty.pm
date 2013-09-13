package React::Subscription;
use v5.16;
use warnings;
use mop;

class Empty with React::Subscription {
    method unsubscribe {}
}

__END__

=pod

=cut