MARC-SCRIPTS
=========

Various scripts for processing and analyzing MARC-records from library databases. Some reuseable, others quick-and-dirty one-off stuff. Short descriptions below.

counter.py
-------
Description: reports the number of distinct records in an Aleph Sequential batch.
Usage: python counter.py inputfile

deduplicator.pl
-------
Description: Strips duplicate records from an Aleph Sequential batch. Generates a new file (with a '.deduplicated'-suffix) with the duplicate entries removed.
Usage: perl deduplicator.pl inputfile

extractor.pl
--------
Description: Generates lists of different possibly interesting elements in an Aleph Sequential batch. These include languages codes, media and content types, classifications (in field 084), publication years and subject headings used.
Usage: perl extractor.pl inputfile

findOnlyAMK.pl
-------
Description: Takes an Aleph Sequential batch file as an input and generates a file of the records that are found only in Finnish Polytechnic / AMK -libraries.
Usage: perl findOnlyAMK.pl inputfile

getFromIdList.pl
---------
Description: Takes two arguments, a list of database ID's and an Aleph Sequential batch, prints records from the ID-list to a separate file.
Usage: perl getFromIdList.pl idlistfile batchfile


