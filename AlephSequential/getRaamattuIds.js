/* jshint node: true */

'use strict';

const splitLine = require('./splitLine');
const readline = require('readline');
const fs = require('fs');
const _ = require('underscore');

const outRecs = fs.createWriteStream('../Raamattu_tietueet.seq');
const outIds = fs.createWriteStream('../Raamattu_idt.seq');

const rl = readline.createInterface({
  input: fs.createReadStream("../dumppi.seq")
});

let count = 0;
let currentRec = [];
let currentId = "0";
const fields = ["130", "240", "600", "610", "630", "700", "710", "730", "800", "810", "830"];
const phrases = ["ut", "vt", "uusi testamentti", "vanha testamentti"];

function needsAction(arrayOfLineObjects) {
  return arrayOfLineObjects.some( value => {
    return _.contains(fields, value.tag) && ( (value.content.indexOf("$$p") !== value.content.lastIndexOf("$$p"))) && phrases.some(phrase => {
      return _.contains(phrases, phrase.toLowerCase());
    });
  });
}

rl.on('line', line => {
  let lineObj = splitLine(line);
  if (lineObj.id !== currentId) {
    currentId = lineObj.id;
    if (needsAction(currentRec)) {
      count++;
      outIds.write(currentRec[0].id + "\n");
      console.log(currentRec[0].id);
      currentRec.forEach(l => {
        outRecs.write(l.id + " " + l.tag + " " + l.content + "\n");
      });
      outRecs.write("\n");
    }
    currentRec = [];
  }
  currentRec.push(lineObj);

}).on('close', () => console.log("Done, found " + count + " records."));
