package React::Observer::Simple;
use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use parent 'UNIVERSAL::Object';
use roles  'React::Observer';
use slots (
    on_next      => sub { die '`on_next` is required' },
    on_completed => sub {},
    on_error     => sub {},
);

sub on_next      ($self, $val) { $self->{on_next}->( $val ) }
sub on_completed ($self)       { $self->{on_completed}->()  }
sub on_error     ($self, $e)   { $self->{on_error}->( $e )  }

1;

__END__

=pod

=cut
