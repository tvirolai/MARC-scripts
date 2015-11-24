/* jshint node: true */

/* Ohjelma yhdistää hakemistossa ../files sijaitsevat Aleph Sequential -tiedostot yhteen jättitiedostoon (../dumppi.seq) */

'use strict';

var fs = require('fs');

var dumpDir = '../files/';
var out = fs.createWriteStream('../dumppi.seq');

var dumpFiles = [];

fs.readdir(dumpDir, function (err, files) {
  dumpFiles = files.reverse();
  var file = dumpDir + dumpFiles.pop();
  stream(file);
});

function stream (file) {
  console.log('Streaming file ' + file + '.');
  var readStream = fs.createReadStream(file);
  readStream.pipe(out);
  readStream.on('finish', function () {
    if (dumpFiles.length === 0) {
      console.log('Ready!');
    } else {
      var file = dumpDir + dumpFiles.pop();
      var readStream = fs.createReadStream(file);
    }
  });
}