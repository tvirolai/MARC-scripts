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
#open (OUTPUT, '>:utf8', $outputfile);

# Extract language codes, content / carrier types (336-/337), YKL-classification codes and keywords into arrays

my @languages;
#my @336;
#my @337;
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
			if (substr($_, 0, 1) =~ /9/) { next; }
			length($_) > 2 ? push (@keywords, ($_ = (substr($_, 0, 1) . "," . substr($_, 1)))) : next;
			#print $_ . "\n";
		}
	}

}

@languages = sort @languages;
@YKL = sort @YKL;
@keywords = sort @keywords;
@thesauri = sort @thesauri;

my $uniqueKeywords = uniq @keywords;
my $thesauri = uniq @thesauri;

print "$uniqueKeywords keywords found from $thesauri thesauri.\n";

close $inputfile;
#close OUTPUT;