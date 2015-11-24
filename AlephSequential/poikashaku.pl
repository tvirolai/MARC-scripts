#!/bin/perl -w

# Laskee osakohteet (poikastietueet) Aleph Sequential -tiedostosta

use strict;
use utf8;

binmode(STDOUT, ':utf8');

my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl poikashaku.pl inputfile\n";
}

open (my $inputfile, '<:utf8', $tiedosto);

my $poikasCount;

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $field = substr($_,10, 3); # Field code
	if ($field eq '773')
	{
		$poikasCount++;
	}
	else
	{
		next;
	}
}

print "Tiedostossa on \'$tiedosto\' $poikasCount poikastietuetta.\n";
close $inputfile;