#!/bin/perl -w

# Extract interesting information from records and write to CSV-file (?)

use strict;
use utf8;
use List::MoreUtils qw(uniq);

binmode(STDOUT, ':utf8');

my $beg_time = time;
my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl Extractor.pl inputfile\n";
}

my $outputfile = $tiedosto . ".extracted";

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
open (my $KIELET, '>:utf8', '041.txt');
open (my $SISALTOTYYPPI, '>:utf8', '336.txt');
open (my $MEDIATYYPPI, '>:utf8', '337.txt');
open (my $YKL, '>:utf8', '084_ykl.txt');
open (my $KEYWORDS, '>:utf8', '650_651_CSV.txt');
open (my $KEYWORDS2, '>:utf8', '650_651_vain_sanat.txt');
open (my $THESAURI,'>:utf8', '650_651_2.txt');


# Extract language codes, content / carrier types (336-/337), YKL-classification codes and keywords into arrays

my @languages;
my @sisaltotyyppi;
my @mediatyyppi;
my @YKL;
my @keywords;
my @thesauri;

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $fieldCode = substr($_,10, 3); # Field code
	my $fieldContent = substr($_,18); # Field code
	if ($fieldCode eq '041')
	{
		my @langCodes = split('\$\$', $fieldContent);
		for (@langCodes) # Format codes as follows: a,fin (subfield code,language code)
		{
			chomp;
			# Skip empty fields
			length($_) > 2 ? $_ = (substr($_, 0, 1) . "," . substr($_, 1, 3)) : next;
			push (@languages, $_);
		}
	}

	elsif ($fieldCode eq '084' && $fieldContent =~ /2ykl/i)
	{
		chomp;
		if ($fieldContent =~ /(\d+).(\d+)/)
		{
			push(@YKL, $&);
		}

	}

	elsif ($fieldCode eq ('650' || '651'))
	{
		my @kwContent = split('\$\$', $fieldContent);
		for (@kwContent) # Format codes as follows: a,fin (subfield code,language code)
		{
			chomp;
			# Push $2-subfields into @thesauri
			if (substr($_, 0, 1) =~ /2/) { push (@thesauri, substr($_, 1)); next; }
			if (substr($_, 0, 1) =~ /9/) { next; } # Throw away fields like $9FENNI<KEEP>
			length($_) > 2 ? push (@keywords, ($_ = (substr($_, 0, 1) . "," . substr($_, 1)))) : next;
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
				push (@sisaltotyyppi, $_);
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
				push (@mediatyyppi, $_);
			}
		}
	}

}

@languages = sort @languages;
@YKL = sort @YKL;
@keywords = sort @keywords;
@thesauri = sort @thesauri;
@sisaltotyyppi = sort @sisaltotyyppi;
@mediatyyppi = sort @mediatyyppi;

my $uniqueKeywords = uniq @keywords;
my $thesauri = uniq @thesauri;
my $sisaltotyyppi = uniq @sisaltotyyppi;
my $mediatyyppi = uniq @mediatyyppi;

print "$uniqueKeywords keywords found from $thesauri thesauri.
$sisaltotyyppi content types
$mediatyyppi media types\n";

for (@languages)
{
	print $KIELET $_ . "\n";
}

for (@YKL)
{
	print $YKL $_ . "\n";
}

for (@sisaltotyyppi)
{
	print $SISALTOTYYPPI $_ . "\n";
}

for (@mediatyyppi)
{
	print $MEDIATYYPPI $_ . "\n";
}

for (@keywords)
{
	print $KEYWORDS $_ . "\n";
	print $KEYWORDS2 substr($_, 2) . "\n";
}

for (@thesauri)
{
	print $THESAURI $_ . "\n";
}

close $inputfile;
close $KIELET;
close $SISALTOTYYPPI;
close $MEDIATYYPPI;
close $YKL;
close $KEYWORDS;
close $KEYWORDS2;
close $THESAURI;