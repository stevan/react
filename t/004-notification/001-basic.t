#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

use React;
use React::Notification;

{
    my $n = React::Notification->new;
    isa_ok($n, 'React::Notification');

    ok(!$n->is_on_next,     '... this notification is not for next');
    ok(!$n->is_on_error,    '... this notification is not for error');
    ok($n->is_on_completed, '... this notification is for completed');

    ok(!$n->has_value, '... this has no value');
    ok(!$n->has_error, '... this has no error');
}

{
    my $n = React::Notification->new( value => 10 );
    isa_ok($n, 'React::Notification');

    ok($n->is_on_next,       '... this notification is for next');
    ok(!$n->is_on_error,     '... this notification is not for error');
    ok(!$n->is_on_completed, '... this notification is not for completed');

    ok($n->has_value, '... this has a value');
    ok(!$n->has_error, '... this has no error');

    is($n->value, 10, '... got the value we expected');
}

{
    my $n = React::Notification->new( error => "something went wrong" );
    isa_ok($n, 'React::Notification');

    ok(!$n->is_on_next,      '... this notification is not for next');
    ok($n->is_on_error,      '... this notification is for error');
    ok(!$n->is_on_completed, '... this notification is not for completed');

    ok(!$n->has_value, '... this has no value');
    ok($n->has_error, '... this has a error');

    is($n->error, "something went wrong", '... got the error we expected');
}

{
    like(
        exception {
            React::Notification->new( value => 10, error => 'foo' )
        },
        qr/^Notifications cannot have both value and error/,
        '.... got the error we expected'
    );
}



done_testing;