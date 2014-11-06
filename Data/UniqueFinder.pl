#!/bin/perl -w

# Print Aleph Seq-records with only one LOW-tag

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my $beg_time = time;
my @unique_records;
my @recordnumbers;
my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl UniqueFinder.pl inputfile\n";
}

my $outputfile = $tiedosto . ".uniq";

if (-e $outputfile)
{
	print "File $outputfile exists. Overwrite (y/n)? ";
	chomp(my $choice = <STDIN>);
	if ($choice eq "n")
	{
		die "Quitting.\n";
	}
}

open (my $inputfile, '<:utf8', $tiedosto);
open (OUTPUT, '>:utf8', $outputfile);

print "Processing file \'$tiedosto\', writing into \'$outputfile\'...\n";

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $field = substr($_,10, 3); # Field code
	if ($field eq 'LOW')
	{
		push (@recordnumbers, $id);
	}	
}

my $totalnumberofrecords = uniq @recordnumbers;

@recordnumbers = sort @recordnumbers;

my %counts;
$counts{$_}++ for @recordnumbers;
my @unique;

foreach (keys %counts)
{
	$counts{$_} == 1 ? push (@unique, $_) : next;
}

@unique = sort @unique; # Here are the IDs of records with only one LOW-tag
my $uniquecount = @unique;

my $percentage = $uniquecount / $totalnumberofrecords * 100;
$percentage = sprintf("%.1f", $percentage);

print $uniquecount . " / " . $totalnumberofrecords . " records ($percentage %) had only one LOW-tag.\n";
print "Writing unique records into file.\n";

seek $inputfile, 0, 0; # Reset filehandle position for another iteration

my %unique = map { $_ => 1 } @unique;

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	exists($unique{$id}) ? print OUTPUT $_ : next;
}

my $end_time = time;
my $time = ($end_time - $beg_time) / 60;

print "Done, processing took $time minutes.\n";

close $inputfile;
close OUTPUT;