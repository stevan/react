#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

use React;
use React::Subscription::Empty;

my $s = React::Subscription::Empty->new;
isa_ok($s, 'React::Subscription::Empty');
ok($s->does('React::Subscription'), '... this does React::Subscription');

ok($s->is_unsubscribed, '... this is unsubscribed');

done_testing;