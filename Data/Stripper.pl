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
my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl Stripper.pl inputfile\n";
}

#my $log = 'stripper_log.txt';

my $outputfile = $tiedosto . ".stripped";

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

#print "Processing file \'$tiedosto\', writing into \'$outputfile\'...\n";

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $fieldcode = substr($_,10, 3); # Field code
	chomp(my $content = substr($_, 18));
	if ($content =~ /ebrary-palvelun kautta/)
	{
		push (@ebrary, $id)
	}
	elsif ($fieldcode eq '509' && $content =~ /AMK-opinn/) # Opinnäytteet
	{
		push (@AMK, $id);
	}
	elsif ($fieldcode eq '773') # Poikastietueet
	{
		push (@poikaset, $id);
	}
	else
	{
		push (@others, $id);
	}
}

@ebrary = sort @ebrary;
@AMK = sort @AMK;
@poikaset = sort @poikaset;
@others = sort @others;

my $ebrary = uniq (@ebrary);
my $AMK = uniq (@AMK);
my $poikaset = uniq (@poikaset);
my $others = uniq (@others);
my $total = ($ebrary + $AMK + $poikaset + $others);

print "\nTiedostossa \'$tiedosto\' on yhteensä $total tietuetta, joista\n
$ebrary Ebrary-tietuetta
$poikaset poikastietuetta
$AMK AMK-opinnäytettä
$others muuta tietuetta\n\n";

my $end_time = time;
my $time = ($end_time - $beg_time);
my $minutes = sprintf("%.1f", ($time / 60));
$time = sprintf("%.1f", $time);

if ($minutes > 1)
{
	print "Käsíttelyyn kului $time sekuntia ($minutes minuuttia).\n";
}
else
{
	print "Käsittelyyn kului $time sekuntia.\n";
}

# 1. Ebrary-tapaukset
# 006268388 500   L $$aKäytettävissä ebrary-palvelun kautta.
# 006268388 7100  L $$aebrary, Inc.
# 006268388 85640 L $$uhttps://login.ezproxy.turkuamk.fi/login?url=http://site.ebrary.com/lib/turkuamk/Doc?id=10018408$$5$$5AURA

# 2. AMK-opinnäytteet
# 006209790 509   L $$aAMK-opinnäytetyö :$$cVaasan ammattikorkeakoulu, Liiketalouden koulutusohjelma.
# 005841970 509   L $$aYlempi AMK-opinnäytetyö :$$cSavonia ammattikorkeakoulu, Matkailu- ja ravitsemisala, Palveluliiketoiminnan koulutusohjelma.

# 3. Osakohteiden poikastietueet
# 7730	|7 nnjm |w (FIN01)006714667 |t Joulun toivekonsertti / toimitus Virpi Kari. - |d Helsinki : F-Kustannus, ℗ 2013 - |m 1 sävelmäkokoelma, 1 CD-äänilevy. - |o VL-Musiikki VLCD-1367. - |g Raita 8