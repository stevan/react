#!perl

use strict;
use warnings;
use mop;

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

foreach my $m ( $o->materialize, React::Observable->materialize( $o ) ) {
    my $r = Test::React::Observer::Recorder->new;
    ok($r->does('React::Observer'), '... this object does React::Observer');

    my $s = $m->subscribe( $r );
    ok($s->does('React::Subscription'), '... this object does React::Subscription');

    my $values = $r->values;
    is_deeply(
        $values,
        [
            (map { React::Notification->new( value => $_ ) } 0 .. 10),
            React::Notification->new
        ],
        '... got the expected values'
    );

    foreach my $i ( 0 .. 10 ) {
        ok($values->[$i]->is_on_next, '... this notification is on-next');
        ok($values->[$i]->has_value, '.... we have a value');
        is($values->[$i]->value, $i, '... the value is as we expected');
    }

    ok($values->[-1]->is_on_completed, '... this notification is on-completed');
    ok($r->is_completed, '... and we have been completed');
}

{
    my $r = Test::React::Observer::Recorder->new;
    ok($r->does('React::Observer'), '... this object does React::Observer');

    my $s = $o->subscribe( $r );
    ok($s->does('React::Subscription'), '... this object does React::Subscription');

    is_deeply( $r->values, [ 0 .. 10 ], '... got the expected values from the original obseverable');
    ok($r->is_completed, '... and we have been completed');
}

done_testing;