#!/usr/bin/perl
use 5.008;
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    module_name => 'Exodist::Util',
    license     => 'perl',
    dist_author => 'Chad Granum <exodist7@gmail.com>',
    create_readme => 1,
    requires => {
        'perl'                     => 5.008,
        'Exporter::Declare'        => '0.107',
        'Exporter::Declare::Magic' => '0.107',
        'Hash::FieldHash'          => '0.09',
        'Scalar::Util'             => 0,
        'List::Util'               => 0,
        'Devel::Declare::Parser'   => '0.017',
    },
    build_requires => {
        'Test::More'      => 0.88,
        'Test::Exception' => 0,
    },
    meta_merge => {
        resources => {
            repository => 'http://github.com/exodist/Exodist-Util',
            bugtracker => 'http://github.com/exodist/Exodist-Util/issues',
            homepage   => 'http://open-exodus.net/projects/Exodist-Util'
        },
    }
);

$build->create_build_script;
