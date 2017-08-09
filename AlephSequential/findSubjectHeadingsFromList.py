import argparse

'''
Reads a list of subject headings, then reads the Melinda-dump and
prints all keywords found in the input to file.
'''

def isYsaKeyword(line):
    return (line[10:13] in ["650", "651"]) and ("2ysa" in line.lower())

def extractKeywords(line):
    return [x[1:].strip("\n") for x in line.split("$$")[1:]]

def process(dump, tochange, fenniout, othersout):
    headings = []

    with open(tochange, "rt") as f:
        headings = [x.strip() for x in f.readlines()]

    print("Read {0} subject headings, searching for them in dump...".format(len(headings)))

    foundCount = 0

    with open(dump, "rt") as i, open(fenniout, "wt") as fout, open(othersout, "wt") as out:
        for line in i:
            if isYsaKeyword(line):
                if list(set(headings).intersection(extractKeywords(line))):
                    print(line, end="")
                    fout.write(line) if "FENNI<KEEP>" in line else out.write(line)
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
    arguments = parser.parse_args()
    process(arguments.dumppi, arguments.list,
            "muutettavat_asiasanat_FENNI.txt",
            "muutettavat_asiasanat_MUUT.txt")
