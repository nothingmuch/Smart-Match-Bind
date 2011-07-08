#!/usr/bin/perl

use 5.010;

use strict;
use warnings;

use Test::More;
use Test::Exception;

use Smart::Match qw(:all);

use ok 'Smart::Match::Bind', qw(:all);

my @results;

my @inputs = ([ ], [qw(foo bar)], [qw(foo 4)] );

for (@inputs) {
    my ( $name, $age );

    when (binding([
        let( $name, qr/\w+/ ),
        let( $age, qr/\d+/ ),
    ])) {
        push @results, [ bound => $_, $name, $age ];
    };
    default {
        push @results, [ unbound => $_, $name, $age ];
    }
}

is_deeply(
    \@results,
    [
        [ unbound => $inputs[0], undef, undef ],
        [ unbound => $inputs[1], undef, undef ],
        [ bound   => $inputs[2], "foo", 4 ],
    ],
    "all bindings processed correctly",
);

ok( [qw(foo bar)] ~~ binding( leta( my @array, true ) ), "let array match" );
is_deeply( \@array, [qw(foo bar)], "array filled" );

ok( not( [qw(foo bar)] ~~ binding( leta( my @array2, false ) ) ), "let array non-match" );
is_deeply( \@array2, [], "no binding" );

throws_ok {
    "foo" ~~ let(my $x, qr/./);
} qr/binding context/;

done_testing;

# ex: set sw=4 et:

