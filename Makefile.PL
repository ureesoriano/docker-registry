use strict;
use warnings;

use 5.014001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "A client for talking to Docker Registries",
  "AUTHOR" => "Jose Luis Mart\x{ed}nez <joseluis.martinez\@capside.com>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Docker-Registry",
  "LICENSE" => "apache",
  "MIN_PERL_VERSION" => "5.014001",
  "NAME" => "Docker::Registry",
  "PREREQ_PM" => {
    "HTTP::Headers" => 0,
    "HTTP::Tiny" => 0,
    "IO::Socket::SSL" => 0,
    "JSON::MaybeXS" => 0,
    "Moose" => 0,
    "MooseX::Types::Moose" => 0,
    "Throwable::Error" => 0
  },
  "TEST_REQUIRES" => {
    "Sub::Override" => 0,
    "Test::Exception" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.03",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "HTTP::Headers" => 0,
  "HTTP::Tiny" => 0,
  "IO::Socket::SSL" => 0,
  "JSON::MaybeXS" => 0,
  "Moose" => 0,
  "MooseX::Types::Moose" => 0,
  "Sub::Override" => 0,
  "Test::Exception" => 0,
  "Test::More" => 0,
  "Throwable::Error" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);