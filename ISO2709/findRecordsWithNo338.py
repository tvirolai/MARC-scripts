#!/usr/bin/env python
# -*- coding: utf-8 -*

from pymarc import MARCReader, MARCWriter
import sys


def read(inputfile):
    outputfile = "OUTPUTFILE.mrc"
    has338Count = 0
    no338Count = 0
    totalCount = 0
    poikaset = 0
    with open(inputfile, 'rb') as f:
        reader = MARCReader(f)
        writer = MARCWriter(open(outputfile, 'wb'))
        while True:
            try:
                record = next(reader)
                totalCount += 1
                if not testFor336To338(record):
                    no338Count += 1
                    try:
                        writer.write(record)
                    except Exception as e:
                        print("Error with writing.")
                else:
                    has338Count += 1
                if (isPoikanen(record)):
                    poikaset += 1
            except StopIteration:
                print("Tiedoston loppu")
                break
        writer.close()
    print(
        "{0} / {1} ({2} %) records have no 338 field.".format(no338Count,
                    totalCount, countPercentage(no338Count, totalCount)))
    print("Tiedostossa oli {0} osakohdetietuetta (poikasta)".format(poikaset))


def testFor338(record):
    return False if not '338' in record else True


def testFor336To338(record):
    if ('336' in record) and ('337' in record) and not ('338' in record):
        return False
    else:
        return True


def countPercentage(amount, total):
    return str(round((float(amount) / total * 100), 1))


def isPoikanen(record):
    if ('773' in record):
        return True
    else:
        return False


if __name__ == '__main__':
    if (len(sys.argv) == 2):
        inputfile=sys.argv[1]
    else:
        print(
            'Arguments: 1) inputfile')
        sys.exit()
    read(inputfile)
