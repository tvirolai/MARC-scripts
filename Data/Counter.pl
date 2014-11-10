#!/bin/perl -w

# Count the numbers of Aleph Seq -records in file

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my @recordnumbers;
my $tiedosto = $ARGV[0];
my $linecount;

if( ! defined $tiedosto )
{
  die "Usage: perl Counter.pl inputfile\n";
}

open (my $inputfile, '<:utf8', $tiedosto);


while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $field = substr($_,10, 3); # Field code
	if ($field eq 'LOW')
	{
		push (@recordnumbers, $id);
	}
	$linecount++;	
}

my $totalnumberofrecords = uniq @recordnumbers;
my $averageRecord = sprintf("%.0f", ($linecount / $totalnumberofrecords));

print "The file $tiedosto contains $totalnumberofrecords records in $linecount lines.
The average length of a record is $averageRecord lines.\n";
close $inputfile;