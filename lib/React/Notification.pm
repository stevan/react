package React::Notification;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use Scalar::Util 'blessed';
use Carp         'confess';

use parent 'UNIVERSAL::Object';
use slots (
    value => sub {},
    error => sub {},
    # private
    _kind  => sub {},
);

sub BUILD ($self, $) {
    confess "Notifications cannot have both value and error"
        if defined $self->{value} && defined $self->{error};
    if (defined $self->{value}) {
        $self->{_kind} = React::Notification::Kind->ON_NEXT;
    } elsif (defined $self->{error}) {
        $self->{_kind} = React::Notification::Kind->ON_ERROR;
    } else {
        $self->{_kind} = React::Notification::Kind->ON_COMPLETED;
    }
}

sub is_on_next      ($self) { $self->{_kind} eq React::Notification::Kind->ON_NEXT      }
sub is_on_error     ($self) { $self->{_kind} eq React::Notification::Kind->ON_ERROR     }
sub is_on_completed ($self) { $self->{_kind} eq React::Notification::Kind->ON_COMPLETED }

sub has_value ($self) { $self->is_on_next  && defined $self->{value} }
sub has_error ($self) { $self->is_on_error && defined $self->{error} }

sub value ($self) { $self->{value} }
sub error ($self) { $self->{error} }
sub kind  ($self) { $self->{_kind} }

1;

package React::Notification::Kind;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use constant ON_NEXT      => 'on_next';
use constant ON_ERROR     => 'on_error';
use constant ON_COMPLETED => 'on_completed';

1;

__END__

=pod

=cut
