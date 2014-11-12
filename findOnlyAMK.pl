#!/bin/perl -w

# Find all records that have only AMK-lowtags.

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my $beg_time = time;
my $tiedosto = $ARGV[0];
my $linecount;
my @allRecords;
my @onlyAMK;
my @muut;

if( ! defined $tiedosto )
{
  die "Usage: perl findOnlyAMK.pl inputfile\n";
}

#my $log = 'log.txt';

my $outputfile = $tiedosto . ".WIIHII";

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
#open (OUTPUT, '>:utf8', $outputfile);
#open (LOG, '>>:utf8', $log);

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

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $field = substr($_,10, 3); # Field code
	if ($field eq 'LOW')
	{
		chomp(my $localOwner = substr($_, 21)); # Extract LOW-tag
		push (@allRecords, $id);
		if (!exists($amkTagit{$localOwner}))
		{
			push (@muut, $id);
		}
	}
	$linecount++;	
}

@allRecords = sort @allRecords;
@muut = sort @muut;

# Strip ID's existing in other @muut from @allRecords

my %muut = map { $_ => 1 } @muut;
@onlyAMK = grep {! exists($muut{$_}) } @allRecords;

my $onlyAMK = uniq @onlyAMK;
my $muut = uniq @muut;
my $allRecords = uniq @allRecords;

my $onlyAMKPercentage = $onlyAMK / $allRecords * 100;
$onlyAMKPercentage = sprintf("%.1f", $onlyAMKPercentage);
my $muutPercentage = $muut / $allRecords * 100;
$muutPercentage = sprintf("%.1f", $muutPercentage);

print "Tiedostossa \'$tiedosto\' on
Vain AMK-kirjastoissa olevia tietueita $onlyAMK ($onlyAMKPercentage %)
Muissakin kirjastoissa olevia tietueita $muut ($muutPercentage %)
Yhteensä $allRecords tietuetta
\n";


close $inputfile;
#close OUTPUT;