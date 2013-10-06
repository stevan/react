package React;
use v5.16;
use warnings;
use mop;

class Notification {
    has $!value is ro;
    has $!error is ro;
    has $!kind  is ro;

    method BUILD {
        die "Notifications cannot have both value and error"
            if defined $!value && defined $!error;
        if (defined $!value) {
            $!kind = React::Notification::Kind->ON_NEXT
        } elsif (defined $!error) {
            $!kind = React::Notification::Kind->ON_ERROR
        } else {
            $!kind = React::Notification::Kind->ON_COMPLETED
        }
    }

    method is_on_next      { $!kind eq React::Notification::Kind->ON_NEXT      }
    method is_on_error     { $!kind eq React::Notification::Kind->ON_ERROR     }
    method is_on_completed { $!kind eq React::Notification::Kind->ON_COMPLETED }

    method has_value { $self->is_on_next  && defined $!value }
    method has_error { $self->is_on_error && defined $!error }
}

class React::Notification::Kind {
    method ON_NEXT      { 'on_next'      }
    method ON_ERROR     { 'on_error'     }
    method ON_COMPLETED { 'on_completed' }
}

__END__

=pod

=cut