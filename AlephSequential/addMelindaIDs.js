/* jshint node: true */

'use strict';

var fs = require('fs');

var readline = require('readline');

var file = './Calonia_varasto.melinda';

var listData = {};

fs.readFile(file, 'utf-8', function (err, data) {
  var splitData = data.split('\n');
  splitData.forEach(function (row) {
    if (row.length > 5) {
      var data = row.split('|');
      data[1] = data[1].replace('\r', '').slice(3);
      listData[data[0]] = data[1];
    }
  });
  readVolterFile();
  console.log(Object.keys(listData).length);
});

function readVolterFile () {

  var volterFile = './VOLTE.txt';
  var rl = readline.createInterface({
    input: fs.createReadStream(volterFile)
  });

  rl.on('line', function (line) {
    var splitLine = line.split(' ');
    var id = splitLine[0];
    var field = splitLine[1]
    var content = splitLine[5];
    if (field === 'SID') {
      var sidNumber = content.slice(3).split('$$')[0];
      if (sidNumber in listData) {
        listData[sidNumber] = id;
        //console.log(sidNumber + ' ' + listData[sidNumber]);
      }
    }
  }).on('close', function () {
    console.log("Lopussa: " + Object.keys(listData).length);
    writeNewFile();
  });
}

function writeNewFile () {
  var rl = readline.createInterface({
    input: fs.createReadStream(file)
  });

  var out = fs.createWriteStream('./Calonia_varasto.melinda.new');

  rl.on('line', function (line) {
    var volterId = line.split('|')[0];
    out.write(line + '|' + listData[volterId] + '\n');
  }).on('close', function () {
    console.log('Jeah.');
  });
}