/* jshint node: true */

/* Generate a USEMARCON Reg Table from Excel. Output format: "[Dd]ata | digitaalinen data" */

"use strict";

const fs = require("fs");
const XLSX = require("xlsx");
const workbook = XLSX.readFile("RDA-konversiosuunnitelmat.xlsx");
const worksheet = workbook.Sheets[workbook.SheetNames[1]];
const out = fs.createWriteStream("336_a.regtbl");

out.write("336_a.regtbl -- RDA-sisältötyypit koodit kentässä 336 $a\nFile generated: " + new Date() + "\n\n");

for (let i = 190; i <= 214; i++) {
  let from = worksheet["A" + i].v;
  let to = worksheet["G" + i].v;
  out.write("\'" + parseToRegex(from) + "\' | \'" + to.toLowerCase() + "\'\n");
}

function parseToRegex(string) {
  let asArray = string.split("");
  let initial = asArray.shift();
  initial = "[" + initial + initial.toLowerCase() + "]";
  return initial + asArray.join("");
}