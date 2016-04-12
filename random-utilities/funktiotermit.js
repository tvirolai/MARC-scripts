/* jshint node: true */

'use strict';

const fs = require('fs');
const readline = require('readline');

const inputfile = "dumppi.seq";

const rl = readline.createInterface({
  input: fs.createReadStream(inputfile)
});

const out = fs.createWriteStream("funktiotermit.txt");

let data = {};

function containsSubfield(line, subfield) {
  return line.indexOf("$$" + subfield) > -1;
}

function trimTerm(term) {
  return term.replace(/[.,:;]/g, "");
}

function processLine(field, line, subfield) {
  let splitLine = line.split("$$" + subfield);
  let term = splitLine[1];
  let nextSubfieldCodeIndex = term.indexOf("$$");
  if (nextSubfieldCodeIndex > -1) {
    term = term.substr(0, nextSubfieldCodeIndex);
  }
  //term = trimTerm(term);
  if (!(term in data)) {
    data[term] = 1;
  } else {
    data[term] += 1;
  }
  if (splitLine.length > 2) {
    splitLine.shift();
    line = splitLine.join("$$" + subfield);
    processLine(field, line, subfield);
  }
}

rl.on("line", function (line) {
  let field = line.split(" ")[1].substr(0,3);
  let begins = field.substr(0,1);
  let ends = field.substr(1,2);
  if (begins === '1' || begins === '6' || begins === '7' || begins === '8') {
    if (ends === '11') {
      if (containsSubfield(line, "j")) {
        processLine(field, line, "j");
      }
    } else {
      if (containsSubfield(line, "e")) {
        processLine(field, line, "e");
      }
    }
  }
}).on("close", function() {
  for (let key in data) {
    console.log(key + " : " + data[key]);
    out.write(key + "\t" + data[key] + "\n");
  }
});
