package React;
use v5.16;
use warnings;
use mop;

role Subscription {
    method unsubscribe;
    method is_unsubscribed;
}

__END__

=pod

=cut