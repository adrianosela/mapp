// dependencies
const express = require('express');
const config = require('config');
const routes = require('./routes/mux');
const store = require('./store/datastore');

// initialize database
let db = new store();
db.initialize(config.get("database.url"), config.get("database.name"));

// define http endpoints
const app = express();
app.use('/', routes);

// serve http
const server = app.listen(process.env.PORT || config.get('port'), function () {
  console.log('[info] app listening on ' + server.address().port);
});
