package React;
use v5.16;
use warnings;
use mop;

use React::Core;
use React::Observable;

class React::Subject extends React::Observable with React::Core::Observer is abstract {}

__END__

=pod

=cut