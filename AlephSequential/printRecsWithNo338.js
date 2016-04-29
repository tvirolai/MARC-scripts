/* jshint node: true */

/* This program reads an Aleph Sequential Batch and prints records with no 338 to a separate file. */

'use strict';

const splitLine = require('./splitLine');
const readline = require('readline');
const fs = require('fs');

const out = fs.createWriteStream('../Melinda-recs_with_no338.seq');

const rl = readline.createInterface({
  input: fs.createReadStream("../dumppi.seq")
});

function hasNo338(arrayOfLineObjects) {
  return !arrayOfLineObjects.some(function(value) {
    return value.tag === "338";
  });
}

function isNotDeleted(arrayOfLineObjects) {
  return !arrayOfLineObjects.some(function(value) {
    return value.tag === "DEL";
  });
}

function isNotSupplement(arrayOfLineObjects) {
  return !arrayOfLineObjects.some(function(value) {
    return value.tag === "773";
  })
}

let count = 0;
let currentRec = [];
let currentId = "";

rl.on('line', line => {
  let lineObj = splitLine(line);
  if (lineObj.id !== currentId) {
    currentId = lineObj.id;
    if (hasNo338(currentRec) && isNotDeleted(currentRec) && isNotSupplement(currentRec)) {
      count++;
      currentRec.forEach(function(l) {
        out.write(l.id + " " + l.tag + " " + l.content + "\n");
      });
      out.write("\n");
    }
    currentRec = [];
  }
  currentRec.push(lineObj);

}).on('close', () => console.log("Done, found " + count + " records."));
