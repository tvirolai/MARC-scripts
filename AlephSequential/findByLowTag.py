#!/usr/bin/env python
# -*- coding: utf-8 -*
# Finds the records containing (only) the given LOW-tags and prints these
# to a file. Also separates supplement and non-supplement records into different files.

import sys
import re


class Record(object):

    def __init__(self, id="0"):
        self.id = id
        self.lowtags = []
        self.content = ""
        self.supplement = 0

    def isSupplement(self):
        return (self.supplement == 1)


class Reader(object):

    def __init__(self, inputFile, lowtagList):
        self.inputFile = inputFile
        self.lowtags = lowtagList
        self.nonSupplements = 0
        self.supplements = 0
        self.LOWtagMatches = 0
        self.totalRecords = 0

    def read(self):
        with open(self.inputFile, "r") as f:
            firstId = self.id(f.readline())
        currentRecord = Record(firstId)
        with open(self.inputFile, "r") as f:
            for line in f:
                if (self.containsData(line)):
                    if (self.id(line) != currentRecord.id):
                        self.processRecord(currentRecord)
                        self.totalRecords += 1
                        currentRecord = Record(self.id(line))
                    if (self.field(line) == "LOW"):
                        currentRecord.lowtags.append(self.returnLowTag(line))
                    if (self.field(line) == "773"):
                        currentRecord.supplement = 1
                    currentRecord.content += line
        self.printStats()

    def processRecord(self, record):
        if (self.listsAreEqual(self.lowtags, record.lowtags)):
            outputFileName = str(self.inputFile) + "." + "_".join(self.lowtags)
            self.writeRecord(record, outputFileName)
            self.LOWtagMatches += 1
        if not (record.isSupplement()):
            outputFileName = str(self.inputFile) + ".WITHOUTSUPPLEMENTS"
            self.writeRecord(record, outputFileName)
            self.nonSupplements += 1
        else:
            outputFileName = str(self.inputFile) + ".SUPPLEMENTS"
            self.writeRecord(record, outputFileName)
            self.supplements += 1

    def id(self, line):
        return line[0:9]

    def field(self, line):
        return line[10:13]

    def content(self, line):
        return line[18:]

    def returnLowTag(self, line):
        return line.split("$$a")[-1].strip()

    def getLowTags(self):
        return "_".join(self.lowtags)

    def containsData(self, line):
        pattern = re.compile("[0-9]")
        return bool(pattern.search(line))

    def listsAreEqual(self, list1, list2):
        return (len(list1) == len(list2) == len(
            set(list1).intersection(list2)))

    def writeRecord(self, record, outputFileName):
        with open(outputFileName, "a") as outputFile:
            outputFile.write(record.content)

    def printStats(self):
        print("Total number of records: {0}.".format(self.totalRecords))
        print(
            "Total number of non-supplement records: {0}.".format(
                self.nonSupplements))
        print(
            "Total number of supplement records: {0}.".format(
                self.supplements))
        print("Total number of records with only the "
            "searched LOW-tags ({0}): {1}.".format(
            ", ".join(self.lowtags), self.LOWtagMatches))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 findByLowTag.py inputfile lowtag lowtag")
        sys.exit()
    else:
        lowtags = [x.upper() for i, x in enumerate(sys.argv) if i > 1]
        inputFile = sys.argv[1]
        reader = Reader(inputFile, lowtags)
        reader.read()
