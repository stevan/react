package React::Subscription::Callback;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'UNIVERSAL::Object';
use roles  'React::Subscription';
use slots (
    cb           => sub {},
    unsubscribed => sub { 0 },
);

sub unsubscribe ($self) {
    $self->{unsubscribed}++;
    $self->{cb}->();
}

sub is_unsubscribed ($self) { $self->{unsubscribed} }

1;

__END__

=pod

=cut
