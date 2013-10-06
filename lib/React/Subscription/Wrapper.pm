package React::Subscription;
use v5.16;
use warnings;
use mop;

class Wrapper with React::Subscription {
    has $!actual;

    method wrap ($actual) {
        $!actual = $actual;
        $self;
    }

    method unsubscribe {
        $!actual->unsubscribe
            if defined $!actual;
    }

    method is_unsubscribed {
        return $!actual->is_unsubscribed
            if defined $!actual;
        # NOTE:
        # if we don't have one, we
        # clearly are not subscribed
        # and therefore we are
        # unsubscribed
        # - SL
        1;
    }
}

__END__

=pod

=cut