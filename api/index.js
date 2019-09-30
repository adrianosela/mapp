// dependencies
const express = require('express');
const config = require('config');
const routes = require('./routes/mux');
const db = require('./store/datastore');
const authenticator = require('./auth/authenticator');

// init db
db.initialize(
  config.get("database.url"),
  config.get("database.name"));

// init google auth
authenticator.initialize(
  config.get('auth.google.clientid'),
  config.get('auth.google.clientsecret'),
  config.get('auth.google.redirecturl'));

// define http endpoints
const app = express();
app.use('/', routes);

// serve http
const server = app.listen(process.env.PORT || config.get('port'), function () {
  console.log('[info] app listening on ' + server.address().port);
});
