
use 5.016000;

use strict;
use warnings;

use ExtUtils::MakeMaker 6.30;

my %WriteMakefileArgs = (
  'ABSTRACT'           => 'Functional Reactive Programming for Perl',
  'DISTNAME'           => 'react',
  'AUTHOR'             => 'Stevan Little <stevan.little@iinterative.com>',
  'LICENSE'            => 'perl',
  'NAME'               => 'mop',
  'VERSION'            => '0.01',
  'BUILD_REQUIRES'     => {},
  'CONFIGURE_REQUIRES' => { 'ExtUtils::MakeMaker' => '6.30' },
  'EXE_FILES'          => [],
  'PREREQ_PM'          => {
    'Module::Runtime'          => 0,
    'Scalar::Util'             => 0,
    'warnings'                 => 0,
  },
  'TEST_REQUIRES' => {
    # test modules
    'Test::More'                   => '0.88',
  },
  'test' => {
    'TESTS' => 't/*.t t/*/*.t'
  }
);

unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



