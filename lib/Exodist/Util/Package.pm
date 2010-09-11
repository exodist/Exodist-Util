package Exodist::Util::Package;
use strict;
use warnings;

use Exporter::Declare;
use Carp qw/croak/;

our @EXPORT = qw/
    inject_sub
/;
our @EXPORT_OK = qw/
    package_subs
    package_sub_map
/;

sub inject_sub {
    my ( $package, $name, $code, $redefine ) = @_;

    croak "You must provide a package name, a sub name, and a coderef"
        unless $package && $name && $code;

    croak "Package must not be a reference (got: $package)"
        if ref( $package );

    croak "Sub name must not be a reference (got: $name)"
        if ref( $name );

    croak "Third argument must be a coderef (got: $code)"
        unless ref( $code ) && ref( $code ) eq 'CODE';

    my $fullname = join( '::', $package, $name );

    if ( $redefine ) {
        no strict 'refs';
        no warnings 'redefine';
        *$fullname = $code;
    }
    else {
        no strict 'refs';
        *$fullname = $code;
    }
}

sub package_subs {
    my ( $package, $match ) = @_;
    $package ||= caller;
    $package = $package . '::';
    no strict 'refs';
    my @list = grep { defined( *{$package . $_}{CODE} )} keys %$package;
    return @list unless $match;
    return grep { $_ =~ $match } @list;
}

sub package_sub_map {
    my ( $package, $match ) = @_;
    $package ||= caller;
    my @list = package_subs( $package, $match );
    return map {( $_ => $package->can( $_ ))} @list;
}

1;

=head1 NAME

Exodist::Util::Package - Exodist's collection of package utility functions

=head1 DEFAULT EXPORTS

=over 4

=item inject_sub( $package, $name, $code, $redefine )

Inject $code as the function/method named $name in package $package. $redefine
should be set to true if you are intentionally redefining an existing sub.

=back

=head1 OPTIONAL EXPORTS

=item @list = package_subs( $package )

=item @list = package_subs( $package, qr/match/ )

Get a list of all subs in a package. The second argument is an optional regex
that will be used to filter the list.

=item %name_to_sub_map = package_sub_map( $package )

=item %name_to_sub_map = package_sub_map( $package, qr/match/ )

Get a map of name => coderef for all subs in a package. Second orgumunt is an
optional regexp filter.

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Exodist-Util is free software; Standard perl licence.

Exodist-Util is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
