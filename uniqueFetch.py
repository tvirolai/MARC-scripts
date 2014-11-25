#!/usr/bin/env python
# -*- coding: utf-8 -*
# Count and print to file Aleph Sequential -records with 1) only one LOW-tag (unique), 2) all the others (not unique)

import sys
import time
import logging

def countUnique():
	start_time = time.time()
	if len(sys.argv) < 2:
		print("Usage: python uniqueFetch.py inputfile")
		sys.exit()
	else:
		tiedosto = sys.argv[1]

	inputfile = open(tiedosto, "r")
	uniquefile = open(tiedosto + '.uniq', "w")
	notUniquefile = open(tiedosto + '.notUniq', "w")

	currentRecordContent = []
	currentRecordLOWCount = 0
	totalCount = 0
	firstline = inputfile.readline()
	currentRecordID = firstline[:8]
	inputfile.seek(0)
	uniqueCount = 0
	notUniqueCount = 0
	totalRecordCount = 0

	for line in inputfile:
		id = line[:9]
		field = line[10:13]
		currentRecordContent.append(line)
		if field == 'LOW':
			currentRecordLOWCount += 1
		elif id != currentRecordID:
			if currentRecordLOWCount > 1:
				notUniqueCount += 1
				for line in currentRecordContent:
					notUniquefile.write(line)
			elif currentRecordLOWCount == 1:
				uniqueCount += 1
				for line in currentRecordContent:
					uniquefile.write(line)
			currentRecordID = id
			currentRecordContent = []
			currentRecordLOWCount = 0
			totalRecordCount += 1

	print "Uniikkitietueita: " + str(uniqueCount)
	print "Ei-uniikkeja: " + str(notUniqueCount)
	print "Yhteensä: " + str(totalRecordCount)
	inputfile.close()
	uniquefile.close()
	notUniquefile.close()
	executionTime = (time.time() - start_time)
	print "Processing took %.1f seconds." %  executionTime
	logging.basicConfig(filename='uniqueFetch.log',level=logging.DEBUG)
	logging.info(' Inputfile: ' + tiedosto)
	logging.info(' Number of unique records in file: ' + str(uniqueCount))
	logging.info(' Total number of records: ' + str(totalRecordCount))

if __name__ == '__main__':
    countUnique()