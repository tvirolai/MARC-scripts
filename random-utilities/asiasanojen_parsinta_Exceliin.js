/* jshint node: true */

'use strict';

var readline = require('readline');
var fs = require('fs');

var rl = readline.createInterface({
  input: fs.createReadStream('ASIASANAT.txt')
});

var out = fs.createWriteStream('ASIASANAT_parsittu.txt');

rl.on('line', function (line) {
  line = line.trim().replace(' ', ';');
  var count = line.split(';')[0];
  if (Number(count) >= 1000) {
    out.write(line + '\n');
  }
}).on('close', function () {
  console.log('Done!');
});