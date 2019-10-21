// dependencies
const express = require('express');
const config = require('config');
const routes = require('./routes/mux');
const db = require('./store/datastore');
const authenticator = require('./auth/authenticator');
const notifications = require('./notifications/notifications');

// init db
db.initialize(
    config.get("database.url"),
    config.get("database.name")
);

// init google auth
authenticator.initialize(
    config.get('auth.google.clientid'),
    config.get('auth.google.clientsecret'),
    config.get('auth.google.redirecturl')
);

// init Firebase Cloud Messaging
notifications.initialize(
    config.get('notifications.firebase')
);

// define http endpoints
const app = express();
app.use('/', routes);

// serve http - when running on Google App Engine, the PORT env variable
// gets set by the runtime. Otherwise we use the default 'port' in config
const server = app.listen(process.env.PORT || config.get('port'), function () {
    console.log('[info] app listening on ' + server.address().port);
});
