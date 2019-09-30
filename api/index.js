// dependencies
const express = require('express');
const config = require('config');
const routes = require('./routes/mux');

// define http endpoints
const app = express();
app.use('/', routes);

// serve http
const server = app.listen(process.env.PORT || config.get('Port'), function () {
  console.log('app listening on ' + server.address().port);
});
