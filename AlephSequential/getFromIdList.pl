#!/bin/perl -w

# Tulostaa Aleph sequential -tiedostosta argumenttina annetun ID-listan tietueet tiedostoon

use strict;
use utf8;

binmode(STDOUT, ':utf8');

my $listFile = $ARGV[0];
my $tiedosto = $ARGV[1];

if( ! defined ($listFile && $tiedosto) )
{
  die "Usage: perl getFromIdList.pl idlistfile filetoread\n";
}

my $outputfile = $tiedosto . ".output";

open (my $lista, '<:utf8', $listFile);
open (my $inputfile, '<:utf8', $tiedosto);
open (OUTPUT, '>:utf8', $outputfile);

my %recordIDs;

while (<$lista>)
{
	chomp;
	$recordIDs{$_} = 1;
}

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	exists $recordIDs{$id} ? print OUTPUT $_ : next;
}

my $recordCount = keys %recordIDs;

print "Done, $recordCount records written into $outputfile.\n";

close $inputfile;
close $lista;
close OUTPUT;