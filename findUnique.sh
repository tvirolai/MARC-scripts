#!/bin/bash
# Uniikkitietueet ovat alihakemistossa ./Kannat/
# Tiedostot ovat muotoa arken-kanta.stripped.

echo

for file in ./Kannat/*-kanta.stripped
	do 
		perl uniqueFinder.pl $file
done

exit 0