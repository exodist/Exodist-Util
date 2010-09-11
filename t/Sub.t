#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

our $CLASS;
BEGIN {
    $CLASS = 'Exodist::Util::Sub';
    require_ok $CLASS;
    $CLASS->import;
}

can_ok( __PACKAGE__, qw/ enhance_sub enhanced_sub esub / );

esub xxx {
    'xxx'
}

can_ok( __PACKAGE__, 'xxx' );
is( xxx(), 'xxx', "esub works" );

isa_ok( \&xxx, 'Exodist::Util::Sub' );
is( (\&xxx)->start_line(), 17 , "got start (or close to it)" );
is( (\&xxx)->end_line(), 18, "got end" );

enhanced_sub yyy {
    'yyy'
}

can_ok( __PACKAGE__, 'yyy' );
is( yyy(), 'yyy', "esub works" );

isa_ok( \&yyy, 'Exodist::Util::Sub' );
is( (\&yyy)->start_line(), 28 , "got start (or close to it)" );
is( (\&yyy)->end_line(), 29, "got end" );

sub aaa {
    'aaa'
}

sub bbb {
    'bbb'
}

sub ccc {
    'ccc'
}

enhance_sub( 'aaa' );
enhance_sub( 'main::bbb' );
enhance_sub( \&ccc );

isa_ok( \&aaa, 'Exodist::Util::Sub' );
isa_ok( \&bbb, 'Exodist::Util::Sub' );
isa_ok( \&ccc, 'Exodist::Util::Sub' );

ok( !(\&aaa)->end_line, "no end line" );
ok( !(\&bbb)->end_line, "no end line" );
ok( !(\&ccc)->end_line, "no end line" );

my $code = esub {
    "blah"
};

isa_ok( $code, 'CODE' );
is( $code->(), 'blah', "Correct code" );
is( $code->start_line, 63, "Got Start" );
is( $code->end_line, 64, "Got End" );

done_testing;
