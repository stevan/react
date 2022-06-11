package React::Subscription::Empty;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'UNIVERSAL::Object';
use roles  'React::Subscription';

sub unsubscribe     ($self) {   }
sub is_unsubscribed ($self) { 1 }

1;

__END__

=pod

=cut
