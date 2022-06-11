#!perl

use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use Test::More;

use React;
use Test::React::Observer::Recorder;

my $o1 = React::Observable->new(
    producer => sub {
        my $observer = shift;
        $observer->on_next( $_ ) for 0 .. 10;
        $observer->on_completed;
    }
);
isa_ok($o1, 'React::Observable');

my $o2 = React::Observable->new(
    producer => sub {
        my $observer = shift;
        $observer->on_next( $_ ) for 11 .. 20;
        $observer->on_completed;
    }
);
isa_ok($o2, 'React::Observable');

foreach my $m ( $o1->concat($o2), React::Observable->concat($o1, $o2) ) {
    my $r = Test::React::Observer::Recorder->new;
    ok($r->roles::DOES('React::Observer'), '... this object does React::Observer');

    my $s = $m->subscribe( $r );
    ok($s->roles::DOES('React::Subscription'), '... this object does React::Subscription');

    is_deeply( $r->values, [ 0 .. 20 ], '... got the expected values');
    ok($r->is_completed, '... and we have been completed');
}

done_testing;
