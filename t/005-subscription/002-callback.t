#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

use React;
use React::Subscription::Callback;

my $called = 0;

my $s = React::Subscription::Callback->new(
    cb => sub { $called++ }
);

isa_ok($s, 'React::Subscription::Callback');
ok($s->does('React::Subscription'), '... this does React::Subscription');

ok(!$s->is_unsubscribed, '... this is not yet unsubscribed');

ok(!$called, '... unsubscribe was not yet called');
$s->unsubscribe;
ok($called, '... unsubscribe was called');

ok($s->is_unsubscribed, '... this is unsubscribed');

done_testing;