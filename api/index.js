// dependencies
var express = require('express');
var config = require('config');
var routes = require('./src/routes/mux');

// define http endpoints
var app = express();
app.use('/', routes);

// serve http
var server = app.listen(process.env.PORT || config.get('Port'), function () {
  console.log('app listening on ' + server.address().port);
});
