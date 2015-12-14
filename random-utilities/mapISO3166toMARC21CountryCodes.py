#!/usr/bin/env python
# -*- coding: utf-8 -*

isoCodeFile = "ISO-3166-maakoodit.tsv"
MARC21CodeFile = "maakoodiTaulukko_korjattu.csv"

codeToCountryMap = {}

with open(MARC21CodeFile, "r") as f:
    for line in f:
        code, country = line.split(",")[0:2]
        codeToCountryMap[country] = code

out = open("ISO-3166-maakoodit_ja_MARC21_maakoodit.tsv", "w")

with open(isoCodeFile, "r") as f:
    for line in f:
        splitLine = [x.strip() for x in line.split("\t")]
        try:
            splitLine.append(codeToCountryMap[splitLine[0]])
        except KeyError:
            pass
        out.write("\t".join(splitLine) + "\n")