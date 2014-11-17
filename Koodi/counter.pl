#!/bin/perl -w

# Count the numbers of Aleph Seq -records in file

use strict;
use utf8;
use List::MoreUtils qw(uniq);

my $beg_time = time;

binmode(STDOUT, ':utf8');

my @recordnumbers;
my $tiedosto = $ARGV[0];
my $linecount = 0;

if( ! defined $tiedosto )
{
  die "Usage: perl counter.pl inputfile\n";
}

open (my $inputfile, '<:utf8', $tiedosto);

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $field = substr($_,10, 3); # Field code
	if ($field eq 'FMT')
	{
		push (@recordnumbers, $id);
	}
	$linecount++;	
}

my $totalnumberofrecords = @recordnumbers;
my $uniqueRecords = uniq @recordnumbers;
my $duplicates = ($totalnumberofrecords - $uniqueRecords);

print "The file $tiedosto contains $totalnumberofrecords records ($uniqueRecords unique records, $duplicates duplicates) in $linecount lines.\n";
my $end_time = time;
my $time = ($end_time - $beg_time);
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);
print "Processing took $time seconds.\n";
close $inputfile;