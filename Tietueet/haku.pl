#!/bin/perl -w

use strict;

$| = 1;

my @tiedostot = qw (arken-kanta jamk-kanta diak-kanta kamk-kanta xamk-kanta metro-kanta oamk-kanta);

my $beg_time = time;
open (my $luku, "<:utf8", "kaikkien_uniikkien_lowt.txt");
my @tietuenrot;
my $rivi;
my @tietueet;
my $count;
open (my $kirjoitus, ">:utf8", "uniikkitietueet_aleph_seq.txt");
print "Luetaan muistiin tietuenumeroita...\n";
my %tietuenumerot;

for (<$luku>)
{
	$tietuenumerot{$_} = "Terve vaan";
	# push (@tietuenrot, $_);
}
my $numeroita = keys %tietuenumerot;
print "Niitä löytyi $numeroita.\n";

for (sort @tiedostot)
{
	print "Luetaan tietueita muistiin... ($_)\n";
	open (FILE, "<$_");
 	while (<FILE>)	
 	{
		push (@tietueet, $_);
 	}
 	close FILE;
}
 
my $riveja = @tietueet;
print "Muistiin luettiin $riveja riviä dataa.\n";

my $rowcount = 0;

my $prosentti;
while ($rivi = shift @tietueet)
{
	$rowcount++;
	$prosentti = ($rowcount / $riveja * 100);	
	$prosentti = sprintf "%.1f", $prosentti;
	print "Käsitellään riviä $rowcount / $riveja ($prosentti prosenttia).\n";
	for (keys %tietuenumerot)
	{
		if ($rivi =~ $tietuenumerot{$_})
		{
			print $kirjoitus $rivi;
			$count++;
			print "Kirjoitettu $count riviä dataa tiedostoon.\n";
		} else {
			next;
		}
	}

	# unless ($_ =~ )
}

# for (sort @tiedostot)
# {
# 	open (FILE, "<:utf8", $_);
# 	while (<FILE>)
# 	{
# 	my $line = $_;
# 		for (my $numero = shift @tietuenrot)
# 		{
# 			if ($line =~ /$numero/)
# 			{
# 				print "moi";
# 			}
# 		}
# 	}
# 	close FILE;
# }
# 

# while (my $numero = shift @tietuenrot)
# {
# 	chomp($numero);
# 	$rivi = grep $numero, @tietueet;
# 	if (defined $rivi)
# 	{
# 		print $kirjoitus $rivi;
# 		print $rivi;
# 		$count++;
# 	} else { next ; }
# }

my $end_time = time; 
my $totaltime = $end_time - $beg_time;;
my $minuutit = $totaltime / 60;
my $tunnit = $minuutit / 60;
print "Ajo kesti $tunnit tuntia ja $minuutit minuuttia.\n";

close $luku;
close $kirjoitus;
