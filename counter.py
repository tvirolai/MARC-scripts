#!/usr/bin/env python
# -*- coding: utf-8 -*

import sys

if len(sys.argv) < 2:
	print("Usage: python counter.py inputfile")
	sys.exit()
else:
	tiedosto = sys.argv[1]

inputfile = open(tiedosto, "r")

recordCount = []
lineCount = 0

for line in inputfile:
	id = line[:9]
	field = line[10:13]
	if (field == "LOW"):
		recordCount.append(id)
	lineCount += 1	
numberOfRecords = len(set(recordCount))

print "The file " + tiedosto + " contains " + str(numberOfRecords) + " unique records in " + str(lineCount) + " lines."
inputfile.close()
