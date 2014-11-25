#!/bin/perl -w

# Find all records that have only LOW-tags of AMK-libraries and print these to file.

use strict;
use utf8;

binmode(STDOUT, ':utf8');

my $beg_time = time;
my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl findOnlyAMK.pl inputfile\n";
}

my $log = 'findOnlyAMK.log';

my $outputfile = $tiedosto . ".onlyAMK";

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
open (LOG, '>>:utf8', $log);

my %amkTagit = (
	ARKEN => 1,
	AURA => 1,
	CEAMK => 1,
	DIAK => 1,
	HALTI => 1,
	HAMK => 1,
	HURMA => 1,
	JAMK => 1,
	KAMK => 1,
	KARE => 1,
	LAMK => 1,
	LAURE => 1,
	METRO => 1,
	OAMK => 1,
	SAMK => 1,
	SAVON => 1,
	SEAMK => 1,
	TAMK => 1,
	XAMK => 1,
);

my $currentRecordID = 0;
my @currentRecordContent;
my @currentRecordLowTags;
my $onlyAMKRecordCount;
my $totalRecordCount;

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $field = substr($_,10, 3); # Field code
	if ($field eq 'LOW')
	{
		chomp(my $localOwner = substr($_, 21));
		push (@currentRecordLowTags, $localOwner);
	}
	if ($id eq $currentRecordID)
	{
		push (@currentRecordContent, $_);
	}
	else
	{
		$totalRecordCount++;	
		$currentRecordID = $id;
		my @notAMK = grep {! exists($amkTagit{$_}) } @currentRecordLowTags;
		my $notAMK = @notAMK;
		if ($notAMK > 0)
		{
			undef @currentRecordContent;
			undef @currentRecordLowTags;
			undef @notAMK;
			next;
		}
		else
		{
			for (@currentRecordContent)
			{
				print OUTPUT $_;
			}
			$onlyAMKRecordCount++;
			undef @currentRecordContent;
			undef @currentRecordLowTags;
			undef @notAMK;
		}
	}

}

my $onlyAMKPercentage = ($onlyAMKRecordCount / $totalRecordCount * 100);
$onlyAMKPercentage = sprintf("%.1f", $onlyAMKPercentage);

my $end_time = time;
my $time = ($end_time - $beg_time);
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);

my $result = localtime . "\nInput file: $tiedosto
Output file: $outputfile
$onlyAMKRecordCount ($onlyAMKPercentage %) / $totalRecordCount records were only in AMK-libraries.
Processing took $time seconds ($minutes minutes).\n";
$result .= ("-" x 50) . "\n";

print $result;
print LOG $result;

close $inputfile;
close OUTPUT;
close LOG;