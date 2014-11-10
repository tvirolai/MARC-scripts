#!/bin/bash
# Aja ebrary-tietueet, opinnäytteet, osakohteet ja loput tietueet
# erittelevä skripti (Stripper.pl) kaikille kannoille

echo

for file in ./Kannat/*-kanta
	do 
		perl stripper.pl $file
done
exit 0
