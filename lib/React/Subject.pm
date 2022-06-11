package React::Subject;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'React::Observable';
use roles  'React::Observer';
use slots;

sub on_completed;
sub on_error;
sub on_next;

1;

__END__

=pod

=cut
