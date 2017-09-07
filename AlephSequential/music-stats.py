import argparse

def getTag(line):
    return line[10:13]

def getContent(line):
    return line[18:]

def isEmaterial(record):
    """
    A record is classified as e-material if 008/23 = 'o' and 007/1 = 'r'

    """
    fields = [x for x in record if getTag(x) in ["007", "008"]]
    f007 = list(filter(lambda x: getTag(x) == "007" and getContent(x)[1:2] ==
        'r', fields))
    f008 = list(filter(lambda x: getTag(x) == "008" and getContent(x)[23:24] ==
        'o', fields))
    if len(f007) > 0 and len(f008) > 0:
        return True
    return False

def isSubrecord(record):
    return len([x for x in record if getTag(x) == "773"]) > 0

def getLeaderCodes(record):
    """
    Get LDR 06-07
    """
    return [x for x in record if getTag(x) == "LDR"].pop()[18:][6:8]

def isSheetMusic(record):
    return getLeaderCodes(record) in ["ca", "cm"]

def isRecording(record):
    return getLeaderCodes(record) in ["jm", "ja"]

def isRecordBoundary(line):
    return "FMT   L" in line

def process(inputfile, outputfile):
    with open(inputfile, 'rt') as f: #open(outputfile, 'wt') as o:
        record = []
        read = 0
        stats = {"nuottiemot": 0,
                "nuottipoikaset": 0,
                "äänite-emot": 0,
                "äänitepoikaset": 0}
        for line in f:
            if isRecordBoundary(line):
                if record and isSheetMusic(record):
                    if isSubrecord(record):
                        stats["nuottipoikaset"] += 1
                    else:
                        stats["nuottiemot"] += 1
                if record and isRecording(record):
                    if isSubrecord(record):
                        stats["äänitepoikaset"] += 1
                    else:
                        stats["äänite-emot"] += 1
                read += 1
                if read % 500000 == 0:
                    print("Read {0} records, stats so far: {1}..".format(read,
                        stats))
                record = []
            record.append(line)
        print(stats)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', action='store',
            dest='input',
            help='Inputfile')
    parser.add_argument('-o', action='store',
            dest='output',
            help='Outputfile')
    arguments = parser.parse_args()
    process(arguments.input, arguments.output)
