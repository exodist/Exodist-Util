package Exodist::Util::Alias;
use strict;
use warnings;

use Exporter::Declare;
use Exodist::Util::Package qw/ inject_sub /;

gen_export( qw/alias begin/, sub {
    my ( $exporting_class, $importing_class ) = @_;
    sub {
        for my $package ( @_ ) {
            eval "require $package; 1" || die $@;
            my $short = $package;
            $short =~ s/.*:([^:]+)$/$1/g;
            inject_sub( $importing_class, $short, sub { $package });
        }
    };
});

gen_export( qw/alias_to begin/, sub {
    my ( $exporting_class, $importing_class ) = @_;
    sub {
        my %pairs = @_;
        for my $short ( keys %pairs ) {
            my $package = $pairs{ $short };
            eval "require $package; 1" || die $@;
            inject_sub( $importing_class, $short, sub { $package });
        }
    }
});

1;

__END__

=head1 NAME

Exodist::Util::Alias - Yet another set of aliasing tools

=head1 EXPORTS

All exports use L<Devel::BeginLift>. This means they are run at compile time
rather than run-time. This is the same os if they have been wrapped in a BEGIN
block.

=over 4

=item alias( @PACKAGES )

This will load all tha packages specified as arguments (require, no import).
Once loaded a subroutine named after the last segmant of the package name will
be created which returns the whole package name as a string.

    use Exodist::Util::Alias;
    alias qw/
        My::Package::MyA
        My::Package::MyB
    /;

    my $a = MyA->new();
    my $b = MyB->new();

=item alias_to( Alias => 'Package', ... )

Like alias() except you provide a map of alias names and packages to which they
should map. Like alias it will auto-require tho packages for you.

    use Exodist::Util::Alias;
    alias_to MyA => My::Package::OtherA,
             MyB => My::Package::OtherB;

    my $a = MyA->new();
    my $b = MyB->new();

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Exodist-Util is free software; Standard perl licence.

Exodist-Util is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
