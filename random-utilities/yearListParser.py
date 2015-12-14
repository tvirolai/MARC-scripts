#!/usr/bin/env python
# -*- coding: utf-8 -*

import operator

inputFile = '/home/tuomo/Työpöytä/PIKIn_analyysit/data/OSAKOHTEETTOMAT/raportit/julkaisuvuodet_muotoiltu.txt'

yearDict = {"tunnistamaton": 0, "-1800": 0, "2010-": 0}

def roundDownToNearestTenth(inputInt):
    i = inputInt - 9
    while True:
        if i % 10 == 0:
            return i
        i += 1

def parseData(data):
    for line in data:
        count, year = line.split('\t')
        try:
            year = int(year)
            if year >= 2010:
                yearDict["2010-"] += int(count)
            elif year < 1800:
                yearDict["-1800"] += int(count)
            else:
                decade = str(roundDownToNearestTenth(year)) + "-" + str(roundDownToNearestTenth(int(year)) + 9)
                if not decade in yearDict:
                    yearDict[decade] = int(count)
                else:
                    yearDict[decade] += int(count)
        except:
            yearDict["tunnistamaton"] += int(count)
    return yearDict

with open(inputFile, 'r') as f:
    data = f.read().strip().split('\n')

years = parseData(data)

yearList = []

for key in years:
    yearList.append((key, years[key]))

out = open('/home/tuomo/Työpöytä/PIKIn_analyysit/data/OSAKOHTEETTOMAT/raportit/julkaisuvuosikymmenet_muotoiltu.txt', 'w')
for item in sorted(yearList, reverse=True):
    out.write(item[0] + '\t' + str(item[1]) + '\n')

out.close()