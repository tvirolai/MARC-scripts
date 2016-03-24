#!/usr/bin/env python
# -*- coding: utf-8 -*

from pymarc import MARCReader
import sys
import datetime

def read(inputfile):
    outputfile = "../raportit/" + inputfile[:-4] + "_no338.txt"
    outputForRecs = "../virhetietueet/" + inputfile[:-4] + "_recsWithNo338.txt"
    has338Count = 0
    no338Count = 0
    totalCount = 0
    supplements = 0
    with open(inputfile, "rb") as f:
        reader = MARCReader(f)
        writer = open(outputfile, "wt")
        recWriter = open(outputForRecs, "wt")
        while True:
            try:
                record = next(reader)
                totalCount += 1
                if not has338(record) and not isSupplement(record):
                    no338Count += 1
                    ids = record.get_fields("001")
                    try:
                        for recId in ids:
                            print(recId.value())
                            writer.write(recId.value() + "\n")
                            recWriter.write(str(record) + "\n")
                    except Exception as e:
                        print("Error with writing: " + e)
                else:
                    has338Count += 1
                if isSupplement(record):
                    supplements += 1
            except UnicodeDecodeError:
                print("There was a Unicode error.")
            except StopIteration:
                print("End of file.")
                recWriter.close()
                writer.close()
                break
    print(
        "{0} / {1} ({2} %) records have no 338 field.".format(no338Count,
                                                              totalCount, countPercentage(no338Count, totalCount)))
    print("The file contained {0} supplement records.".format(supplements))


def has338(record):
    return False if not '338' in record else True


def countPercentage(amount, total):
    return str(round((float(amount) / total * 100), 1))

def isSupplement(record):
    return '773' in record


if __name__ == '__main__':
    if (len(sys.argv) == 2):
        inputfile = sys.argv[1]
    else:
        print(
            'Arguments: 1) inputfile')
        sys.exit()
    read(inputfile)
