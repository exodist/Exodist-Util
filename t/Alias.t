#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Exporter::Declare ':all';

BEGIN {
    require_ok( 'Exodist::Util::Alias' );
    Exodist::Util::Alias->import( ':all' );
}

# Can comes before aliases because they should run in BEGIN blocks.
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
