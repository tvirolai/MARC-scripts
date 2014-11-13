#!/bin/perl -w

# Strip duplicate Aleph Sequential -records from file
# Generates new file with duplicate entries removed
# Note: This script will NOT work for large files, since it reads all data into memory for processing

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

open (my $inputfile, '<:utf8', $tiedosto);

my $outputfile = $tiedosto . 'deduplicated';

my $log = 'deduplication_log.txt';

my @allRecordIDs;
my @deduplicatedRecordIDs;
my @content;

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $fieldCode = substr($_,10, 3); # Field code
	my $fieldContent = substr($_,18); # Field content
	if ($fieldCode eq 'LDR')
	{
		push (@allRecordIDs, $id); # Collect every record ID using leader as source
	}
	push (@content, $_); # Read every line into array
}

@deduplicatedRecordIDs = uniq @allRecordIDs;
my $allRecordIDs = @allRecordIDs;
my $deduplicatedRecordIDs = @deduplicatedRecordIDs;

# Print unique records to file

open (my $output, '>:utf8', $outputfile);

my @deduplicatedContent = uniq @content; # Discard duplicate lines (= records) from @content
for (@deduplicatedContent)
{
	print $output $_;
}

# Calculate and report processing details

my $end_time = time;
my $time = ($end_time - $beg_time);
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);

print "The file $tiedosto contains $allRecordIDs records in total, $deduplicatedRecordIDs different records when duplicates are removed.\n";

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