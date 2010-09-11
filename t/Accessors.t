#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Exporter::Declare ':all';

BEGIN {
    require_ok( 'Exodist::Util::Accessors' );
    Exodist::Util::Accessors->import( ':all' );
}

can_ok( __PACKAGE__, qw/
    accessors
    array_accessors
    category_accessors
/);

accessors qw/a b c/, [ def => sub { 'default' }];
can_ok( __PACKAGE__, qw/a b c def/ );
my $one = bless( {}, __PACKAGE__ );
is( $one->def(), 'default', "default value" );
for my $accessor ( qw/a b c/ ) {
    ok( !$one->$accessor, "No value" );
    is(  $one->$accessor(1), 1, "Set value" );
    is(  $one->$accessor('a'), 'a', "reset value" );
    ok( !$one->$accessor(undef), "clear value" );
    ok( !$one->$accessor, "No value" );
}

array_accessors qw/ d e /;
can_ok( __PACKAGE__, qw/ d e d_ref e_ref push_d push_e pop_d pop_e pull_d pull_e / );

is_deeply( $one->d_ref, [], "simple accessor" );
ok( $one->d_ref != $one->e_ref, "default is not copied" );
is( $one->d(), 0, "no items" );
$one->push_d(qw/a b c/);
is_deeply( $one->d_ref, [qw/a b c/], "pushed" );
is( $one->pop_d, 'c', "popped" );
is( $one->d, 2, "item removed" );
is_deeply( $one->d_ref, [qw/a b/], "pushed" );

$one->d_ref([]);
$one->unshift_d(qw/a b c/);
is_deeply( $one->d_ref, [qw/a b c/], "pushed" );
is( $one->shift_d, 'a', "popped" );
is_deeply( $one->d_ref, [qw/b c/], "pushed" );
is( $one->d, 2, "item removed" );

is_deeply( [$one->pull_d], [qw/b c/], "pull" );
is( $one->d(), 0, "no items" );

category_accessors qw/ f g /;
can_ok( __PACKAGE__, qw/ f g f_ref g_ref push_f push_g pull_f pull_g pull_all_f pull_all_g / );

is( $one->f, 0, "no items" );
$one->push_f( 'a', $one );
is_deeply( [ sort $one->f ], [ sort 'a', $one ], "got all" );
is_deeply( [ sort $one->keys_f ], [ sort '!', __PACKAGE__ ], "got keys" );
is_deeply( [ $one->pull_f( '!' )], ['a'], "Pull !" );
is_deeply( [ $one->f ], [ $one ], "got all" );

$one->push_f( 'a' );
is_deeply( [ sort $one->f ], [ sort 'a', $one ], "got all" );
is_deeply( [ sort $one->keys_f ], [ sort '!', __PACKAGE__ ], "got keys" );

is_deeply( [ sort $one->pull_all_f ], [ sort 'a', $one ], "Pull all" );
is( $one->f, 0, "no items" );

done_testing;
