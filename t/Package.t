#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Exporter::Declare ':all';

BEGIN {
    require_ok( 'Exodist::Util::Package' );
    Exodist::Util::Package->import( ':all' );
}

can_ok( __PACKAGE__, qw/
    inject_sub
    package_subs
    package_sub_map
/);

ok( !__PACKAGE__->can( 'xxx' ), "Cannot 'xxx'" );
inject_sub( __PACKAGE__, 'xxx', sub { 'xxx' });
can_ok( __PACKAGE__, 'xxx' );

{
    package AAAA;

    sub a {'a'}
    sub b {'b'}
    sub c {'c'}
}

is_deeply(
    [ sort( package_subs('AAAA')) ],
    [qw/a b c/],
    "Got all subs"
);

is_deeply(
    { package_sub_map('AAAA') },
    { map {( $_ => AAAA->can($_) || undef )} qw/a b c/ },
    "Got sub map"
);

done_testing;
