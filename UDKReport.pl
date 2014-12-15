#!/bin/perl -w

# List the amounts of UDK-classifications in an Aleph Seq -file with descriptions

use strict;
use utf8;
use Spreadsheet::Read;

binmode(STDOUT, ':utf8');

my $tiedosto = $ARGV[0];

if( ! defined $tiedosto )
{
  die "Usage: perl UDKReport.pl inputfile\n";
}

open (my $inputfile, '<:utf8', $tiedosto);

my $taulukko = ReadData ("UDK.xlsx") || die $!;
my $sheet = "1";
my $codes_firstcell = "A1";
my $codes_lastcell = "A380";
my $descriptions_firstcell = "B1";
my $descriptions_lastcell = "B380";

my %luokitukset;
my %luokitukset_kuvaus;
(my $firstrow = $codes_firstcell) =~ s/\D+//;
(my $lastrow = $codes_lastcell) =~ s/\D+//;
(my $inputcolumn = $codes_firstcell) =~ s/\d+//;
(my $outputcolumn = $descriptions_firstcell) =~ s/\d+//;
my $codecell;
my $codecell_content;
my $descriptioncell;
my $descriptioncell_content;

my @notFound;

# Read classification codes into hash as keys

for (my $row = $firstrow; $row <= $lastrow; $row++) 
{
	$codecell = ($inputcolumn . $row);
	$descriptioncell = ($outputcolumn . $row);
	$codecell_content = $taulukko->[$sheet]{$codecell};
	$descriptioncell_content = $taulukko->[$sheet]{$descriptioncell};
	if (!defined ($codecell_content)) 
	{
		next;
	} 	
	else 
	{ 
		$luokitukset{$codecell_content} = 0;
		$luokitukset_kuvaus{$codecell_content} = $descriptioncell_content;
	}
}

# Read the Aleph Seq-file, scan for 080-fields, strip leading "UDK:" and non $a-subfields, count occurrences as values in %luokitukset
my $totalCount = 0;

while (<$inputfile>)
{
	my $id = substr($_, 0, 9); # Record id
	my $fieldCode = substr($_, 10, 3); # Field code
	my $fieldContent = substr($_, 21); # Field content
	my $class;
	if ($fieldCode eq '080')
	{
		($class = $fieldContent) =~ s/UDK:|UDK\.//;
		if ($class =~ m/\$/) 
		{
			($class = $class) =~ s/\$(.)+//; 
		}
		chomp($class);
		if (defined $luokitukset{$class})
		{
			$luokitukset{$class}++;
			$totalCount++;
		}
		else # Jos luokituskirjaukselle ei löydy suoraa vastinetta Fennican UDK-taulukosta, löytyisikö kirjauksen osajoukolle.
			 # Logiikka: otetaan merkkejä pois lopusta ja verrataan. Lopetetaan kun löytyy osuma tai kun kirjauksessa ei ole enää pisteitä tai kenoviivoja
		{
			my $pituus = length($class);
			if ($class =~ m/(\.|\/)/)
			{
				while (length(substr($class, 0, $pituus)) >= 1)
				{
					
					my $substring = substr($class, 0, $pituus);
					chomp($substring);

					if (defined $luokitukset{$substring})
					{
						$luokitukset{$substring}++;
						$totalCount++;
						last;
					}
					elsif (substr($class, 0, $pituus) =~ m/(\.|\/)/)
					{
						$pituus--;
						next;
					}
					else 
					{
						push @notFound, $class;
						last;
					}
					
				}
			}
			
		}
	}
}

foreach my $maara (sort { $luokitukset{$b} <=> $luokitukset{$a} } keys %luokitukset)
{
	printf "%s\t%s\t%s\n", $luokitukset{$maara}, $maara, $luokitukset_kuvaus{$maara};
}
print "Yhteensä löydettiin " . $totalCount . " kirjausta.\n";

close $inputfile;