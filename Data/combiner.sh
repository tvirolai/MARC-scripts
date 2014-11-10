#!/bin/bash
# Yhdistä kaikki *-kanta.stripped.uniq -tiedostot yhteen tiedostoon

echo

for file in ./Kannat/*-kanta.stripped.uniq
	do 
		cat $file >> ./Kannat/KAIKKI.stripped.uniq
done

exit 0