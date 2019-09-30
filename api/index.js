// dependencies
var express = require('express');
var config = require('config');

// define http endpoints
var app = express();
app.get('/healthcheck', function (req, res) {
  res.send('server is up and running!');
});

// serve http
app.listen(process.env.PORT || config.get('Port'), function () {
  console.log(`app listening on port ${process.env.PORT || config.get('Port')}!`);
});
