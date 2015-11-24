#!/bin/perl -w

# Extract interesting information from records and write to textfiles

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my $beg_time = time;
my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl extractor.pl inputfile\n";
}

open (my $inputfile, '<:utf8', $tiedosto);
open (my $KIELET, '>:utf8', $tiedosto . '.041');
open (my $SISALTOJAMEDIA, '>:utf8', $tiedosto . '.336-337');
open (my $SISALTOTYYPPI, '>:utf8', $tiedosto . '.336');
open (my $MEDIATYYPPI, '>:utf8', $tiedosto . '.337');
open (my $YKL, '>:utf8', $tiedosto . '.084');
open (my $KEYWORDS, '>:utf8', $tiedosto . '.650_651_CSV');
open (my $KEYWORDS2, '>:utf8', $tiedosto . '.650_651_vain_sanat');
open (my $THESAURI,'>:utf8', $tiedosto . '.650_651_2');
open (my $VUOSI,'>:utf8', $tiedosto . '.vuosi');


my $currentRecord = substr(<$inputfile>, 0, 9); # Read the ID of the first record in file
seek $inputfile, 0, 0;
my $recordCount = 1;
my $langCodes;
my $YKLCount;
my $keyWordsCount;
my $sisaltoTyyppiCount;
my $mediaTyyppiCount;

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $fieldCode = substr($_, 10, 3); # Field code
	my $fieldContent = substr($_, 18); # Field content
	if ($fieldCode eq '041')
	{
		my @langCodes = split('\$\$', $fieldContent);
		for (@langCodes) # Format codes as follows: a,fin (subfield code,language code)
		{
			chomp;
			# Skip empty fields
			length($_) > 2 ? $_ = (substr($_, 0, 1) . "," . substr($_, 1, 3)) : next;
			print $KIELET $_ . "\n";
			$langCodes++;
		}
	}

	elsif ($fieldCode eq '084' && $fieldContent =~ /2ykl/i)
	{
		chomp;
		if ($fieldContent =~ /(\d+).(\d+)/)
		{
			print $YKL $& . "\n";
			$YKLCount++;
		}
	}

	elsif ($fieldCode eq ('650' || '651'))
	{
		my @kwContent = split('\$\$', $fieldContent);
		for (@kwContent) # Format codes as follows: a,fin (subfield code,language code)
		{
			chomp;
			if (substr($_, 0, 1) =~ /2/) { print $THESAURI substr($_, 1) . "\n"; next; }
			if (substr($_, 0, 1) =~ /9/) { next; } # Throw away fields like $9FENNI<KEEP>
			length($_) > 2 ? print $KEYWORDS ($_ = (substr($_, 0, 1) . "," . substr($_, 1) . "\n")) : next;
			length($_) > 2 ? print $KEYWORDS2 ($_ = substr($_, 2)): next;
			$keyWordsCount++;
		}
	}

	elsif ($fieldCode eq ('336'))
	{
		my @sisaltotyyppi_split = split('\$\$a', $fieldContent);
		for (@sisaltotyyppi_split)
		{
			chomp;
			unless (length $_ < 2) 
			{
				print $SISALTOTYYPPI $_ . "\n";
				print $SISALTOJAMEDIA "336," . $_ . "\n";
				$sisaltoTyyppiCount++;
			}
		}
	}

	elsif ($fieldCode eq ('337'))
	{
		my @mediatyyppi_split = split('\$\$a', $fieldContent);
		for (@mediatyyppi_split)
		{
			chomp;
			unless (length $_ < 2) 
			{
				print $MEDIATYYPPI $_ . "\n";
				print $SISALTOJAMEDIA "337," . $_ . "\n";
				$mediaTyyppiCount++;
			}
		}
	}
	elsif ($fieldCode eq ('008'))
	{
		my $vuosi = substr($fieldContent, 7, 4);
		print $VUOSI $vuosi . "\n";
	}

	elsif ($currentRecord ne $id)
	{
		$recordCount++;
		$currentRecord = $id;
	}
}

$recordCount++;
my $end_time = time;
my $time = ($end_time - $beg_time);
my $recPerSec = $recordCount / $time;
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);

$recPerSec = sprintf("%.1f", $recPerSec);
my $langPerRec = &perRec($langCodes);
my $YKLPerRec = &perRec($YKLCount);
my $kwPerRec = &perRec($keyWordsCount);
my $sisaltoTyyppiPerRec = &perRec($sisaltoTyyppiCount);
my $mediaTyyppiPerRec = &perRec($mediaTyyppiCount);

print "\nDone.\n";

print "$langCodes language codes ($langPerRec / record on average)
$YKLCount classification codes ($YKLPerRec / record on average)
$keyWordsCount keywords ($kwPerRec / record on average)
$sisaltoTyyppiCount content types ($sisaltoTyyppiPerRec / record on average)
$mediaTyyppiCount media types ($mediaTyyppiPerRec / record on average)
read from $recordCount records.\n";

print "Processing took $time seconds ($recPerSec records / second).\n";

close $inputfile;
close $KIELET;
close $SISALTOTYYPPI;
close $MEDIATYYPPI;
close $YKL;
close $KEYWORDS;
close $KEYWORDS2;
close $THESAURI;

sub perRec
{
	my $count = shift;
	my $perRec = sprintf("%.1f", ($count / $recordCount));
}
