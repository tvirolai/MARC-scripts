/* jshint node: true */

'use strict';

var readline = require('readline');
var fs = require('fs');
var langFile = 'kielikoodit_korjattu.csv';

var osakenttakoodit = {
  'a': 'tekstin tai ääniraidan kieli',
  'b': 'tiivistelmän tai abstraktin kieli', 
  'd': 'lauletun tai puhutun aineiston kieli',
  'e': 'libreton kieli',
  'f': 'sisällysluettelon kieli',
  'g': 'liiteaineiston kieli',
  'h': 'alkuperäinen kieli',
  'j': 'tekstityksen kieli',
  'k': 'välikäännösten kieli',
  'm': 'liiteaineiston alkuperäinen kieli',
  'n': 'libreton alkuperäinen kieli'
};

var kielikoodit = {};

function readLanguageCodes() {
  fs.readFile(langFile, 'utf-8', function (err, data) {
    data = data.split('\n');
    data.forEach(function (line) {
      var line = line.split(',');
      kielikoodit[line[0]] = line[1];
    });
    parseData();
  });
}

readLanguageCodes();

function parseData() {
  var rl = readline.createInterface({
    input: fs.createReadStream('kielikoodit.txt')
  });

  var out = fs.createWriteStream('output.txt');

  rl.on('line', function (line) {
    line = line.trim().replace(' ', ',');
    var splitLine = line.split(',');
    var count = splitLine[0];
    var subfield = splitLine[1];
    var code = splitLine[2];
    var kieli = kielikoodit[code];
    if (kieli !== undefined) {
      out.write(count + ';' + kielikoodit[code] + ';' + '041$' + subfield + ';' + osakenttakoodit[subfield] + '\n');
    } else {
      out.write(count + ';' + code + ';' + '041$' + subfield + ';' + osakenttakoodit[subfield] + '\n');
    }
  }).on('close', function () {
    console.log('Done!');
  });
}
