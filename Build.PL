use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new
  (
   module_name => 'Devel::Refcount',
   requires => {
   },
   configure_requires => {
                 'ExtUtils::CBuilder' => 0,
                 'Module::Build'      => 0,
   },
   build_requires => {
                 'ExtUtils::CBuilder' => 0,
                 'Module::Build'      => 0,
                 'Test::Exception'    => 0,
                 'Test::More'         => 0,
   },
   license => 'perl',
   create_makefile_pl => 'small',
  );
  
$build->create_build_script;