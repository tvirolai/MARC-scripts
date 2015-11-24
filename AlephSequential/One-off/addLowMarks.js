/* jshint node: true */

/* Ohjelma:
  1) Lukee listasta muistiin kaikki VOLTERin listan Melinda-IDt
  2) Lukee Melinda-dumpin riveinä. Aina idList-olioon tallennetaan avaimeksi ID ja arvoksi nähtyjen LOW-tagien määrä
*/

'use strict';

var fs = require('fs');
var readline = require('readline');
var dumppi = '../dumppi.seq';
var idList = {};

fs.readFile('./Calonia_varasto.melinda.new', 'utf-8', function (err, data) {
  var splitData = data.split('\n');
  splitData.forEach(function (row) {
    if (row.length > 5) {
      var ID = row.split('|')[2];
      idList[ID] = 0;
    }
  });
  readDump();
});

function readDump () {
  var rl = readline.createInterface({
    input: fs.createReadStream(dumppi)
  });
  var out = fs.createWriteStream('./lowCount.txt');

  rl.on('line', function (line) {
    var lineID = line.split(' ')[0];
    var lineField = line.split(' ')[1].slice(0,3);
    if (lineField === 'LOW') {
      if (lineID in idList) {
        idList[lineID] += 1;
      }
    }
  }).on('close', function () {
    console.log('Writing file.');
    for (var key in idList) {
      if (idList.hasOwnProperty(key)) {
        out.write(key + '|' + idList[key] + '\n');
      }
    }
  });
}