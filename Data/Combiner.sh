#!/bin/bash

echo

for file in ./Kannat/*-kanta.stripped.uniq
	do 
		cat $file >> ./Kannat/KAIKKI.stripped.uniq
done

exit 0