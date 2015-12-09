/* jshint node: true */

'use strict';

var readline = require('readline');
var fs = require('fs');
var _ = require('underscore');

var rl = readline.createInterface({
  input: fs.createReadStream('JULKAISUVUODET.txt')
});

var out = fs.createWriteStream('JULKAISUVUODET_parsittu.txt');

var tilasto = {
  '2010-': 0,
  '2000-2009': 0,
  '1990-1999': 0,
  '1980-1989': 0,
  '1970-1979': 0,
  '1960-1969': 0,
  '1950-1959': 0,
  '1940-1949': 0,
  '1930-1939': 0,
  '1920-1929': 0,
  '1910-1919': 0,
  '1900-1909': 0,
  '1800-luku': 0,
  '1700-luku': 0,
  '< 1700-luku': 0,
  'tunnistamaton': 0
};

rl.on('line', function (line) {
  var count = line.trim().split(' ')[0];
  var year = line.trim().split(' ')[1];
  if (year >= 2010) { tilasto['2010-'] += Number(count); }
  else if (year <= 2009 && year >= 2000 ) { tilasto['2000-2009'] += Number(count); }
  else if (year <= 1999 && year >= 1990 ) { tilasto['1990-1999'] += Number(count); }
  else if (year <= 1989 && year >= 1980 ) { tilasto['1980-1989'] += Number(count); }
  else if (year <= 1979 && year >= 1970 ) { tilasto['1970-1979'] += Number(count); }
  else if (year <= 1969 && year >= 1960 ) { tilasto['1960-1969'] += Number(count); }
  else if (year <= 1959 && year >= 1950 ) { tilasto['1950-1959'] += Number(count); }
  else if (year <= 1949 && year >= 1940 ) { tilasto['1940-1949'] += Number(count); }
  else if (year <= 1939 && year >= 1930 ) { tilasto['1930-1939'] += Number(count); }
  else if (year <= 1929 && year >= 1920 ) { tilasto['1920-1929'] += Number(count); }
  else if (year <= 1919 && year >= 1910 ) { tilasto['1910-1919'] += Number(count); }
  else if (year <= 1909 && year >= 1900 ) { tilasto['1900-1909'] += Number(count); }
  else if (year <= 1899 && year >= 1800 ) { tilasto['1800-luku'] += Number(count); }
  else if (year <= 1799 && year >= 1700 ) { tilasto['1700-luku'] += Number(count); }
  else if (year < 1700) { tilasto['< 1700-luku'] += Number(count); }
  else { tilasto.tunnistamaton += Number(count); }
}).on('close', function () {
  var sum = _.reduce(_.values(tilasto), function (memo, num) { return memo + num; }, 0);
  for (var key in tilasto) {
    out.write(key + ';' + tilasto[key] + ';' + percentage(tilasto[key], sum) + '\n');
  }
  console.log('Done.');
});

function percentage(amount, total) {
  return (amount / total * 100).toFixed(1);
}