#!/usr/bin/env python
# -*- coding: utf-8 -*

from pymarc import MARCReader, MARCWriter
import sys
import datetime


def read(inputfile):
    outputfile = inputfile + "_no338_" + \
        datetime.datetime.now().isoformat() + ".mrc"
    has338Count = 0
    no338Count = 0
    totalCount = 0
    supplements = 0
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
                if (isSupplement(record)):
                    supplements += 1
            except UnicodeDecodeError:
                print("There was a Unicode error.")
            except StopIteration:
                print("End of file.")
                break
        writer.close()
    print(
        "{0} / {1} ({2} %) records have no 338 field.".format(no338Count,
                                                              totalCount, countPercentage(no338Count, totalCount)))
    print("The file contained {0} supplement records.".format(supplements))


def testFor338(record):
    return False if not '338' in record else True


def testFor336To338(record):
    return (('336' in record) and ('337' in record) and not ('338' in record))


def countPercentage(amount, total):
    return str(round((float(amount) / total * 100), 1))


def isSupplement(record):
    return ('773' in record)


if __name__ == '__main__':
    if (len(sys.argv) == 2):
        inputfile = sys.argv[1]
    else:
        print(
            'Arguments: 1) inputfile')
        sys.exit()
    read(inputfile)
