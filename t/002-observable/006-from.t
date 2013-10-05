#!perl

use strict;
use warnings;
use mop;

use Test::More;

use React;
use Test::React::Observer::Recorder;

my $o = React::Observable->from( 0 .. 10 );
isa_ok($o, 'React::Observable');

{
    my $r = Test::React::Observer::Recorder->new;
    ok($r->does('React::Observer'), '... this object does React::Observer');

    my $s = $o->subscribe( $r );
    ok($s->does('React::Subscription'), '... this object does React::Subscription');

    is_deeply( $r->values, [ 0 .. 10 ], '... got the expected values');
    ok($r->is_completed, '... and we have been completed');
}

{
    my $r = Test::React::Observer::Recorder->new;
    ok($r->does('React::Observer'), '... this object does React::Observer');

    my $s = $o->subscribe( $r );
    ok($s->does('React::Subscription'), '... this object does React::Subscription');

    is_deeply( $r->values, [ 0 .. 10 ], '... got the expected values (they have not been drained)');
    ok($r->is_completed, '... and we have been completed');
}

done_testing;