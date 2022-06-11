package React::Subscription::Wrapper;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'UNIVERSAL::Object';
use roles  'React::Subscription';
use slots (
    actual => sub {}
);

sub wrap ($self, $actual) {
    $self->{actual} = $actual;
    $self;
}

sub unsubscribe ($self) {
    $self->{actual}->unsubscribe
        if defined $self->{actual};
}

sub is_unsubscribed ($self) {
    return $self->{actual}->is_unsubscribed
        if defined $self->{actual};
    # NOTE:
    # if we don't have one, we
    # clearly are not subscribed
    # and therefore we are
    # unsubscribed
    # - SL
    1;
}

1;

__END__

=pod

=cut
