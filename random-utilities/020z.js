/* jshint node: true */

'use strict';

const fs = require('fs');
const readline = require('readline');
const out = fs.createWriteStream('020z.txt');

const rl = readline.createInterface({
  input: fs.createReadStream("./dumppi.seq")
});

let count = 0;

function splitLine(line) {
  return {
      "id": line.substr(0,9),
      "020": (line.substr(10,3) === "020") ? true : false,
      "content": line.substr(18)
    };
}

rl.on('line', line => {
  if (splitLine(line)["020"]) {
    let data = splitLine(line).content;
    if (data.indexOf('$$z') > -1) {
      data = data.substr(data.indexOf('$$z') + 3);
      if (data.indexOf('$') > -1) {
        data = data.substr(0, data.indexOf('$'));
      }
      data = data.split(" ");
      if (data.length > 1) {
        ++count;
        console.log(line);
        out.write(line + "\n");
      }
    }
  }
}).on('close', () => console.log("Done, found " + count + " records with this error."));
