package React::Observable;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use Scalar::Util    'blessed';
use Carp            'confess';
use Module::Runtime 'use_module';

use React::Subscription::Empty;

use parent 'UNIVERSAL::Object';
use slots (
    producer => sub {},
);

sub BUILD ($self, $) {
    # allow it to be passed in,
    # but if not, then it will
    # assume that you have a
    # build_producer method defined ...
    $self->{producer} //= $self->build_producer;
}

sub build_producer ($self) {
    confess 'If this method is not overriden, then a `producer` is required';
}

sub subscribe ($self, $observer) {
    my $subscription = $self->{producer}->( $observer );
    return $subscription
        if blessed $subscription
        && $subscription->roles::DOES('React::Subscription');
    return React::Subscription::Empty->new;
}

# instance methods

sub take ( $self, $n ) { use_module('React::Observable::Take')->new( sequence => $self, n => $n ) }
sub map  ( $self, $f ) { use_module('React::Observable::Map' )->new( sequence => $self, f => $f ) }
sub grep ( $self, $f ) { use_module('React::Observable::Grep')->new( sequence => $self, f => $f ) }

# class methods

sub from ($self, @values) { use_module('React::Observable::From')->new( values => \@values ) }

# class or instance methods

sub concat ($self, @args) {
    use_module('React::Observable::Concat')->new(
        observables => [ (blessed $self ? $self : ()), @args ]
    )
}

sub materialize ($self, @args) {
    use_module('React::Observable::Materialize')->new(
        sequence => (blessed $self ? $self : $args[0])
    )
}

# these can be useful, they don't do much
sub empty ($self)     { React::Observerable->new( producer => sub ($observer) { $observer->on_completed   } ) }
sub error ($self, $e) { React::Observerable->new( producer => sub ($observer) { $observer->on_error( $e ) } ) }
sub never ($self)     { React::Observerable->new( producer => sub ($observer) {                           } ) }

1;

__END__

=pod

=cut
