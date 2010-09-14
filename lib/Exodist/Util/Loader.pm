package Exodist::Util::Loader;
use strict;
use warnings;

use Exporter::Declare;
use Carp qw/croak/;

our @EXPORT = qw/ load_package /;

sub load_package {
    my ($name, $namespace) = @_;

    my @options = ( $name );
    push @options => "$namespace\::$name" if $namespace;

    @options = reverse @options
        if $name =~ m/::/;

    for my $pkg ( @options ) {
        return $pkg if eval "require $pkg; 1";
        my $file = $pkg;
        $file =~ s|::|/|g;
        croak( $@ ) unless $@ =~ m{Can't locate /?$file\.pm in \@INC};
    }

    croak( "Could not find $name as " . join( ' or ', @options ));
}

1;

__END__

=head1 NAME

Exodist::Util::Loader - Shorten plugin package names while allowing plugins outside the plugin namespace.

=head1 EXPORTS

=over 4

=item load_package( $package, $prefix )

Finds and loads $package. $prefix will be appended to $package if $package
cannot be found as-is. If package cannot be found in either option an exception
is thrown.

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Exodist-Util is free software; Standard perl licence.

Exodist-Util is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
