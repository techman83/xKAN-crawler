package App::KSP_CKAN::Crawler::MirrorCKAN;

use v5.010;
use strict;
use warnings;
use autodie;
use Method::Signatures 20140224;
use File::chdir;
use File::Path qw( mkpath );
use File::Basename qw(basename);
use Scalar::Util 'reftype';
use Try::Tiny;
use Carp qw(croak);
use Moo;
use namespace::clean;

extends 'App::KSP_CKAN::Mirror';

# ABSTRACT: CKAN Mirror on demand

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

  use App::KSP_CKAN::WebHooks::MirrorCKAN;
  
  my $mirror = App::KSP_CKAN::WebHooks::MirrorCKAN->new();
  $mirror->mirror("/path/to/ckan");

=head1 DESCRIPTION

Webhook wrapper for Mirror CKAN on demand.

=cut

my $Ref = sub {
  croak("config isn't a 'App::KSP_CKAN::Tools::Config' object!") unless $_[0]->DOES("App::KSP_CKAN::Tools::Config");
};

my $Meta = sub {
  croak("CKAN_meta isn't a 'App::KSP_CKAN::Tools::Git' object!") unless $_[0]->DOES("App::KSP_CKAN::Tools::Git");
};

has 'config'      => ( is => 'ro', required => 1, isa => $Ref );
has 'CKAN_meta'   => ( is => 'ro', required => 1, isa => $Meta );
has 'cache'       => ( is => 'ro', required => 1 );

method _check_cached($hash) {
  my @files = glob($self->cache."/*");
  my $index = first_index { basename($_) =~ /^$hash/i } @files;
  if ( $index != '-1' ) {
    return $files[$index];
  }
  return 0;
}

method mirror($files) {
  # Lets take an array as well! 
  my @files = reftype \$files ne "SCALAR" ? @{$files} : $files;

  # Prepare Enironment
  local $CWD = $self->config->working."/".$self->CKAN_meta->working;

  foreach my $file (@files) {
    # Lets not try mirroring non existent files
    if (! -e $file) {
      $self->warn("The ckan '".$file."' doesn't appear to exist");
      next;
    }
    
    # Attempt Mirror
    #try {
      $self->upload_ckan($file);
    #};
  }

  return 1;
}

1;
