package Exodist::Util;
use strict;
use warnings;

use Exporter::Declare;

our $VERSION = '0.002';
our @UTIL_PACKAGES;

our @EXPORT;
our %EXPORT;
our %GEN_EXPORT;
our @EXPORT_OK;
our %EXPORT_OK;
our %GEN_EXPORT_OK;
our %PARSERS;

BEGIN {
    @UTIL_PACKAGES = qw/
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
        no strict 'refs';
        no warnings 'once';
        my $is_declare = $package->can('export_to')
            && $package->can('export_to') == Exporter::Declare->can('export_to');

        $package->import(
            $is_declare ? (':all') : (
                @{ "$package\::EXPORT" },
                @{ "$package\::EXPORT_OK" }
            )
        );

        push @EXPORT => @{ "$package\::EXPORT" };
        push @EXPORT_OK => @{ "$package\::EXPORT_OK" };

        if ( $is_declare ) {
            %PARSERS       = ( %PARSERS,       %{ "$package\::PARSERS"       });
            %EXPORT        = ( %EXPORT,        %{ "$package\::EXPORT"        });
            %EXPORT_OK     = ( %EXPORT_OK,     %{ "$package\::EXPORT_OK"     });
            %GEN_EXPORT    = ( %GEN_EXPORT,    %{ "$package\::GEN_EXPORT"    });
            %GEN_EXPORT_OK = ( %GEN_EXPORT_OK, %{ "$package\::GEN_EXPORT_OK" });
        }
    }

}

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

=head1 SUBMODULES

This module rolls all the following into one.

=over 4

=item L<List::Util>

=item L<Scalar::Util>

=item L<Exodist::Util::Package>

=item L<Exodist::Util::Alias>

=item L<Exodist::Util::Accessors>

=item L<Exodist::Util::Loader>

=item L<Exodist::Util::Sub>

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Exodist-Util is free software; Standard perl licence.

Exodist-Util is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
