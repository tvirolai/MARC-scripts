/* jshint node: true */

/* Skripti lataa replikointipalvelimelta Melindan datan yhteen valtavaan Aleph Sequential -tiedostoon Huom! Oletuksena on, 
että palvelimella on 10 tiedostoa (alina00.seq - alina09.seq). Jos tiedosto on olemassa, se poistetaan ennen latauksen aloittamista. */

'use strict';

const http = require('http'), fs = require('fs'), _ = require('underscore');

download(getUrls(), fs.createWriteStream('../data.seq'));

function download(urls, outputStream) {
  console.log('Downloading file ' + urls[0] + '.');
  http.get(urls.shift(), (response) => { response.pipe(outputStream);
    outputStream.on('finish', () => { 
      if (urls.length > 0) { download(urls, fs.createWriteStream('../data.seq', { flags: 'a' })); 
    } else { console.log('All done!'); }});
  });
}

function getUrls() {
  return _.map(_.range(0,10), function (d) { return 'http://replikointi-kk.lib.helsinki.fi/index/alina0' + d + '.seq'; });
}