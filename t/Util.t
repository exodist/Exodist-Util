#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Exporter::Declare ':all';
use Exodist::Util qw/alias alias_to/;

{
    package AllExports;
    use Test::More;
    use Exodist::Util ':all';

    package DefaultExports;
    use Test::More;
    use Exodist::Util;
}

AllExports->can_ok( qw/
    shuffle
    blessed
    inject_sub
    package_subs
    package_sub_map
    enhance_sub
    enhanced_sub
    esub
    alias
    alias_to
    load_package
    accessors
    array_accessors
    category_accessors
/);

ok( ! DefaultExports->can($_), "$_ not imported by default" )
    for qw/shuffle blessed package_subs/;

DefaultExports->can_ok( qw/
    inject_sub
    enhance_sub
    enhanced_sub
    esub
    alias
    alias_to
    load_package
    accessors
    array_accessors
    category_accessors
/);

# Test the BEGIN lift behavior
can_ok( __PACKAGE__, qw/
    alias
    alias_to
    Package
    Sub
    Accessors
    xxx
    yyy
    zzz
/);

alias 'Exodist::Util::Package';
alias qw/
    Exodist::Util::Sub
    Exodist::Util::Accessors
/;

alias_to xxx => 'Exodist::Util::Package';
alias_to
    yyy => 'Exodist::Util::Sub',
    zzz => 'Exodist::Util::Accessors';

is( Package,   'Exodist::Util::Package',   "Alias Package" );
is( Sub,       'Exodist::Util::Sub',       "Alias Sub"     );
is( Accessors, 'Exodist::Util::Accessors', "Alias Accessors" );

is( xxx, 'Exodist::Util::Package',   "Alias xxx to Package"   );
is( yyy, 'Exodist::Util::Sub',       "Alias yyy to Sub"       );
is( zzz, 'Exodist::Util::Accessors', "Alias zzz to Accessors" );

done_testing;
