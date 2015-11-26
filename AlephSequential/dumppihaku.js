/* jshint node: true */

// Skripti lataa replikointipalvelimelta Melindan datan yhteen valtavaan Aleph Sequential -tiedostoon
// Huom! Oletuksena on, että palvelimella on 10 tiedostoa (alina00.seq - alina09.seq).
// Jos tiedosto on olemassa, se poistetaan ennen latauksen aloittamista.

'use strict';

var http = require('http');
var fs = require('fs');
var _ = require('underscore');
var destFile = '../data.seq';

if (fs.statSync(destFile).isFile()) { fs.unlink(destFile); console.log('Removed existing file'); }
download(getUrls(), destFile);

function download(urls, destination) {
  var file = fs.createWriteStream(destination, { flags: 'a' });
  console.log('Downloading file ' + urls[0] + '.');
  http.get(urls.shift(), function (response) {
    response.pipe(file);
    file.on('finish', function () {
      if (urls.length > 0) { file.close(); download(urls, destination); }
      else { file.close(); console.log('All done!'); }
    }).on('error', function () { fs.unlink(destination); });
  });
}

function getUrls() {
  return _.map(_.range(0,10), function (d) { return 'http://replikointi-kk.lib.helsinki.fi/index/alina0' + d + '.seq'; });
}