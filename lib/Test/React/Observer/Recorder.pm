package Test::React::Observer::Recorder;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'UNIVERSAL::Object';
use roles  'React::Observer';
use slots (
    values       => sub { [] },
    errors       => sub { [] },
    is_completed => sub { 0 },
);

sub values       ($self) { $self->{values}       }
sub errors       ($self) { $self->{errors}       }
sub is_completed ($self) { $self->{is_completed} }

sub on_next ($self, $val) {
    push $self->{values}->@* => $val;
}

sub on_completed ($self) { $self->{is_completed} = 1 }

sub on_error ($self, $e) {
    push $self->{errors}->@* => $e;
}

1;

__END__

=pod

=cut
