#!/bin/bash
# Yhdistä karsimattomat kannat jättiläistietueeksi

echo

for file in ./Kannat/*-kanta
	do 
		cat $file >> ./Kannat/KAIKKI.karsimaton
done

exit 0
