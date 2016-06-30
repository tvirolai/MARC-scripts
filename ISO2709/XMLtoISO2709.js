/* jshint node: true */

/* This script reads all MARCXML files in directory, converts them to ISO2709
 * (MARC Exchange format) and writes to a batch file. */

'use strict';

const fs = require('fs');
const Serializers = require('marc-record-serializers');
const toISO2709 = Serializers.ISO2709.toISO2709;
const fromXML = Serializers.MARCXML.fromMARCXML;
const _ = require('underscore');

let inputFile = '';

let out = fs.createWriteStream('./converted.mrc');

fs.readdir('.', (err, res) => {
  let files = _.filter(res, file => { return file.indexOf('xml') === file.length - 3 ; });
  _.each(files, convertRecord);
});

function convertRecord(inputFile) {
  fs.readFile(inputFile, 'utf-8', (err, res) => {
    let record = fromXML(res);
    out.write(toISO2709(record));
  });
}
