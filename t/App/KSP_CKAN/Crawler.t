#!/usr/bin/env perl -w

use lib 't/lib/';

use strict;
use warnings;
use v5.010;
use Test::Most;
use Test::Warnings;
use File::Copy qw(copy);
use App::KSP_CKAN::Test;
use App::KSP_CKAN::Tools::Config;

# Setup our environment
my $test = App::KSP_CKAN::Test->new();
$test->create_repo("CKAN-meta");
$test->create_config(nogh => 1);

use_ok("App::KSP_CKAN::Crawler");

my $git = App::KSP_CKAN::Tools::Git->new(
  remote => $test->tmp."/data/CKAN-meta",
  local => $test->tmp,
  clean => 1,
);
$git->pull;

# Config
my $config = App::KSP_CKAN::Tools::Config->new(
  file => $test->tmp."/.ksp-ckan",
);
my $crawler = App::KSP_CKAN::Crawler->new(
  config      => $config,
  _CKAN_meta  => $git,
);

isa_ok($crawler, "App::KSP_CKAN::Crawler");
is(-e $test->tmp."/CKAN-meta/README.md", 1, "Cloned successfully");

my $original_file = $test->tmp."/CKAN-meta/README.md";
my $new_file = "README-2.md";

copy($test->tmp."/CKAN-meta/README.md", $test->tmp."/CKAN-meta/$new_file");

$crawler->_remove_file($original_file, $new_file);
$git->push;

is(-e $original_file, undef, "File removed successfully");

my $test_git = App::KSP_CKAN::Tools::Git->new(
  remote => $test->tmp."/data/CKAN-meta",
  local => $test->tmp."/test/",
  clean => 1,
);
$test_git->pull;

is(-e $test->tmp."/test/CKAN-meta/README.md", undef, "File removal commited to metadata successfully");

# Cleanup after ourselves
$test->cleanup;

done_testing();
__END__
