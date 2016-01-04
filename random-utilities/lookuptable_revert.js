/* jshint node: true */

/* This script reverses the rules of a USEMARCON Look Up Table file. */

"use strict";

const fs = require("fs");
const readline = require("readline");
const rl = readline.createInterface({
  input: fs.createReadStream("Funktiotermit.tbl")
});
const out = fs.createWriteStream("Funktiotermit_lyhennys_test.tbl");

rl.on("line", (line) => {
  out.write( (isRuleLine(line)) ? reverseRule(line) : line );
  out.write("\n");
}).on("close", () => console.log("Done.") );

function isRuleLine(line) {
  return (/[a-zA-Z]/.test(line[0]) && line.indexOf("|") > -1);
}

function reverseRule(line) {
  return line.split("|")[1].trim() + "\t| " + line.split("|")[0];
}