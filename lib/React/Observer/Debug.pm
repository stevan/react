package React::Observer::Debug;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'UNIVERSAL::Object';
use roles  'React::Observer';
use slots (
    name => sub {},
);

sub BUILD ($self, $) {
    warn '>>>' . $self->{name} . " started subscribing\n";
}

sub name ($self) { $self->{name} }

sub on_completed ($self) {
    warn $self->{name} . " COMPLETED\n";
}

sub on_error ($self, $exception) {
    warn $self->{name} . " GOT ERROR: $exception\n";
}

sub on_next ($self, $value) {
    warn $self->{name} . " GOT VALUE: $value\n";
}

1;

__END__

=pod

=cut
