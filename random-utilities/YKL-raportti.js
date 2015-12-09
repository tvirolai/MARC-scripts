/* jshint node: true */

'use strict';

var fs = require('fs');
var _ = require('underscore');

var names = {};
var counts = {};

var out = fs.createWriteStream('YKL-raportti.txt');

fs.readFile('YKL-luokat_avattu.txt', 'utf-8', function (err, data) {
  var array = data.split('\n');
  array = _.filter(array, function (d) { return /[0-9]/.test(d); });
  array.forEach(function (d) {
    var asList = d.split(' ');
    var code = asList.shift();
    var description = asList.join(' ');
    names[code] = description;
  });
  fs.readFile('YKL-luokat.txt', 'utf-8', function (err, data) {
    var array2 = data.split('\n');
    array2.forEach(function (d) {
      var asList2 = d.trim().split(' ');
      var code = asList2[1];
      var count = asList2[0];
      counts[code] = count;
    });
    parseData();
  });
});


function parseData() {
  for (var key in counts) {
    out.write(counts[key] + '\t' + key);
    if (names[key]) { out.write('\t' + names[key]); }
    out.write('\n')
  }
}
