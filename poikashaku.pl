#!/bin/perl -w

# Count the numbers of Aleph Seq -records in file

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my @poikaset;
my $tiedosto = $ARGV[0];
my $linecount;
my @allrecords;

if( ! defined $tiedosto )
{
  die "Usage: perl poikashaku.pl inputfile\n";
}

open (my $inputfile, '<:utf8', $tiedosto);


while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $field = substr($_,10, 3); # Field code
	if ($field eq '773')
	{
		push (@poikaset, $id);
	}
	else
	{
		next;
	}
}

my $poikaset = uniq sort @poikaset;

print "Tiedostossa on \'$tiedosto\' $poikaset poikastietuetta.\n";
close $inputfile;