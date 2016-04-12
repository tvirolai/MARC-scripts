/* jshint node: true */

/* This script reads a list of Melinda-id's, fetches the records from Melinda API and 
* writes them to a MARC 21 (Exchange format) batch file.
* Arguments: 1) file to read (list of id's), 2) outputfile for fetched records. */

'use strict';

const fs = require('fs');
const request = require('request');
const readline = require('readline');
const Serializers = require('marc-record-serializers');
const toISO2709 = Serializers.ISO2709.toISO2709;
const fromXML = Serializers.MARCXML.fromMARCXML;
const apiEndpoint = "http://melinda.kansalliskirjasto.fi/API/v1/bib/";

let inputFile = "";
let outputFile = "";
let idList = [];

if (process.argv.length !== 4) {
  console.log('Usage: node getRecsFromList.js inputfile outputfile');
  process.exit();
} else {
  inputFile = process.argv[2];
  outputFile = process.argv[3];
}

let out = fs.createWriteStream(outputFile);
let errorLog = fs.createWriteStream("error.log");

const rl = readline.createInterface({
  input: fs.createReadStream(inputFile)
});

let totalRecs = 0;
let readRecs = 0;

rl.on("line", line => {
  if (line.length === 9) {
    idList.push(line);
  }
}).on("close", () => {
  totalRecs = idList.length;
  getRecords(idList.reverse());
});


function getRecords(ids) {
  let uri = apiEndpoint + ids.pop();
  request(uri, (err, res, body) => {
    readRecs++;
    console.log("Read " + readRecs + " / " + totalRecs + " records.");
    try {
      let record = fromXML(body);
      out.write(toISO2709(record));
    }
    catch (err) {
      errorLog.write("An error occurred.\nRecord: " + uri + "\n" + err + "\n");
    }
    finally {
      if (ids.length > 0) {
        setTimeout( () => {
          getRecords(ids);
        }, 500);
      } else {
      console.log("Done.");
      }
    }   
  });
}
