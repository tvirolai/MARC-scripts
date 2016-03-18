/* jshint node: true */
'use strict';

var marc = require('marcjs');
var fs = require('fs');

var reader = new marc.Iso2709Reader(fs.createReadStream(process.argv[2]));

var writer = new marc.TextWriter(fs.createWriteStream(process.argv[3]));

reader.pipe(writer);
