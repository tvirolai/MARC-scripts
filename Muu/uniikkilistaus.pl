#!/bin/perl -w

use strict;

my @uniikit;
my $tiedosto = $ARGV[0];

open FILE, "<$tiedosto" || die $!;
for (<FILE>)
{
	my ($i, $j)	= split;
	if ($i == 1)
	{
		push (@uniikit, $j);
	}
}
my $pituus = @uniikit;
foreach (@uniikit)
{
	print "$_\n";
}
close FILE;
