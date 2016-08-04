/* jshint node: true */

/* This script serializes the Aleph Sequential dump into JSON and dumps it to MongoDB. */

'use strict';

process.chdir(__dirname);

const Record = require('marc-record-js');
const Serializers = require('marc-record-serializers');
const file = '../dumppi.seq';
const fs = require('fs');
const MongoClient = require('mongodb').MongoClient;
const MongoUrl = 'mongodb://localhost:27017/melinda';

const reader = new Serializers.AlephSequential.Reader(fs.createReadStream(file));

// Initialize collection in db.

const initialize = new Promise( (resolve, reject) => {
  MongoClient.connect(MongoUrl, (err, db) => {
    if (err) {
      reject(err);
    } else {
      db.collection('data').count( (err, count) => {
        if (err) reject(err);
        db.collection('data').drop();
        db.close();
        resolve('Dropped existing collection (' + count + ' records).');
      });
    }
  });
});

initialize.then( result => {
  let count = 0;
  let recs = [];
  console.log(result);
  reader.on('data', record => {
    if (recs.length == 10000) {
      count += 10000;
      saveToDb(recs, count);
      recs = [];
    };
    let rec = record.toJsonObject();
    // Set record ID from field 001 to be the unique identifier.
    rec._id = rec.fields[0].value;
    recs.push(rec);
  }).on('end', () => {
    console.log('Done');
  });
});


function saveToDb(data, count) {
  MongoClient.connect(MongoUrl, (err, db) => {
    if (err) throw err;
    else {
      db.collection('data').insert(data, (err, doc) => {
        process.stdout.write(`Total amount of inserted records: ${count}\r`);
        db.close();
      });
    }
  });
}
