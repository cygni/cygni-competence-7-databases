
const readline = require('readline');
const elasticsearch = require('elasticsearch');
const fs = require('fs');

console.log('Bulk loader Starting');

const client = elasticsearch.Client({
            hosts: 'localhost:9200',
            httpAuth: 'elastic:changeme',
        });

function flushBatch(batch) {
  return client.bulk({body: batch});
}

const rl = readline.createInterface({
            input: require('fs').createReadStream('../data/masters_all.json'),
            console: false,
        });

const batchSize = 100000;
let batch = [];
let count = 0;

let requestInProgress = false;

rl.on('line', line => {
  count += 1;
  batch.push(JSON.parse(line));

  if (!requestInProgress && batch.length >= batchSize && batch.length % 2 === 0) {
    rl.pause();
    const toSend = batch;
    batch = [];
    requestInProgress = true;
    flushBatch(toSend).then(() => {
      console.log(`indexed ${count} docs`);
      requestInProgress = false;
      rl.resume();
    }).catch(err => {
      console.log('Got error');
      console.error(err);
      process.exit();
    });
  }

});

rl.on('close', () => {
  if (batch.length > 0) {
    flushBatch(batch).then(() => {
      console.log(`indexed ${count} docs`);
      console.log('Great success! \uD83D\uDC4D');
      process.exit();
    }).catch(err => {
      console.log('Got error');
      console.error(err);
      process.exit();
    });
  }
});
