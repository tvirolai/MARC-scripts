#!/bin/env python

from pymarc import MARCReader
import sys

def read(inputfile):
    with open(inputfile, "rb") as f:
        reader = MARCReader(f)
        while True:
            record = next(reader)
            print(record)

if __name__ == '__main__':
    if (len(sys.argv) == 2):
        inputfile = sys.argv[1]
    else:
        print(
            'Arguments: 1) inputfile')
        sys.exit()
    read(inputfile)
