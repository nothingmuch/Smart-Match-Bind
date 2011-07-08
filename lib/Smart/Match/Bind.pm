package Smart::Match::Bind;

use 5.010;

use strict;
use warnings;

use Carp qw(croak);
use Smart::Match qw(match);

use namespace::clean;

use Sub::Exporter -setup => {
	exports => [qw/
		binding let
    /],
};


our @bindings;
our $in_binding;

sub binding ($) {
    my $match = shift;

    match {
        local @bindings;
        local $in_binding = 1;

        my $ret = $_ ~~ $match;

        if ( $ret ) {
            while ( @bindings ) {
                my ( $var, $match ) = splice @bindings, 0, 2;
                $$var = $match;
            }
        };

        $ret;
    }
}

sub let ($$) {
    my $binding = \$_[0];
    my $match = $_[1];

    match {
        croak "let() expression evaluated outside of binding context" unless $in_binding;

        my $ret = $_ ~~ $match;

        if ( $ret ) {
            push @bindings, $binding, $_;
        }

        return $ret;
    }
}

__PACKAGE__;

__END__


# ex: set sw=4 et:
