// Load express module
var express = require('express');
// External Configurations
var config = require('config');

var app = express();

// Define endpoints
app.get('/healthcheck', function (req, res) {
  res.send('server is up and running!');
});

// Serve HTTP
app.listen(config.get('Port'), function () {
  console.log(`app listening on port ${config.get('Port')}!`);
});