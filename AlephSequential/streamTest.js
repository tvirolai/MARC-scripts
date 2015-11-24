/* jshint node: true */
'use strict';

var fs = require('fs');

var input = './VAARI.txt';

var stream = fs.createReadStream(input);
var out = fs.createWriteStream('./jeesus.txt');

stream.pipe(out);