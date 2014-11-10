#!/bin/perl -w

# Käsitellään Aleph sequential -tietueita, karsitaan seuraavat tapaukset:
# 1. Ebrary-tietueet
# 2. Osakohdetietueet
# 3. AMK-opinnäytteet

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my $beg_time = time;
my @ebrary;
my @AMK;
my @poikaset;
my @others;
my @total;
my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl Stripper.pl inputfile\n";
}

my $log = 'stripper_log.txt';

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

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $fieldcode = substr($_,10, 3); # Field code
	chomp(my $content = substr($_, 18));
	if ($content =~ /ebrary-palvelun kautta/i)
	{
		push (@ebrary, $id);
		push (@total, $id);

	}
	elsif ($fieldcode eq '509' && ($content =~ /(AMK-opinn(.+)|erikoistyö(.+))(ammattik|oppilait)/i)) # Opinnäytteet
	{
		push (@AMK, $id);
		push (@total, $id);
	}
	elsif ($fieldcode eq '773') # Poikastietueet
	{
		push (@poikaset, $id);
		push (@total, $id);
	}
	else
	{
		push (@others, $id);
		push (@total, $id);
	}
}

@ebrary = uniq (sort @ebrary);
@AMK = uniq (sort @AMK);
@poikaset = uniq (sort @poikaset);
@others = uniq (sort @others);
@total = uniq (sort @total);

# Strip ID's existing in other arrays from @others

my @toStrip = sort (@ebrary, @AMK, @poikaset);
my %toStrip = map { $_ => 1 } @toStrip;
@others = grep {! exists($toStrip{$_}) } @others;

my $ebrary = @ebrary;
my $AMK = @AMK;
my $poikaset = @poikaset;
my $others = @others;
my $total = @total;

my $AMKpercentage = ($AMK / $total * 100);
$AMKpercentage = sprintf("%.1f", $AMKpercentage);
my $poikasetPercentage = ($poikaset / $total * 100);
$poikasetPercentage = sprintf("%.1f", $poikasetPercentage);
my $ebraryPercentage = ($ebrary / $total * 100);
$ebraryPercentage = sprintf("%.1f", $ebraryPercentage);
my $othersPercentage = ($others / $total * 100);
$othersPercentage = sprintf("%.1f", $othersPercentage);

print "\nTiedostossa \'$tiedosto\' on yhteensä $total tietuetta, joista\n
$ebrary Ebrary-tietuetta ($ebraryPercentage %)
$poikaset poikastietuetta ($poikasetPercentage %)
$AMK AMK-opinnäytettä ($AMKpercentage %)
$others muuta tietuetta ($othersPercentage %)\n\n";

########################

# Print records into files

my %ebrary = map { $_ => 1 } @ebrary;
my %AMK = map { $_ => 1 } @AMK;
my %poikaset = map { $_ => 1 } @poikaset;
my %others = map { $_ => 1 } @others;

seek $inputfile, 0, 0; # Reset filehandle position for another iteration

# Ebrary-tietueet

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	exists($ebrary{$id}) ? print $EBRARY $_ : next;
}

# Opinnäytteet

seek $inputfile, 0, 0; 

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	exists($AMK{$id}) ? print $OPPARIT $_ : next;
}

# Poikaset

seek $inputfile, 0, 0; 

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	exists($poikaset{$id}) ? print $POIKASET $_ : next;
}

# Karsinnan jälkeen jäljelle jäävät tietueet

seek $inputfile, 0, 0; 

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	exists($others{$id}) ? print $STRIPPED $_ : next;
}

########################

my $end_time = time;
my $time = ($end_time - $beg_time);
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);

# Log the process

print LOG localtime . "\nInput file: $tiedosto

Output files: $outputfile, $outputEbrary, $outputOpparit, $outputPoikaset

$total records in total
$ebrary Ebrary-tietuetta ($ebraryPercentage %)
$poikaset poikastietuetta ($poikasetPercentage %)
$AMK AMK-opinnäytettä ($AMKpercentage %)
$others muuta tietuetta ($othersPercentage %)\n\n";

if ($minutes > 1)
{
	print "Done, processing took $time seconds ($minutes minutes).\n";
	print LOG "Processing time: $time seconds ($minutes minutes)\n";
}
else
{
	print "Done, processing took $time seconds.\n";
	print LOG "Processing time: $time seconds\n";
}

print LOG ("-" x 50) . "\n";

close $inputfile;
close $STRIPPED;
close $EBRARY;
close $OPPARIT;
close $POIKASET;
close LOG;