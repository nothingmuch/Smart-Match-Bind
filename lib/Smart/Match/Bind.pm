package Smart::Match::Bind;

use 5.010;

use strict;
use warnings;

use Carp qw(croak);
use Smart::Match qw(match array all);

use namespace::clean;

use Sub::Exporter -setup => {
	exports => [qw/
		binding let leta
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

                if ( ref($var) eq 'ARRAY' ) {
                    @$var = @$match;
                } else {
                    $$var = $match;
                }
            }
        };

        $ret;
    }
}

sub _let {
    my ( $binding, $match ) = @_;

    match {
        croak "let() expression evaluated outside of binding context" unless $in_binding;

        my $ret = $_ ~~ $match;

        if ( $ret ) {
            push @bindings, $binding, $_;
        }

        return $ret;
    }
}

sub let (\$$) { _let(@_) }
sub leta (\@$) { _let($_[0], all(array(), $_[1])) }

__PACKAGE__;

__END__


# ex: set sw=4 et:
