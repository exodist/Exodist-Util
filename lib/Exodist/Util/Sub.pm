package Exodist::Util::Sub;
use strict;
use warnings;

use Exporter::Declare;
use Exodist::Util::Package qw/inject_sub/;
use Carp qw/croak/;
use B;

our @EXPORT = qw/
    enhance_sub
/;

our %STASH;

export( 'enhanced_sub', 'sublike' );
export( 'esub', 'sublike', \&enhanced_sub );

sub new {
    my $class = shift;
    my %proto = @_;
    my $code = delete $proto{sub} || croak "No code provided";
    my $self = bless( $code, $class );
    $STASH{ $self } = \%proto;
    return $self;
}

sub stash {
    my $self = shift;
    return $STASH{ $self };
}

sub enhanced_sub {
    my ( $name, $code ) = @_;
    my ( $caller, $file, $line ) = caller;

    inject_sub( $caller, $name, $code )
        if $name;

    my $self = __PACKAGE__->new(
        sub => $code,
        end_line => $line,
    );

    return $code;
}

sub enhance_sub {
    my ($in) = @_;
    my $ref;
    if (ref $in and ref $in eq 'CODE' ) {
        $ref = $in;
    }
    else {
        $in =~ m/(.*::)?([^:]+)$/;
        my ( $caller, $sub ) = ( $1, $2 );
        $caller =~ s/::$// if $caller;
        $caller ||= caller;
        $ref = \&{ "$caller\::$sub" }
    }
    return __PACKAGE__->new( sub => $ref );
}

sub start_line {
    my $self = shift;
    return B::svref_2object( $self )->START->line;
}

sub end_line {
    my $self = shift;
    return $STASH{ $self }->{end_line};
}

sub original_name {
    my $self = shift;
    return B::svref_2object( $self )->GV->NAME;
}

sub is_anon {
    my $self = shift;
    return $self->original_name eq '__ANON__' ? 1 : 0;
}

sub original_package {
    my $self = shift;
    return B::svref_2object( $self )->GV->STASH->NAME;
}

sub DESTROY {
    my $self = shift;
    delete $STASH{ $self };
}

1;

=head1 NAME

Exodist::Util::Sub - Subroutines with advanced information attached.

=head1 DESCRIPTION

This package allows you to enhance subs such that they can be directly queried
for information. You can also directly create enhanced subs.

=head1 SYNOPSYS

    package MyPackage;
    use strict;
    use warnings;
    use Exodist::Util::Sub;

    esub print_hi {
        print "hi\n";
    }

    enhanced_sub print_bye {
        print "bye\n";
    }

    sub print_ps {
        print "ps\n";
    }
    enhance_sub 'print_ps';

    sub print_pps {
        print "pps\n"
    }
    enhance_sub \&print_pps;

    sub print_ppps {
        print "ppps\n"
    }
    enhance_sub 'MyPackage::print_ppps';

    my $code = esub {
        print "code\n"
    }

    $code->(); # prints 'code'
    print $code->start_line(); # prints the approximate line on which the sub
                               # definition started.
    print $code->end_line();   # Same but the lane where the definition ended

    (\&print_hi)->start_line();
    (\&print_hi)->original_name;
    (\&print_hi)->original_package;
    (\&print_hi)->is_anon;

=head1 CREATING ENHANCED SUBS

    esub print_hi {
        print "hi\n";
    }

    enhanced_sub print_bye {
        print "bye\n";
    }

=head1 ENHANCING EXISTING SUBS

    sub print_ps {
        print "ps\n";
    }
    enhance_sub 'print_ps';

=head1 METHODS ATTACHED TO ENHANCED SUBS

=over 4

=item (\&sub)->start_line()

Get the starting line on which the sub was defined (from L<B>)

=item (\&sub)->end_line()

Get the last line on which the sub was defined. (Only available for subs
created as enhanced.)

=item (\&sub)->original_name()

Returns the original name given to the sub. (Only available on subs enhanced
after the fact.)

=item (\&sub)->is_anon()

Returns true if the sub was declared as an anonymous sub.

=item (\&sub)->original_package()

Returns the name of the package in which the sub was defined.

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Exodist-Util is free software; Standard perl licence.

Exodist-Util is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
