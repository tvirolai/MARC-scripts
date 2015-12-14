#!/usr/bin/env python

'''
This script takes a list of language codes and produces a pie chart with the codes opened
'''

import sys
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt

inputFile = sys.argv[1]

totalNumberOfRecords = 0

inputData = {}

langCodes = {}

with open('kielikoodit_korjattu.csv', "r") as f:
    for line in f:
        langCodes[line.split(",")[0]] = line.split(",")[1].replace("\"", "")

with open(inputFile, "r") as f:
    for line in f:
        line = line.strip()
        totalNumberOfRecords += 1
        try:
            print(langCodes[line])
        except:
            print(line)