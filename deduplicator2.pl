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
  die "Usage: perl deduplicator2.pl inputfile\n";
}

open (my $inputfile, '<:utf8', $tiedosto);

my $outputfile = $tiedosto . '.deduplicated';
my $outputfile2 = $tiedosto . '.duplicates';

open (my $output, '>:utf8', $outputfile);
open (my $output_duplicates, '>:utf8', $outputfile2);

#my $log = 'deduplication_log.txt';

my %readIDs;
my @allRecordIDs;
my @deduplicatedIDs;
my $currentRecord = substr(<$inputfile>, 0, 9);
push (@deduplicatedIDs, $currentRecord);
my $recordcount = 0;
my @skippedrecords;
my @everyRecordID;

seek $inputfile, 0, 0;
while (my $line = <$inputfile>)
{
	my $id = substr($line, 0, 9); # Record id
	my $field = substr($line, 10, 3); # Field code
	if ($field eq 'LDR')
	{
		push (@everyRecordID, $id);
	}
	push (@allRecordIDs, $id);
	if (exists($readIDs{$id}))
	{
		push (@skippedrecords, $id);
		print $output_duplicates $line;
		next;
	}
	print $output $line;
	if ($id eq $currentRecord) # When a processed record changes, add previous record ID into %readIDs and current ID as $currentRecord
	{
		next;
	}
	else
	{
		$readIDs{$currentRecord} = 1;
		push (@deduplicatedIDs, $currentRecord);
		$currentRecord = $id;
		$recordcount++;
		print "Processed $recordcount records.\n";
	}
}

my $deduplicatedIDs_check = uniq @allRecordIDs;
my $deduplicatedIDs = @deduplicatedIDs;
my $skippedrecords = uniq @skippedrecords; # Huom! Tässä lasketaan kuinka monta eri tietuetta duplikaateissa on - sama tietue voidaan siis skipata monta kertaa.
my $everyRecord = @everyRecordID;
my $total_check = ($deduplicatedIDs + $skippedrecords);

# Calculate and report processing details

my $end_time = time;
my $time = ($end_time - $beg_time);
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);

print "$deduplicatedIDs unique records, $everyRecord in total, $skippedrecords records skipped.
DEBUG: $deduplicatedIDs_check deduplicated, $total_check in total.\n";

if ($minutes > 1)
{
	print "Done, processing took $time seconds ($minutes minutes).\n";
}
else
{
	print "Done, processing took $time seconds.\n";
}

close $inputfile;
close $output;
close $output_duplicates;