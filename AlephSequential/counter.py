#!/usr/bin/env python
# -*- coding: utf-8 -*
# Reports the number of distinct Aleph Sequential -records in a file

import sys
import time
import logging

def count():
    start_time = time.time()

    if len(sys.argv) < 2:
    	print("Usage: python counter.py inputfile")
    	sys.exit()
    else:
    	tiedosto = sys.argv[1]

    inputfile = open(tiedosto, "r")

    recordCount = []
    lineCount = 0
    recordCounter = 0
    firstline = inputfile.readline()
    currentid = firstline[:8]
    inputfile.seek(0)

    for line in inputfile:
        id = line[:9]
        field = line[10:13]
        lineCount += 1
        if (id != currentid):
            currentid = id
            recordCount.append(id)
            recordCounter += 1
    numberOfRecords = len(set(recordCount))
    executionTime = (time.time() - start_time)

    print "The file " + tiedosto + " contains " + str(numberOfRecords) + " unique records (" + str(recordCounter) + " records in total) in " + str(lineCount) + " lines."
    print "Processing took %.1f seconds." %  executionTime
    inputfile.close()
    logging.basicConfig(filename='counter.log',level=logging.DEBUG)
    logging.info(' Inputfile: ' + tiedosto)
    logging.info(' Number of unique records in file: ' + str(numberOfRecords))
    logging.info(' Total number of records: ' + str(recordCounter))

if __name__ == '__main__':
    count()