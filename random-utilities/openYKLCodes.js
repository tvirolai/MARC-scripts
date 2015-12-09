/* jshint node: true */

/* 
The script 
1) reads a TSV file mapping YKL codes to their descriptions (YKLFile)
2) then reads a file (inputfile) listing codes with their occurrence counts (produced by performing a "sort file | uniq -c | sort -hr > file.txt" bash command)
3) produces a new TSV file (outputFile) in the format 74531 84.2  Suomenkielinen kaunokirjallisuus
*/

"use strict";

var readline = require("readline");
var fs = require("fs");
var _ = require("underscore");

var YKLFile = "YKL-koodien_avaustaulukko.tsv";
var inputFile = "/home/tuomo/Työpöytä/PIKIn_analyysit/data/UUTENATULLEET/raportit/YKL-luokitukset_uudet.txt";
var outputFile = inputFile.slice(0, inputFile.indexOf(".")) + "AVATTU.tsv";

constructCodeMap(YKLFile, processFiles);

function constructCodeMap(inputFile, callback) {
  fs.readFile(YKLFile, "utf-8", function (err, data) {
    callback(_.object(_.map(data.split("\n"), function (d) { return d.split("\t"); })));
  });
}

function processFiles(mapObject) {
  var rl = readline.createInterface({
    input: fs.createReadStream(inputFile)
  });
  var out = fs.createWriteStream(outputFile);
  rl.on("line", function (line) {
   out.write(returnCount(line) + "\t" + returnCode(line) + "\t" + returnDescription(line, mapObject) + "\n");
  }).on("close", function () {
    console.log("Done!");
  });
}

function returnCount(line) {
  return line.trim().split(" ")[0];
}

function returnCode(line) {
  return line.trim().split(" ")[1];
}

function returnDescription(line, mapObject) {
 return (mapObject[returnCode(line)] !== undefined) ? mapObject[returnCode(line)] : "";
}