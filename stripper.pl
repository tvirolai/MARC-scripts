#!/bin/perl -w

# Käsitellään Aleph sequential -tietueita, erotellaan seuraavat tapaukset:
# 1. Ebrary-tietueet
# 2. Osakohdetietueet
# 3. AMK-opinnäytteet

use strict;
use utf8;
binmode(STDOUT, ':utf8');

$| = 1; # Autoflush filehandles

my $beg_time = time;
my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl stripper.pl inputfile\n";
}

my $log = 'stripper.log';
my $outputfile = $tiedosto . ".stripped";
my $outputEbrary = $tiedosto . ".ebrary";
my $outputOpparit = $tiedosto . ".opparit";
my $outputPoikaset = $tiedosto . ".poikaset";

if (-e ($outputfile || $outputEbrary || $outputOpparit || $outputPoikaset))
{
	print "Outputfile(s) exist. Overwrite (y/n)? ";
	chomp(my $choice = <STDIN>);
	if ($choice eq "n")
	{
		die "Quitting.\n";
	}
}

open (my $inputfile, '<:utf8', $tiedosto);
open (my $STRIPPED, '>:utf8', $outputfile);
open (my $EBRARY, '>:utf8', $outputEbrary);
open (my $OPPARIT, '>:utf8', $outputOpparit);
open (my $POIKASET, '>:utf8', $outputPoikaset);
open (LOG, '>>:utf8', $log);

my @ebrary;
my @AMK;
my @poikaset;
my @currentRecordContent;

my $totalRecordCount = 0;
my $ebraryCount = 0;
my $AMKCount = 0;
my $poikasetCount = 0;
my $othersCount = 0;
my $printMileStone = 50000;
my $currentRecordID = 0;

seek $inputfile, 0, 0; # Reset the filehandle

print "Stripping file \'$tiedosto\'...\n";

while (<$inputfile>)
{
	if ($totalRecordCount - $printMileStone == 0)
	{
		print "$totalRecordCount records read...\n";
		$printMileStone += 50000;
	}
	my $id = substr($_, 0, 9); # Record id
	my $fieldcode = substr($_,10, 3); # Field code
	chomp(my $content = substr($_, 18));
	if ($content =~ /Käytettävissä ebrary-palvelun kautta/i)
	{
		push (@ebrary, $id);
		push (@currentRecordContent, $_);
	}
	elsif ($fieldcode eq '509' && ($content =~ /(AMK-opinn(.+)|erikoistyö(.+))(ammattik|oppilait)/i)) # Opinnäytteet
	{
		push (@AMK, $id);
		push (@currentRecordContent, $_);
	}
	elsif ($fieldcode eq '773' && ($content =~ /\$\$7/)) # Poikastietueet
	{
		push (@poikaset, $id);
		push (@currentRecordContent, $_);
	}
	elsif ($id ne $currentRecordID)
	{
		$totalRecordCount++;
		$currentRecordID = $id;
		if (exists $ebrary[0])
		{
			for (@currentRecordContent)
			{
				print $EBRARY $_;
			}
			$ebraryCount++;
			
		}
		elsif (exists $AMK[0])
		{
			for (@currentRecordContent)
			{
				print $OPPARIT $_;
			}
			$AMKCount++;
		}
		elsif (exists $poikaset[0])
		{
			for (@currentRecordContent)
			{
				print $POIKASET $_;
			}
			$poikasetCount++;
		}
		else
		{
			for (@currentRecordContent)
			{
				print $STRIPPED $_;
			}
			$othersCount++;
		}
		undef(@currentRecordContent);
		undef(@AMK);
		undef(@ebrary);
		undef(@poikaset);
	}
	else
	{
		push (@currentRecordContent, $_);
	}
}

my $AMKpercentage = &percentage($AMKCount);
my $poikasetPercentage = &percentage($poikasetCount);
my $ebraryPercentage = &percentage($ebraryCount);
my $othersPercentage = &percentage($othersCount);

########################

my $end_time = time;
my $time = ($end_time - $beg_time);
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);

# Log the process

my $result = localtime . "\nInput file: $tiedosto
Output file: $outputfile
Tiedostossa \'$tiedosto\' on yhteensä $totalRecordCount tietuetta, joista\n
$ebraryCount Ebrary-tietuetta ($ebraryPercentage %)
$poikasetCount poikastietuetta ($poikasetPercentage %)
$AMKCount AMK-opinnäytettä ($AMKpercentage %)
$othersCount muuta tietuetta ($othersPercentage %)\n
Processing took $time seconds.\n";
$result .= ("-" x 50) . "\n";

print $result;
print LOG $result;

close $inputfile;
close $EBRARY;
close $STRIPPED;
close $POIKASET;
close $OPPARIT;
close LOG;

sub percentage
{
	my $count = shift;
	my $percentage = sprintf("%.1f", ($count / $totalRecordCount * 100));
}