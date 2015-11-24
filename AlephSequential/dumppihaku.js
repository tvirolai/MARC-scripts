/* jshint node: true */

// Skripti lataa replikointipalvelimelta Melindan datan yhteen valtavaan Aleph Sequential -tiedostoon
// Huom! Oletuksena on, että palvelimella on 10 tiedostoa (alina00.seq - alina09.seq).
// Jos tiedosto on olemassa, se poistetaan ennen latauksen aloittamista.

'use strict';

var http = require('http');
var fs = require('fs');
var urls = [];
var destFile = '/home/tuomo/Työpöytä/Melinda-dumppi/data.seq';

function download(urls) {
  var url = urls.pop();
  var options = {flags: 'a' };
  var file = fs.createWriteStream(destFile, options);
  console.log('Downloading file ' + url + '.');
  http.get(url, function (response) {
    response.pipe(file);
    file.on('finish', function () {
      if (urls.length > 0) { file.close(); download(urls); }
      else { file.close(); console.log('All done!'); }
    }).on('error', function () {
      fs.unlink(destFile);
    });
  });
}

function getUrls() {
  var url = '';
  var urlRoot = 'http://replikointi-kk.lib.helsinki.fi/index/alina';
  for (var i = 0; i < 10; i++) {
    url = urlRoot + '0' + i.toString() + '.seq';
    urls.push(url);
  }
  return urls.reverse();
}

function fileExists(filePath) {
  try {
    return fs.statSync(filePath).isFile();
  }
  catch (err) {
    return false;
  }
}

function checkAndRemove(destFile) {
  if (fileExists(destFile)) {
    fs.unlink(destFile);
    console.log('Removed existing file.');
  }
}

checkAndRemove(destFile);
download(getUrls());