/* jshint node: true */
// Extract records containing only specified LOW-tags from an Aleph Sequantial batch

'use strict';

var readline = require('readline');
var fs = require('fs');
var _ = require('underscore');
var file = process.argv[2];
var lowTags = _.map(process.argv.slice(3), function (tag) { return tag.trim().toUpperCase(); });

if (!file) {
  console.log('Usage: node findByLOWTag.js inputfile lowtag lowtag');
  process.exit();
}

var Record = function Record() { this.ID = ''; this.LOWtags = []; this.content = '';};
var matchingStream = fs.createWriteStream(file + '.matching');

function readInputFile() {
  var rl = readline.createInterface({
    input: fs.createReadStream(file)
  });

  var currentRecord = new Record();

  rl.on('line', function (line) {
    var id = line.slice(0, 9);
    var field = line.slice(10, 13);
    if (field === 'LOW') { currentRecord.LOWtags.push(line.split('$$a')[1].trim()); }
    if (currentRecord.ID !== id) {
      flushData(currentRecord);
      currentRecord = new Record();
      currentRecord.ID = id;
    }
    currentRecord.content += line + '\n';
  }).on('close', function () {
    console.log('Done');
  });
}

function arraysMatch(array1, array2) {
  return _.isEqual(array1, array2);
}

function flushData(currentRecord) {
  if (arraysMatch(lowTags, currentRecord.LOWtags)) {
    matchingStream.write(currentRecord.content);
    console.log(currentRecord.content);
  }
}

readInputFile();