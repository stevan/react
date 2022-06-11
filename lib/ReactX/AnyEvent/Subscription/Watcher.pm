package ReactX::AnyEvent::Subscription::Watcher;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'UNIVERSAL::Object';
use roles  'React::Subscription';
use slots (
    watcher => sub {},
);

sub watch           ($self, $w) { $self->{watcher} = $w; $self }
sub unsubscribe     ($self)     { $self->{watcher} = undef     }
sub is_unsubscribed ($self)     { not defined $self->{watcher} }

1;

__END__

=pod

=cut
