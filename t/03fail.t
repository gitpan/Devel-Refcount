#!/usr/bin/perl -w

use strict;

use Test::More tests => 3;
use Test::Exception;

use Devel::Refcount qw( refcount );

dies_ok( sub { refcount() },
         'refcount with no args fails' );

dies_ok( sub { refcount(undef) },
         'refcount with undef arg fails' );

dies_ok( sub { refcount("hello") },
         'refcount with non-ref arg fails' );
