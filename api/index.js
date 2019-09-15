// Load express module
var express = require('express')
var app = express()

// Define endpoints
app.get('/healthcheck', function (req, res) {
  res.send('server is up and running!')
})

// Serve HTTP
app.listen(80, function () {
  console.log('app listening on port 80!')
})
