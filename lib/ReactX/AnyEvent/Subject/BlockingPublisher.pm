package ReactX::AnyEvent::Subject;
use v5.16;
use warnings;
use mop;

use AnyEvent;

class BlockingPublisher extends React::Subject::Publisher {

    has $!cv = AnyEvent->condvar;

    submethod BUILD    { $!cv->begin }
    submethod DEMOLISH { $!cv->end   }
}

__END__

=pod

=cut