#!/bin/env python

import numpy as np
import matplotlib.pyplot as plt
from user import User

'''
Plot a bar chart of the total number of saves by username.
'''

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

def averageNumberOfSaves():
    return sum([x.getTotalSaves() for x in readData]) / float(len(readData))

def averageNumberOfCopies():
    return sum([x.copies for x in readData]) / float(len(readData))

def averageNumberOfPrimaryCreates():
    return sum([x.primaryCreates for x in readData]) / float(len(readData))

def averageNumberOfCopyCreates():
    return sum([x.copyCreates for x in readData]) / float(len(readData))

def averageNumberOfUpdates():
    return sum([x.updates for x in readData]) / float(len(readData))

def userNames():
    readData = []
    with open("ihmiset.csv", "r") as f:
        data = f.read().split("\n")
    for x in data:
        line = x.split("\t")
        line = [int(x) if x.isdigit() else x for x in line]
        if (len(line) > 1): 
            user = User(line[0], line[1], line[2], line[3], line[4])
            readData.append(user)
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

userNames()
