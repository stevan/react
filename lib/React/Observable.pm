package React;
use v5.16;
use warnings;
use mop;

use Scalar::Util    qw[ blessed ];
use Module::Runtime qw[ use_module ];

use React::Subscription::Empty;

class Observable {

    has $!producer is ro = die '$!producer is required';

    method subscribe ($observer) {
        my $subscription = $self->producer->( $observer );
        return $subscription
            if blessed $subscription
            && $subscription->can('does')
            && $subscription->does('React::Subscription');
        return React::Subscription::Empty->new;
    }

    method take ( $n ) { use_module('React::Observable::Take')->new( sequence => $self, n => $n ) }
    method map  ( $f ) { use_module('React::Observable::Map' )->new( sequence => $self, f => $f ) }
}

__END__

=pod

=cut
