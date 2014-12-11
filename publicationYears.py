#!/usr/bin/env python
# -*- coding: utf-8 -*

import sys

totalCount = 0

def yearcount():
	if len(sys.argv) < 2:
		print("Usage: python publicationYears.py inputfile")
		sys.exit()
	else:
		tiedosto = sys.argv[1]
	inputFile = open(tiedosto, "r")
	global totalCount
	counts = {'1800' : 0, '1900' : 0, '1910' : 0, 
	'1920' : 0, '1930' : 0, '1940' : 0, '1950' : 0, '1960' : 0, 
	'1970' : 0, '1980' : 0, '1990' : 0, '2000' : 0, '2010' : 0, 'others' : 0}

	for line in inputFile:
		totalCount += 1
		try:
			line = int(line[:-1])
		except:
			counts['others'] += 1
			continue
		if line in range(1800, 1900):
			counts['1800'] += 1
		elif line in range(1900, 1910):
			counts['1900'] += 1
		elif line in range(1910, 1920):
			counts['1910'] += 1
		elif line in range(1920, 1930):
			counts['1920'] += 1
		elif line in range(1930, 1940):
			counts['1930'] += 1
		elif line in range(1940, 1950):
			counts['1940'] += 1
		elif line in range(1950, 1960):
			counts['1950'] += 1
		elif line in range(1960, 1970):
			counts['1960'] += 1
		elif line in range(1970, 1980):
			counts['1970'] += 1
		elif line in range(1980, 1990):
			counts['1980'] += 1
		elif line in range(1990, 2000):
			counts['1990'] += 1
		elif line in range(2000, 2010):
			counts['2000'] += 1
		elif line in range(2010, 2015):
			counts['2010'] += 1

	print "1800-luvulla: " + str(counts['1800']) + " (" + str(percentage(counts['1800'])) + " %)" 
	print "1900-1909: " + str(counts['1900']) + " (" + str(percentage(counts['1900'])) + " %)" 
	print "1910-1919: " + str(counts['1910']) + " (" + str(percentage(counts['1910'])) + " %)" 
	print "1920-1929: " + str(counts['1920']) + " (" + str(percentage(counts['1920'])) + " %)" 
	print "1930-1939: " + str(counts['1930']) + " (" + str(percentage(counts['1930'])) + " %)" 
	print "1940-1949: " + str(counts['1940']) + " (" + str(percentage(counts['1940'])) + " %)" 
	print "1950-1959: " + str(counts['1950']) + " (" + str(percentage(counts['1950'])) + " %)" 
	print "1960-1969: " + str(counts['1960']) + " (" + str(percentage(counts['1960'])) + " %)" 
	print "1970-1979: " + str(counts['1970']) + " (" + str(percentage(counts['1970'])) + " %)" 
	print "1980-1989: " + str(counts['1980']) + " (" + str(percentage(counts['1980'])) + " %)" 
	print "1990-1999: " + str(counts['1990']) + " (" + str(percentage(counts['1990'])) + " %)" 
	print "2000-2010: " + str(counts['2000']) + " (" + str(percentage(counts['2000'])) + " %)" 
	print "2010-: " + str(counts['2010']) + " (" + str(percentage(counts['2010'])) + " %)" 
	print "Muut (virheellinen / puutteellinen julkaisuvuosi): " + str(counts['others']) + " (" + str(percentage(counts['others'])) + " %)" 

def percentage(value):
	global totalCount
	percentage = float(value) / float(totalCount) * 100
	percentage = round(percentage, 1)
	return percentage

if __name__ == '__main__':
    yearcount()