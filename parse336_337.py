#!/usr/bin/env python
# -*- coding: utf-8 -*

import sys, re

def parse():
	if len(sys.argv) < 2:
		print("Usage: python parse336_337.py inputfile")
		sys.exit()
	else:
		tiedosto = sys.argv[1]

	inputFile = open(tiedosto, "r")
	outputFile = open(tiedosto + '.parsed', "w")

	for line in inputFile:
		id = line[:3]
		content = re.sub(r'\$\$(.)+', '', line[4:-1])
		if id == '336':
			if content == 'Tal':
				sisaltotyyppi = 'Puhe'
			elif content == ('text' or 'Text'):
				sisaltotyyppi = 'Teksti'
			elif content == 'Text':
				sisaltotyyppi = 'Teksti'
			elif content == 'Bild (rörlig ; tvådimensionell)':
				sisaltotyyppi = 'Kuva (liikkuva ; kaksiulotteinen)'
			else: 
				sisaltotyyppi = content

		elif id == '337':
			if content == ('ingen medietyp' or 'unmediated'):
				content = 'ei välittävää laitetta'
			elif content == 'projektion':
				content = 'heijastettava'
			mediatyyppi = content
			outputFile.write(sisaltotyyppi + " : " + "'" + mediatyyppi + "'" + "\n")

	inputFile.close()
	outputFile.close()


if __name__ == '__main__':
    parse()