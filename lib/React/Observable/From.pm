package React::Observable::From;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'React::Observable';
use slots (
    values => sub { +[] },
);

sub build_producer ($self) {
    my @values = $self->{values}->@*;
    return sub {
        my $observer = shift;
        $observer->on_next( $_ ) for @values;
        $observer->on_completed;
    }
}

1;

__END__

=pod

=cut
