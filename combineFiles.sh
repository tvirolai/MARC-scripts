#!/bin/bash
# Yhdistä karsimattomat kannat jättiläistietueeksi

echo

for file in ./LOW/*_dumppi
	do 
		cat $file >> ./LOW/KAIKKI.karsimaton
done

exit 0
