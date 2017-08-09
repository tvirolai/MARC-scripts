import argparse

'''
Reads a list of subject headings, then reads the Melinda-dump and
prints all keywords found in the input to file.
'''

def isYsaKeyword(line):
    return (line[10:13] == "650") and ("2ysa" in line)

def extractKeywords(line):
    return [x[1:].strip("\n") for x in line.split("$$")[1:]]

def process(dump, tochange, results):
    headings = []

    with open(tochange, "rt") as f:
        headings = [x.strip("\n") for x in f.readlines()]
        print("Read {0} subject headings, searching for them in dump...".format(len(headings)))

    foundCount = 0

    print(results)
    with open(dump, "rt") as i, open(results, "wt") as o:
        for line in i:
            if isYsaKeyword(line):
                if list(set(headings).intersection(extractKeywords(line))):
                    o.write(line)
                    print(line, end="")
                    foundCount += 1
    print("Found {0} obsolete headings in file.".format(foundCount))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', action='store',
            dest='list',
            help='Lista etsittävistä asiasanoista')
    parser.add_argument('-d', action='store',
            default='./dumppi.seq',
            dest='dumppi',
            help='Melinda-dumppitiedosto')
    parser.add_argument('-o', action='store',
            default='./obsolete_subject_headings.txt',
            dest='output',
            help='Tiedosto, johon löydetyt rivit tulostetaan')
    arguments = parser.parse_args()
    process(arguments.dumppi, arguments.list, arguments.output)
