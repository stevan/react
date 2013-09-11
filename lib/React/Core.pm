package React::Core;
use v5.16;
use warnings;
use mop;

role Observable {
    # subscribe :: (Observer) => Subscription

    method subscribe;
}

role Observer {
    # on_completed :: ()          => Unit
    # on_error     :: (Exception) => Unit
    # on_next      :: ()          => Any

    method on_completed;
    method on_error;
    method on_next;
}

role Subscription {
    # unsubscribe :: () => Unit

    method unsubscribe;
}

__END__

=pod

=cut