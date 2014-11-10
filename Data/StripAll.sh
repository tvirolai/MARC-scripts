#!/bin/bash

echo

for file in ./Kannat/*-kanta
	do 
		perl Stripper.pl $file
done
exit 0