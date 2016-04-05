#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
This script takes two MARC ISO 2709 batch files (like same database dump in pre- and post-conversion state) as arguments
and prints a TSV report file about their dissimilarities concerning subfields 100$e and 700$e.
'''

from pymarc import MARCReader
import sys
import unicodedata

def iterateFiles(preFile, postFile):
    totalRecs = 0
    preFileHandle = open(preFile, "rb")
    postFileHandle = open(postFile, "rb")
    preFileReader = MARCReader(preFileHandle)
    postFileReader = MARCReader(postFileHandle)
    output = open("changeReport.tsv", "wt")
    try:
        while True:
            preRec = next(preFileReader)
            postRec = next(postFileReader)
            totalRecs += 1
            bibID = preRec.get_fields("001")
            bibID = bibID.pop().value()
            pre100 = preRec.get_fields("100")
            post100 = postRec.get_fields("100")
            for i, x in enumerate(range(0,len(pre100))):
                try:
                    pre100e = pre100[i].get_subfields("e")
                    post100e = post100[i].get_subfields("e")
                except:
                    pass
                if len(post100e) > 0:
                    if not isinstance(pre100, str):
                        pre100 = pre100.pop().value()
                        post100 = post100.pop().value()
                    pre100e = "".join(pre100e)
                    post100e = "".join(post100e)
                    if fieldsDiffer(pre100e, post100e):
                        printChange(output, bibID, pre100, post100, "100")
            pre700 = preRec.get_fields("700")
            post700 = postRec.get_fields("700")
            for i, x in enumerate(range(0,len(pre700))):
                try:
                    pre700e = pre700[i].get_subfields("e")
                    post700e = post700[i].get_subfields("e")
                except:
                    pass
                if len(post700e) > 0:
                    if not isinstance(pre700, str):
                        pre700 = pre700.pop().value()
                        post700 = post700.pop().value()
                    pre700e = "".join(pre700e)
                    post700e = "".join(post700e)
                    if fieldsDiffer(pre700e, post700e):
                        printChange(output, bibID, pre700, post700, "700")
    except StopIteration:
        print("End of file.")
    except UnicodeDecodeError:
        pass
    output.close()
    preFileHandle.close()
    postFileHandle.close()

def fieldsDiffer(pre, post):
    preNormalized = unicodedata.normalize("NFC", pre)
    postNormalized = unicodedata.normalize("NFC", post)
    return preNormalized.strip('\t\n\r .,:;') != postNormalized.strip('\t\n\r .,:;')
     
def printChange(output, bibID, pre, post, fieldCode):
    parsedOutput = "" + bibID + "\t"+ fieldCode + "\t" + pre + "\t" + post + "\n"
    output.write(parsedOutput)


if __name__ == "__main__":
    if len(sys.argv) == 3:
        preFile = sys.argv[1]
        postFile = sys.argv[2]
        iterateFiles(preFile, postFile)
    else:
        print("Usage: python3 changeReport.py pre-conversionfile post-conversionfile")
        sys.exit()
