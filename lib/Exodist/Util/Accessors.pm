package Exodist::Util::Accessors;
use strict;
use warnings;

use Exporter::Declare;
use Exodist::Util::Package qw/inject_sub/;
use Scalar::Util qw/blessed/;
use Carp qw/croak/;

our @EXPORT = qw/
    abstract
    accessors
    array_accessors
    category_accessors
/;

sub abstract {
    my $caller = caller;

    for my $name ( @_ ) {
        inject_sub( $caller, $name, sub { croak "$caller does not implement $name()" });
    }
}

sub accessors {
    my $caller = caller;
    for my $accessor (@_) {
        my ( $name, $default ) = ref( $accessor ) ? @$accessor : ( $accessor );
        inject_sub( $caller, $name, _simple_accessor( $name, $default ))
    }
}

sub array_accessors {
    my $caller = caller;
    _array_subs( $caller, $_ ) for @_;
}

sub category_accessors {
    my $caller = caller;
    _category_subs( $caller, $_ ) for @_;
}

sub _simple_accessor {
    my ( $name, $default ) = @_;
    return sub {
        my $self = shift;
        ( $self->{$name} ) = @_ if @_;
        $self->{$name} = $default->()
            if $default && !exists $self->{$name};
        return $self->{$name};
    };
}

sub _array_subs {
    my ( $package, $name ) = @_;
    my $refname     = join( '_', $name,     'ref' );
    my $pullname    = join( '_', 'pull',    $name );
    my $pushname    = join( '_', 'push',    $name );
    my $popname     = join( '_', 'pop',     $name );
    my $unshiftname = join( '_', 'unshift', $name );
    my $shiftname   = join( '_', 'shift',   $name );

    inject_sub( $package, $refname,          _simple_accessor( $refname, sub {[]} ));
    inject_sub( $package, $name,            _arr_all_accessor( $refname,          ));
    inject_sub( $package, $pushname,       _arr_push_accessor( $refname,          ));
    inject_sub( $package, $pullname,       _arr_pull_accessor( $refname,          ));
    inject_sub( $package, $popname,         _arr_pop_accessor( $refname,          ));
    inject_sub( $package, $unshiftname, _arr_unshift_accessor( $refname,          ));
    inject_sub( $package, $shiftname,     _arr_shift_accessor( $refname,          ));
}

sub _category_subs {
    my ( $package, $name ) = @_;
    my $refname     = join( '_', $name,      'ref' );
    my $pullname    = join( '_', 'pull',     $name );
    my $pushname    = join( '_', 'push',     $name );
    my $keysname    = join( '_', 'keys',     $name );
    my $pullallname = join( '_', 'pull_all', $name );

    inject_sub( $package, $refname,           _simple_accessor( $refname, sub {{}} ));
    inject_sub( $package, $name,             _cat_all_accessor( $refname           ));
    inject_sub( $package, $pullname,        _cat_pull_accessor( $refname           ));
    inject_sub( $package, $pushname,        _cat_push_accessor( $refname           ));
    inject_sub( $package, $keysname,        _cat_keys_accessor( $refname           ));
    inject_sub( $package, $pullallname, _cat_pull_all_accessor( $refname           ));
}

sub _cat_pull_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my ( $type ) = @_;
        $type ||= '!';
        my $ref = $self->$refname;
        return @{ delete $ref->{ $type }};
    };
}

sub _cat_push_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        push @{ $ref->{ blessed($_) || '!' }} => $_
            for @_;
    };
}

sub _cat_keys_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        return keys %$ref;
    };
}

sub _cat_all_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my ( $type ) = @_;
        my $ref = $self->$refname;
        return @{ $ref->{ $type }} if $type;
        return( map { @$_ ? (@$_) : () } values %$ref );
    };
}

sub _cat_pull_all_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        my @out = map { @$_ ? (@$_) : () } values %$ref;
        $self->$refname({});
        return @out;
    };
}

sub _arr_all_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        return @$ref;
    };
}

sub _arr_push_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        push @$ref => @_;
    };
}

sub _arr_pull_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        $self->$refname([]);
        return @$ref;
    };
}

sub _arr_pop_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        pop @$ref;
    };
}

sub _arr_unshift_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        unshift @$ref => @_;
    };
}

sub _arr_shift_accessor {
    my ( $refname ) = @_;
    return sub {
        my $self = shift;
        my $ref = $self->$refname;
        shift @$ref;
    };
}

1;

__END__

=head1 EXPORTS

=head2 SIMPLE ACCESSOR GENERATOR

Create simple get/set accessors.

    use Exodist::Util::Accessors qw/ accessors /;
    accessors qw/ accessor_a accessor_b my_thing /;

    ...

    $obj->my_thing( $newval );
    $val = $obj->my_thing();

=head2 ARRAY ACCESSORS AND MANIPULATORS

    use Exodist::Util::Accessors qw/ array_accessors /;
    array_accessors qw/ my_stuff your_stuff /;

    ...

    $obj->push_my_stuff( @values );
    @values = $obj->my_stuff();

The following methods will be created for each item:

=over 4

=item $arrayref = NAME_ref( $arrayref )

Get/set the reference to the array.

=item @list = NAME()

Get the elements of the array

=item push_NAME( $item )

Add an item to the end of the array

=item $item = pop_NAME()

Removes the last item of the array.

=item unshift_NAME( $item )

Add an item to the start of the array

=item $item = shift_NAME()

Removes the first item of the array.

=item @list = pull_NAME()

Clears the values from the object

=back

=head2 CATEGORY ACCESSOR GENERATOR

A Category accessor is an accessor that acts like an array, but keeps elements
seperated by type so that they cane be pulled out without a grep or loop.

    use Exodist::Util::Accessors qw/ category_accessors /;
    category_accessors qw/ my_stuff your_stuff /;

    ...

    $obj->push_my_stuff( @values );
    @values = $obj->my_stuff();
    @subset = $obj->my_stuff( $type );

The following accessors will be created for each item:

=over 4

=item $hashref = NAME_ref( $hashref )

Get/Set the reference storing the category lists.

=item @list = NAME()

Get a list of all the items.

=item @sublist = NAME( $type )

Get a list of all items of a specific subclass.

=item push_NAME( $item )

Add an Item.

=item @list = pull_all_NAME()

Remove all elements of a specific subclass, and return them.

=item @list = pull_NAME( $blessed )

Pulls the subset of values blessed as $blessed.

=item @types = keys_NAME();

Get a list of categories.

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Exodist-Util is free software; Standard perl licence.

Exodist-Util is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
