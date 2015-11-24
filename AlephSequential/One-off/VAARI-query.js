/* jshint node: true */
'use strict';

var fs = require('fs');
var readline = require('readline');
var dumppi = '../files/dumppi.seq';

var stats = {
  'Vaari': 0, // Vaari = ne, joissa on VAIN Vaari low-tag
  'Total': 0,
  'Poikasia': 0,
  'Vaarinpoikaset': 0
};

var rl = readline.createInterface({
  input: fs.createReadStream(dumppi)
});

var temp = {
  'currentId': 0,
  'currentIdLows': [],
  'poikanen': 0
};

rl.on('line', function (line) {
  var lineID = line.split(' ')[0];
  var lineField = line.split(' ')[1].slice(0,3);
  // Tietue vaihtuu
  if (temp.currentId !== lineID) {
    if (temp.currentIdLows.length === 1 && temp.currentIdLows.indexOf('VAARI') > -1) {
     ++stats.Vaari;
     if (temp.poikanen > 0) {
      ++stats.Vaarinpoikaset;
     }
   }
    ++stats.Total;
    stats.Poikasia += temp.poikanen;
    temp.currentId = lineID;
    temp.currentIdLows = [];
    temp.poikanen = 0;
    if (stats.Total % 10000 === 0) { console.log(stats.Total + ' tietuetta luettu...'); }
  }
  if (lineField === 'LOW') { var lowtag = line.split('$$a')[1]; temp.currentIdLows.push(lowtag);}
  if (lineField === '773') { ++temp.poikanen; }
}).on('close', function () {
  var percentage = (stats.Vaari / stats.Total * 100).toFixed(1);
  console.log('Tulokset (poikaset mukana):');
  console.log('Melindassa tietueita yhteensä: ' + stats.Total + ', joista poikasia: ' + stats.Poikasia + '\nTietueita, joissa vain Vaarin low-tag: ' + stats.Vaari + ' (' + percentage + ' %)');
  console.log('Tulokset (ilman poikastietueita):');
  var ilmanPoikasia = (stats.Total - stats.Poikasia);
  percentage = (stats.Vaari / ilmanPoikasia * 100).toFixed(1);
  console.log('Tulokset (ilman poikasia):\nMelindassa tietueita yhteensä: ' + ilmanPoikasia + '\nTietueita, joissa vain Vaarin low-tag: ' + stats.Vaari + ' (' + percentage + ' %)');
  console.log('Vaarilla poikasia: ' + stats.Vaarinpoikaset);
});