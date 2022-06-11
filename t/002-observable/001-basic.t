#!perl

use v5.24;
use warnings;
use experimental 'signatures', 'postderef';

use Test::More;

use React;
use Test::React::Observer::Recorder;

my $o = React::Observable->new(
    producer => sub {
        my $observer = shift;
        $observer->on_next( $_ ) for 0 .. 10;
        $observer->on_completed;
    }
);
isa_ok($o, 'React::Observable');

{
    my $r = Test::React::Observer::Recorder->new;
    ok($r->roles::DOES('React::Observer'), '... this object does React::Observer');

    my $s = $o->subscribe( $r );
    ok($s->roles::DOES('React::Subscription'), '... this object does React::Subscription');

    is_deeply( $r->values, [ 0 .. 10 ], '... got the expected values');
    ok($r->is_completed, '... and we have been completed');
}

{
    my $r = Test::React::Observer::Recorder->new;
    ok($r->roles::DOES('React::Observer'), '... this object does React::Observer');

    my $s = $o->subscribe( $r );
    ok($s->roles::DOES('React::Subscription'), '... this object does React::Subscription');

    is_deeply( $r->values, [ 0 .. 10 ], '... got the expected values (they have not been drained)');
    ok($r->is_completed, '... and we have been completed');
}

done_testing;
