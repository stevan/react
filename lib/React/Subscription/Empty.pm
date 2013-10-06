package React::Subscription;
use v5.16;
use warnings;
use mop;

class Empty with React::Subscription {
    method unsubscribe     {   }
    method is_unsubscribed { 1 }
}

__END__

=pod

=cut