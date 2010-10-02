package Exodist::Util;
use strict;
use warnings;

use Exporter::Declare '-all';

our $VERSION = '0.005';
our @UTIL_PACKAGES = qw/
    Exodist::Util::Package
    Exodist::Util::Alias
    Exodist::Util::Accessors
    Exodist::Util::Loader
    Exodist::Util::Sub
    List::Util
    Scalar::Util
/;

for my $package ( @UTIL_PACKAGES ) {
    eval "require $package; 1" || die $@;
    reexport( $package );
}

#use Data::Dumper;
#print Dumper( export_meta );

1;

__END__

=head1 NAME

Exodist::Util - Exodist's collection of utility functions

=head1 DESCRIPTION

Collection of utility functions. This module ties together several components
into a single module to import. Importing this module is like importing all the
modules listed in the 'SUBMODULES' section.

Using the module will import all the default exports from all submodules. You
may also list what you want imported.

=head1 SYNOPSYS

The example below imports blessed() from Scalar::Util, shuffle() from
List::Util, and alias() from Exodist::Util::Alias all at once.

    use Exodist::Util qw/ blessed shuffle alias ... /;
    alias 'My::Long::Class::Name::ToDoThing';

    my $type = blessed( $obj );
    my ($random) = shuffle(@list);
    my $tdt = ToDoThing->new();

=head1 SUBMODULES

This module rolls all the following into one.

=over 4

=item L<List::Util>

The defacto standard for list functions.

=item L<Scalar::Util>

The defacto standard for Scalar functions.

=item L<Exodist::Util::Package>

Tools for injecting, finding, or mapping subroutines in a given package.

=item L<Exodist::Util::Alias>

Aliasing tools that do not require a 'use' or BEGIN { ...->import }  each time
they are used.

=item L<Exodist::Util::Accessors>

Tools for creating both ultra-minimal accessors, and highly specialized
accessors.

Use the minimal if you don't need anything fancy and don't want a Moose memory
footprint. The highly specialsed are not covered by Moose and would likely be
very verbose to define in Moose.

=item L<Exodist::Util::Loader>

Useful for shortening plugin package names while allowing plugins outside the
plugin namespace. Check for package as-is, then check for package nested in a
specific namespace.

=item L<Exodist::Util::Sub>

Enhance existing subs or define new subs as enhanced. Enhanced subs can be
directly queried for information such as start/end lines, etc.

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Exodist-Util is free software; Standard perl licence.

Exodist-Util is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
