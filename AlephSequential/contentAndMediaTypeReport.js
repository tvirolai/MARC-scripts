/* jshint node: true */

/* This script reads an Aleph Seq dump file and prints the contents of 
 * content and media type fields (336 and 337) to output file (on
 * one line). 
 */ 

"use strict";

var readline = require("readline");
var fs = require("fs");

var inputFile = process.argv[2];

if (!inputFile) { 
  console.log("Usage: node contentAndMediaTypeReport.js inputfile");
  process.exit();
}

var rl = readline.createInterface({
  input: fs.createReadStream(inputFile)
});

var out = fs.createWriteStream(inputFile + ".336and337");

function CurrentRecord(id) {
  this.id = id;
  this.contentType = [];
  this.mediaType = [];
}

var currentRecord = new CurrentRecord(0);

rl.on("line", function (line) {
  var recId = line.split(" ")[0];
  if (recId !== currentRecord.id) {
    out.write(currentRecord.contentType.join(",") + "\t" + currentRecord.mediaType.join(",") + "\n");
    currentRecord = new CurrentRecord(recId);
  }
  var field = line.split(" ")[1];
  var content = line.split("$$a")[1];
  if (field === "336") { 
    currentRecord.contentType.push(content);
  } else if (field === "337") {
    currentRecord.mediaType.push(content);
  }
}).on("close", function () {
  console.log("Done.");
});
