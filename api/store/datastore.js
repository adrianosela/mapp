const mongoose = require('mongoose');

const options = {
  useCreateIndex: true,
  useNewUrlParser: true,
  useUnifiedTopology: true
};

class Datastore {
  constructor() {}

  /**
   * Initializes connection between client and MongoDB server. 
   * Initializes Datastore properties client, database
   * 
   * @param {string} url - URL of MongoDB server
   * @param {string} dbName - Name of specific database in MongoDB server
   */
  initialize(url, dbName) {
    mongoose.connect(url + '/' + dbName, options).then(() => {
      console.log('[info] successfully connected to ' + dbName + ' at ' + url);

      mongoose.connection.on('error', function(err) {
        console.log('[error] ' + err);
      });

      this.connection = mongoose.connection;
    }).catch((err) => { 
      console.log('[error] could not establish connection with DB: ' + err); 
    });
  }

  conn() {
    return this.connection;
  }
}

let datastore = new Datastore();
module.exports = datastore;
