#!/bin/perl -w

# Strip duplicate Aleph Sequential -records from file
# Generates new file with duplicate entries removed

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my $beg_time = time;

my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl deduplicator.pl inputfile\n";
}

my $outputfile = $tiedosto . 'deduplicated';

my $log = 'deduplication_log.txt';