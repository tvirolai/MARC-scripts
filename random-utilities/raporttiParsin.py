#!/usr/bin/env python

import sys

def format(line):
  	lista = line.strip().split(" ")
  	return ";".join(lista[0:2]) + " " + " ".join(lista[2:]) + "\n"

with open(sys.argv[1], 'r') as f:
	out = open(sys.argv[1] + ".formatted", "w")
	for line in f:
		out.write(format(line))