#!/bin/env python
# -*- coding: utf-8 -*

import re
import operator
import numpy as np
import matplotlib.pyplot as plt
from user import User

readData = []

with open("ihmiset.csv", "r") as f:
    data = f.read().split("\n")
    for x in data:
        line = x.split("\t")
        line = [int(x) if x.isdigit() else x for x in line]
        if (len(line) > 1):
            user = User(line[0], line[1], line[2], line[3], line[4])
            readData.append(user)

def isAdmin(user):
    try:
        numbers = re.findall("\d+", user.name)
        numbers = numbers[0]
    except:
        numbers = 0
    return int(numbers) < 2000

def isNormalUser(user):
    try:
        numbers = re.findall("\d+", user.name)
        numbers = numbers[0]
    except:
        numbers = 0
    return 2000 < int(numbers) < 5000

def isCopyCataloger(user):
    try:
        numbers = re.findall("\d+", user.name)
        numbers = numbers[0]
    except:
        numbers = 0
    return int(numbers) >= 7000

def getOrganization(user):
    code = re.findall("[A-Za-z]+", user.name)
    return code[0]

def copyAverage():
    summa = sum([x.copies for x in readData])
    return summa / float(len(readData))

def primaryAverage():
    summa = sum([x.primaryCreates for x in readData])
    return summa / float(len(readData))

def copyCreateAverage():
    summa = sum([x.copyCreates for x in readData])
    return summa / float(len(readData))

def updateAverage():
    summa = sum([x.updates for x in readData])
    return summa / float(len(readData))

def userNames():
    stats = {"admins": 0, "normal": 0, "copycatalogers": 0, "total": 0}
    for u in readData:
        stats["total"] += 1
        if isAdmin(u):
            stats["admins"] += 1
        elif isNormalUser(u):
            stats["normal"] += 1
        elif isCopyCataloger(u):
            stats["copycatalogers"] += 1
    print("Username stats:\nAdmins: {0}\nNormal: {1}\nCopy catalogers: {2}\nTotal: {3}".format(
        stats["admins"], stats["normal"], stats["copycatalogers"], stats["total"]))

def createADict(data):
    '''
    Create a dict in the form
    {"1": 432,
    "2": 4231}
    '''
    newDict = {}
    for i in data:
        if str(i[1]) not in newDict:
            newDict[str(i[1])] = 1
        else:
            newDict[str(i[1])] += 1
    return newDict


def mungeData(data):
    '''
    Process the data in the following format and return two lists.
    [1-499, 500-999, 1000-1499 ...]
    [1234, 4214, 5223 ...]
    '''
    ranges = ["1-499", "500-999", "1000-1499", "1500-1999", "2000-2499", "2500-2999", "3000-3499", "3500-3999", "4000-4499", "4500-4999", "> 5000"]
    values = list(np.zeros(len(ranges), dtype=np.int))
    for item in data:
        if 0 < int(item) < 500:
            values[0] += data[item]
        elif 500 <= int(item) < 1000:
            values[1] += data[item]
        elif 1000 <= int(item) < 1500:
            values[2] += data[item]
        elif 1500 <= int(item) < 2000:
            values[3] += data[item]
        elif 2000 <= int(item) < 2500:
            values[4] += data[item]
        elif 2500 <= int(item) < 3000:
            values[5] += data[item]
        elif 3000 <= int(item) < 3500:
            values[6] += data[item]
        elif 3500 <= int(item) < 4000:
            values[7] += data[item]
        elif 4000 <= int(item) < 4500:
            values[8] += data[item]
        elif 4500 <= int(item) < 5000:
            values[9] += data[item]
        elif int(item) >= 5000:
            values[10] += data[item]
    return ranges, values

def plotAsBarChart(ranges, values):
    # Plot the values into a bar chart
    y_pos = np.arange(len(ranges))
    #plt.axvline(1259, color='b', linestyle='dashed', linewidth=2)
    plt.bar(y_pos, values, align='center', alpha=0.5)
    plt.xticks(y_pos, ranges)
    plt.ylabel(u'Aleph-tunnusten määrä')
    plt.xlabel(u'Tallennuksia vuoden aikana')
    plt.title(u'Aleph-tunnusten tekemät tallennukset Melindassa 2015')
    plt.show()

def returnPercentagesForPie():
    percentages = [0.0, 0.0, 0.0, 0.0]
    labels = ["Poiminta Melindasta (LOW-tagin merkitseminen)", "Primaariluettelointi", "Poiminta muualta Melindaan", u"Päivitys"]
    totalSaves = 0
    totalCopies = 0
    totalPrimaryCreates = 0
    totalUpdates = 0
    totalCopyCreates = 0
    for u in readData:
        totalSaves += u.getTotalSaves()
        totalCopies += u.copies
        totalPrimaryCreates += u.primaryCreates
        totalUpdates += u.updates
        totalCopyCreates += u.copyCreates
    percentages[0] = totalCopies / float(totalSaves) * 100
    percentages[1] = totalPrimaryCreates / float(totalSaves) * 100
    percentages[2] = totalCopyCreates / float(totalSaves) * 100
    percentages[3] = totalUpdates / float(totalSaves) * 100
    percentages = [round(x, 1) for x in percentages]
    return labels, percentages

def plotData(labels, sizes):
    #cmap = plt.cm.prism
    #colors = cmap(np.linspace(0., 1., len(labels)))
    colors = ['gold', 'yellowgreen', 'lightcoral', 'lightskyblue', 'red']
    explode = (0.02, 0.1, 0.02, 0.02)
    plt.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%', explode=explode, shadow=True, startangle=49, labeldistance=1.05)
    plt.axis('equal')
    plt.title(u'Tallennustapahtumat Melindassa 2015', bbox={'facecolor':'0.9', 'pad':5})
    plt.show()


userNames()

returnPercentagesForPie()

totals = {}
for u in readData:
   totals[u.name] = u.getTotalSaves()

sortedTotals = sorted(totals.items(), key=operator.itemgetter(1), reverse=False)

under100 = 0

for x in sortedTotals:
    if x[1] < 100:
        under100 += 1
    else:
        break
print(under100)

#ranges, values = mungeData(createADict(sortedTotals))

#labels, sizes = returnPercentagesForPie()
#plotData(labels, sizes)
#plotAsBarChart(ranges, values)