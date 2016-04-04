#!/usr/bin/env python
# -*- coding: utf-8 -*

from pymarc import MARCReader
import sys


def read(inputfile):
    totalCount = 0
    supplementCount = 0
    with open(inputfile, 'rb') as f:
        reader = MARCReader(f)
        while True:
            try:
                record = next(reader)
                totalCount += 1
                if isSupplement(record):
                    supplementCount += 1
            except UnicodeDecodeError:
                print("Merkistövirhe.")
                next
            except StopIteration:
                print("Tiedoston loppu.")
                break
    print("Lopullinen määrä: {0} tietuetta, joista poikasia {1}.".format(
        totalCount, supplementCount))


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
