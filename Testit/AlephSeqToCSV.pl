#!/bin/perl -w

# Aleph Sequential to CSV converter.

use strict;
use utf8;
use List::MoreUtils qw(uniq);

my $beg_time = time;
my $linecount;
my @recordnumbers;
my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl AlephSeqToCSV.pl inputfile\n";
}

my $outputfile = $tiedosto . ".csv";

if (-e $outputfile)
{
	print "File $outputfile exists. Overwrite (y/n)? ";
	chomp(my $choice = <STDIN>);
	if ($choice eq "n")
	{
		die "Quitting.\n";
	}
}

binmode(STDOUT, ':utf8');

open (my $inputfile, '<:utf8', $tiedosto);
open (OUTPUT, '>:utf8', $outputfile);

print "Processing file \'$tiedosto\', writing into \'$outputfile\'...\n";

print OUTPUT "ID,FIELD,I1,I2,FIELD" . "\n\n";
while (<$inputfile>)
{
	my $id = substr($_, 0, 9);
	push (@recordnumbers, $id);
	print OUTPUT $id . ","; # Record ID
	print OUTPUT substr($_,10, 3) . ","; # Field code
	my $ind1 = substr($_, 13, 1); # Ind1
	$ind1 eq ' ' ? print OUTPUT "#" : print OUTPUT $ind1;
	print OUTPUT ",";
	my $ind2 = substr($_, 14, 1); # Ind2
	$ind2 eq ' ' ? print OUTPUT "#" : print OUTPUT $ind2;
	print OUTPUT ",";
	chomp(my $field = substr($_, 18)); # Extract field content into $field
	($field = $field) =~ s/,//g; # Strip commas
	($field = $field) =~ s/\s+[:;.\/]//g; # Strip other punctuation marks
	($field = $field) =~ s/\$+.{1}/,/g; # Strip subfield codes
	($field = $field) =~ s/^,//g; # Strip commas from the beginnings
	($field = $field) =~ s/\s{2,}/ /g; # Normalize multiple whitespaces into one
	($field = $field) =~ s/\s+,/,/g; # Normalize multiple whitespaces into one
	($field = $field) =~ s/,+|[:;.],/,/g; # Normalize multiple commas (from empty subfields) into one
	print OUTPUT $field;
	print OUTPUT "\n";
	$linecount++;
}

@recordnumbers = sort @recordnumbers;
my @unique_records = uniq @recordnumbers;
my $records = @unique_records;
my $end_time = time;
my $time = ($end_time - $beg_time);

print "Done, $linecount lines from $records records processed in $time seconds.\n";

close $inputfile;
close OUTPUT;