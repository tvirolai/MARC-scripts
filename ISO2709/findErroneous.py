#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# XAMK

# 1) 245 1. indikaattori on muodostunut väärin (0 pro 1), jos kentässä on ollut 130-kenttä
# 2) Kenttä 256: Luodaan 300-kenttä 256-kentän perusteella niihin tietueisiin, joissa sitä ei valmiiksi ole. 
# 3) Kentät 310, 500, 530, 776: Muutetaan 'Verkkojulkaisu' muotoon 'verkkoaineisto', huomioidaan eri taivutusmuodot.
# 4) Kenttä 530: Termi "verkkoversio" → "verkkoaineisto"
# 5) Kenttä 650: Kongressin kirjaston asiasanoissa (I2 = 0) ylimääräisiä loppupisteitä, poistetaan ylimääräiset loppupisteet.

from pymarc import MARCReader, Record, Field
import sys, re, operator

def iterateFiles(inputfile):
    totalRecs = 0
    problemCount = 0
    problems = [["1) Kenttä 245: 1. indikaattori on muodostunut väärin (0 pro 1)", 0], ["2) Luodaan 300-kenttä 256-kentän perusteella", 0],
            ["3) 310, 500, 530, 776: Muutetaan \'Verkkojulkaisu\' muotoon \'verkkoaineisto\'", 0], ["4) verkkoversio → verkkoaineisto", 0],
            ["5) Kongressin asiasanat", 0]]
    with open(inputfile, "rb") as f, open("xamk_ids.txt", "wt") as id_out, open("xamk_tietueet.txt", "wt") as out:
        reader = MARCReader(f)
        while True:
            try:
                record = next(reader)
                totalRecs += 1
                res = map_funcs(record, [wrongIndicatorIn245, has256ButNo300, containsVerkkojulkaisu, verkkoversio530, hasLCSHfields])
                for i, val in enumerate(res):
                    if val == True:
                        problems[i][1] += 1
                if True in res:
                    #print(getId(record))
                    out.write(str(record) + "\n")
                    id_out.write(getId(record) + "\n")
                    problemCount += 1
            except StopIteration:
                print("End of file. Read {0} records, found {1} problematic ones.".format(totalRecs, problemCount))
                printListOfLists(problems)
                break
            except UnicodeDecodeError:
                pass

def map_funcs(record: Record, func_list: list) -> list:
    return [func(record) for func in func_list]

def printListOfLists(lista: list) -> None:
    for val in lista:
        print("{0}: {1}".format(val[0], val[1]))

def empty020a(record: Record) -> bool:
    sf020a = []
    if "020" in record:
        fields = record.get_fields("020")
        for f in fields:
            if "a" in f:
                sf020a.append(f.get_subfields("a").pop())
    return sf020a == [""]

def field020ContainsAbbreviation(record: Record) -> bool:
    abbrevs = ["sid.", "nid.", "inb.", "hft."]
    if "020" in record:
        return len([x for x in abbrevs if x in str(record.get_fields("020").pop()).lower()]) > 0
    return False

# 1
def wrongIndicatorIn245(record: Record) -> bool:
    return has130Field(record) and getFirstIndicator(record.get_fields("245").pop()) == "0"

# 2
def has256ButNo300(record: Record) -> bool:
    return "256" in record and "300" not in record

# 3
def containsVerkkojulkaisu(record: Record) -> bool:
    return phrasesInFields(record, ["Verkkojulkaisu", "verkkoaineisto"], ["310", "500", "530", "776"])

# 4
def verkkoversio530(record: Record) -> bool:
    return phrasesInFields(record, ["erkkoversio"], ["530"])

# 5
def hasLCSHfields(record: Record) -> bool:
    if "650" in record:
        for f in record.get_fields("650"):
            return getSecondIndicator(f) == "0"
    return False

def faulty015(record: Record) -> bool:
    found = False
    for f in record.get_fields("015"):
        if "a" in f:
            if len(f["a"].split(' ')) > 1:
                found = True
    return found

def textIn020z(record: Record) -> bool:
    sf020z = []
    if "020" in record:
        fields = record.get_fields("020")
        for f in fields:
            if "z" in f:
                sf020z.append(f.get_subfields("z").pop())
    if len(sf020z) > 0:
        alpha = 0
        for f in sf020z:
            alpha += len([x for x in f if x.isalpha()])
        return alpha > 1
    return False

def errorsIn020(record: Record) -> bool:
    return field020ContainsAbbreviation(record) or empty020a(record)


def abbrevsIn300(record: Record) -> bool:
    return phrasesInFields(record, ["nid.", "sid.", "Nid.", "Sid.", "s."], ["300"])

def internetJulkaisuna(record: Record) -> bool:
    return phrasesInFields(record, ["internet-julkaisu", "Internet-julkaisu"], ["530"])


def extra338Nide(record: Record) -> bool:
    return phrasesInFields(record, ["nide"], ["338"]) and phrasesInFields(record, ["erkkoaineisto"], ["300"])

def has130Field(record: Record) -> bool:
    return "130" in record

def getSecondIndicator(field: Field) -> str:
    return str(field)[7]

def getFirstIndicator(field: Field) -> str:
    return str(field)[6]

def periodsMissing(record: Record) -> bool:
    fields = record.get_fields("100", "110", "700", "710")
    for f in fields:
        if "e" in f:
            functions = f.get_subfields("e")
            for func in functions:
                if func[-1].isalpha():
                    return True
    return False

def return337a(record: Record) -> str:
    if not "337" in record:
        return "(none)"
    return record["337"]["a"]

def sortedDict(fields: dict) -> list:
    return sorted(fields.items(), key=operator.itemgetter(1), reverse=True)

def old337(record: Record) -> bool:
    return "välittävää laitetta" in str(record)

def contains024c(record: Record) -> bool:
    if "024" in record:
        return "c" in record.get_fields("024").pop()
    return False

def contains130(record: Record) -> bool:
    return "130" in record

def getId(record: Record) -> str:
    return [x.value() for x in record.get_fields("001")].pop()

def phrasesInFields(record: Record, phrases: list, fields: list) -> bool:
    '''Takes a record object, a list of strings and a list of fields (as strings).
    Returns a boolean.'''
    for f in fields:
        for rf in record.get_fields(f):
            for p in phrases:
                if p in rf.value().lower():
                    return True
    return False


if __name__ == "__main__":
    if len(sys.argv) == 2:
        inputfile = sys.argv[1]
        iterateFiles(inputfile)
    else:
        print("Usage: python3 findById.py inputfile")
        sys.exit()
