/* jshint node: true */
// Extract records containing only specified LOW-tags from an Aleph Sequential batch

'use strict';

//var readline = require('readline');
var fs = require('fs');
var _ = require('underscore');
var es = require('event-stream');
var file = process.argv[2];
var lowTags = _.map(process.argv.slice(3), function (tag) { return tag.trim().toUpperCase(); });

if (!file) {
  console.log('Usage: node findByLOWTag.js inputfile lowtag lowtag');
  process.exit();
}

var Record = function Record() { this.ID = ''; this.LOWtags = []; this.content = '';};
var matchingStream = fs.createWriteStream(file + '.matching');
var r = fs.createReadStream(file);

readInputFile();

function readInputFile() {

  var writeCount = 0;

  var currentRecord = new Record();

  r.pipe(es.split()).pipe(es.mapSync(function (line) {
    var id = line.slice(0, 9);
    console.log(id);
    var field = line.slice(10, 13);
    if (field === 'LOW') { currentRecord.LOWtags.push(line.split('$$a')[1]); }
    if (currentRecord.ID !== id) {
      console.log("VAIHTO")
      r.pause();
      flushData(currentRecord, function() {
        r.resume();
      });
      ++writeCount;
      currentRecord = new Record();
      currentRecord.ID = id;
    }
    currentRecord.content += line + '\n';
    //r.resume();
    })
  );

//   var writeCount = 0;

//   var rl = readline.createInterface({
//     input: fs.createReadStream(file)
//   });

//   var currentRecord = new Record();

//   rl.on('line', function (line) {
//     var id = line.slice(0, 9);
//     var field = line.slice(10, 13);
//     if (field === 'LOW') { currentRecord.LOWtags.push(line.split('$$a')[1]); }
//     if (currentRecord.ID !== id) {
//       flushData(currentRecord);
//       ++writeCount;
//       currentRecord = new Record();
//       currentRecord.ID = id;
//     }
//     currentRecord.content += line + '\n';
//   }).on('close', function () {
//     console.log('Done, ' + writeCount + ' records written.');
//   });
// }
}

function arraysMatch(array1, array2) {
  return _.isEqual(array1.sort(), array2.sort());
}

function flushData(currentRecord, callback) {
  if (arraysMatch(lowTags, currentRecord.LOWtags)) {
    matchingStream.write(currentRecord.content, callback);
  }
}
