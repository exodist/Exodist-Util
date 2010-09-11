#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Test::Exception;

BEGIN {
    require_ok( 'Exodist::Util::Loader' );
    Exodist::Util::Loader->import();
    $INC{'CCCC.pm'} = __FILE__;
    $INC{'AAAA/BBBB.pm'} = __FILE__;
}

can_ok( __PACKAGE__, qw/load_package/ );

is( load_package( 'CCCC', 'AAAA' ), 'CCCC', "found CCCC" );
is( load_package( 'BBBB', 'AAAA' ), 'AAAA::BBBB', "found BBBB" );
throws_ok { load_package( 'DDDD', 'AAAA' )}
    qr/Could not find DDDD as DDDD or AAAA::DDDD at/,
    "Cannot load nonexistant package";

done_testing;
