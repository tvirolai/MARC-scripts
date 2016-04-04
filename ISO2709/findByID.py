#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pymarc import MARCReader
import sys

def iterateFiles(bibId, inputfile):
    totalRecs = 0
    problemCount = 0
    with open(inputfile, "rb") as f:
        reader = MARCReader(f)
        while True:
            try:
                record = next(reader)
                totalRecs += 1
                if isAMatch(bibId, record):
                    print(str(record))
                    break
            except StopIteration:
                print("End of file.")
                break
            except UnicodeDecodeError:
                pass

def isAMatch(bibId, record):
    recId = [x.value() for x in record.get_fields("001")]
    recId = recId.pop()
    if bibId == recId:
        return True
    else:
        return False

if __name__ == "__main__":
    if len(sys.argv) == 3:
        bibId = sys.argv[1]
        inputfile = sys.argv[2]
        iterateFiles(bibId, inputfile)
    else:
        print("Usage: python3 findById.py bibId inputfile")
        sys.exit()
