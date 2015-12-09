/* jshint node: true */

'use strict';

var readline = require('readline');
var fs = require('fs');

var rl = readline.createInterface({
  input: fs.createReadStream('sisaltoJaMedia_maarat.txt')
});

var out = fs.createWriteStream('SISALTOJAMEDIATYYPIT.txt');

rl.on('line', function (line) {
  out.write(line.trim().replace(' ', ';').replace('336,', '').replace('337,', '') + '\n');
}).on('close', function () {
  console.log('Done.');
});