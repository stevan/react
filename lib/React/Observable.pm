package React;
use v5.16;
use warnings;
use mop;

use Scalar::Util    qw[ blessed ];
use Module::Runtime qw[ use_module ];

use React::Subscription::Empty;

class Observable {

    has $!producer is lazy = $_->build_producer;

    method BUILD { $!producer } # force the lazy

    method build_producer { die '$!producer is required' }

    method subscribe ($observer) {
        my $subscription = $!producer->( $observer );
        return $subscription
            if blessed $subscription
            && $subscription->can('does')
            && $subscription->does('React::Subscription');
        return React::Subscription::Empty->new;
    }

    # instance methods

    method take ( $n ) { use_module('React::Observable::Take')->new( sequence => $self, n => $n ) }
    method map  ( $f ) { use_module('React::Observable::Map' )->new( sequence => $self, f => $f ) }
    method grep ( $f ) { use_module('React::Observable::Grep')->new( sequence => $self, f => $f ) }

    # class methods

    method from ($class: @values) { use_module('React::Observable::From')->new( values => \@values ) }

    # class or instance method

    method concat {
        use_module('React::Observable::Concat')->new(
            observables => [ (blessed $self ? $self : ()), @_ ]
        )
    }

    method materialize {
        use_module('React::Observable::Materialize')->new(
            sequence => (blessed $self ? $self : $_[0])
        )
    }

    # these can be useful, they don't do much
    method empty ($class:)    { React::Observerable->new( producer => sub { $_[0]->on_completed   } ) }
    method error ($class: $e) { React::Observerable->new( producer => sub { $_[0]->on_error( $e ) } ) }
    method never ($class:)    { React::Observerable->new( producer => sub {                       } ) }
}

__END__

=pod

=cut
