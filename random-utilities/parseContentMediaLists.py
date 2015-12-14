#!/usr/bin/env python
# -*- coding: utf-8 -*

'''
A quick script that takes an unformatted list of content and media types from MARC 21 records
created with "sort file | uniq -c | sort -hr > file.txt" and returns a list where misspelled
duplicate entries are combined and each column is separate by a tab.
'''

import operator
from Levenshtein import distance

inputFile = '/home/tuomo/Työpöytä/PIKIn_analyysit/data/KAIKKI/336ja337.txt'


def combineMisSpelled(data):
    removed = []
    for inspectedKey in data:
        for otherKey in data:
            if inspectedKey == otherKey:
                pass
            else:
                diff = distance(inspectedKey, otherKey)
                if diff < 3:
                    print(inspectedKey, otherKey, diff)
    return data

def parseData(data):
    dataDict = {}
    for line in data:
        line = line.replace('\t', ' - ')
        count = int(line.strip().split()[0])
        entry = " ".join(line.strip().split()[1:])
        dataDict[entry] = count
    dataDict = combineMisSpelled(dataDict)

with open(inputFile, 'r') as f:
    data = f.read().strip().split('\n')

parseData(data)