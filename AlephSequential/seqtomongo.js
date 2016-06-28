/* jshint node: true */

/* This script serializes the Aleph Sequential dump into JSON and dumps them to MongoDB. */

'use strict';

process.chdir(__dirname);

const Record = require('marc-record-js');
const Serializers = require('marc-record-serializers');
const file = '../dumppi.seq';
const fs = require('fs');
const MongoClient = require('mongodb').MongoClient;
const MongoUrl = 'mongodb://localhost:27017/melinda';

const reader = new Serializers.AlephSequential.Reader(fs.createReadStream(file));

let recs = [];

// Initialize collection in db.

MongoClient.connect(MongoUrl, (err, db) => {
  if (err) throw err;
  db.collection('data').count( (err, count) => {
    if (err) throw err;
    console.log('Dropped existing collection (' + count + ' records).');
    db.collection('data').drop();
    db.close();
  });
});

reader.on('data', record => {
  if (recs.length == 10000) {
    saveToDb(recs);
    recs = [];
  };
  let rec = record.toJsonObject();
  // Set record ID from field 001 to the unique identifier.
  rec._id = rec.fields[0].value;
  recs.push(rec);
}).on('end', () => {
  console.log('Done');
});

function saveToDb(data) {
  MongoClient.connect(MongoUrl, (err, db) => {
    if (err) throw err;
    else {
      db.collection('data').insert(data, (err, doc) => {
        console.log('Successfully inserted ' + data.length + ' recs to database.');
        db.close();
      });
    }
  });
}
