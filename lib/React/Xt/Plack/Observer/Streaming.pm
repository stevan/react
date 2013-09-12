package React::Xt::Plack::Observer;
use v5.16;
use warnings;
use mop;

use React::Core;

class Streaming with React::Core::Observer {
    has $!writer;
    has $!error_msg = "Error: %s";

    method on_next ($val) { $!writer->write( $val ) }

    method on_completed { $!writer->close }

    method on_error ($e) {
        $!writer->write( sprintf $!error_msg, $e );
        $!writer->close;
    }
}

__END__

=pod

=cut