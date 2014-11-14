#!/bin/perl -w

# Strip duplicate Aleph Sequential -records from file
# Generates new file with duplicate entries removed

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my $beg_time = time;

my $tiedosto = $ARGV[0];
my $log = 'deduplication_log.txt';
my $outputfile = $tiedosto . '.deduplicated';

if( ! defined $tiedosto )
{
  die "Usage: perl deduplicator.pl inputfile\n";
}

open (my $inputfile, '<:utf8', $tiedosto);
open (my $output, '>:utf8', $outputfile);
open (LOG, '>>:utf8', $log);

my %readIDs;
my @allRecordIDs;
my @deduplicatedIDs;
my $currentRecord = substr(<$inputfile>, 0, 9);
push (@deduplicatedIDs, $currentRecord);
# This is initialized to 1 as the value is incremented when the processed record changes - not on first iteration
my $deduplicatedRecordcount = 1;
my $recordCount = 0;
my $skipCount = 0;

seek $inputfile, 0, 0;
while (my $line = <$inputfile>)
{
	my $id = substr($line, 0, 9); # Record id
	my $field = substr($line, 10, 3); # Field code
	if ($field eq 'FMT')
	{
		$recordCount++;
	}
	if (exists($readIDs{$id}))
	{
		next;
	}
	print $output $line;
	if ($id eq $currentRecord) 
	{
		next;
	}
	else # When a processed record changes, add previous record ID into %readIDs and current ID as $currentRecord
	{
		$readIDs{$currentRecord} = 1;
		$currentRecord = $id;
		$deduplicatedRecordcount++;
		$skipCount = ($recordCount - $deduplicatedRecordcount);
		print "Processed $recordCount records ($deduplicatedRecordcount unique, $skipCount skipped).\n";
	}
}

# Calculate and report processing details

my $end_time = time;
my $time = ($end_time - $beg_time);
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);

my $result = localtime . "\nInput file: $tiedosto
Output file: $outputfile
$deduplicatedRecordcount records left after deduplication ($recordCount records in total, $skipCount duplicates skipped).
Processing took $time seconds ($minutes minutes).\n";
$result .= ("-" x 50) . "\n";

print $result;
print LOG $result;

close $inputfile;
close $output;
close LOG;