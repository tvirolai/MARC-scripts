/* jshint node: true */

"use strict";

const readline = require("readline");
const fs = require("fs");
const out = fs.createWriteStream("../mikrokortit.txt", "utf-8");

const rl = readline.createInterface({
  input: fs.createReadStream("../dumppi.seq")
});

function splitLine(line) {
  return {
    "id": line.substr(0,9),
    "008": (line.substr(10,3) === "008") ? true : false,
    "content": line.substr(18)
  };
}

function mikrokortti(content) {
  return (content.substr(23,1) === "b" || content.substr(23,1) === "c");
}

rl.on("line", line => {
  if (splitLine(line)["008"] && mikrokortti(splitLine(line).content)) {
    console.log(line);
    out.write(line + "\n");
  }
}).on("close", () => console.log("Done."));
