/* jshint node: true */

'use strict';

var lowData = {};
var readline = require('readline');
var fs = require('fs');

fs.readFile('./lowCount.txt', 'utf-8', function (err, data) {
  var list = data.split('\n');
  list.forEach(function (item) {
    if (item.length > 5) {
      var itemList = item.split('|');
      lowData[itemList[0]] = Number(itemList[1]);
    }
  });
  combineData()
});

function combineData() {
  var rl = readline.createInterface({
    input: fs.createReadStream('./Calonia_varasto.melinda.new')
  });

  var out = fs.createWriteStream('./Calonia_varasto.melinda.lowtags');
  rl.on('line', function (line) {
    var splitLine = line.split('|');
    out.write(splitLine[0] + '|' + splitLine[1] + '|' + splitLine[2] + '|');
    if (lowData[splitLine[2]] === 1) {
      out.write('X');
    }
    out.write('\n');
  }).on('close', function() {
    console.log('Ready.');
  });
}