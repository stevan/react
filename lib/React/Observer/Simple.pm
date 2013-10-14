package React::Observer;
use v5.16;
use warnings;
use mop;

class Simple with React::Observer {

    has $!on_next is required;
    has $!on_completed = sub {};
    has $!on_error     = sub {};

    method on_next ($val) { $!on_next->( $val ) }
    method on_completed   { $!on_completed->()  }
    method on_error ($e)  { $!on_error->( $e )  }
}

__END__

=pod

=cut