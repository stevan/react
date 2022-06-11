package ReactX::Plack::Observer::Streaming;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'UNIVERSAL::Object';
use roles  'React::Observer';
use slots (
    writer    => sub {},
    error_msg => sub { "Error: %s" };
);

sub on_next ($self, $val) { $self->{writer}->write( $val ); }

sub on_completed ($self) { $self->{writer}->close }

sub on_error ($self, $e) {
    $self->{writer}->write( sprintf $!error_msg, $e );
    $self->{writer}->close;
}

1;

__END__

=pod

=cut
