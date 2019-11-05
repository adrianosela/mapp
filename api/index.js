const express = require("express");
const config = require("config");
const logger = require('tracer').console();
const routes = require("./routes/mux");
const db = require("./store/datastore");
const notifications = require("./notifications/notifications");

db.initialize(config.get("database.url"), config.get("database.name"));

notifications.initialize(config.get("notifications.firebase"));

// define http endpoints
const app = express();
app.use("/", routes);

// serve http - when running on Google App Engine, the PORT env variable
// gets set by the runtime. Otherwise we use the default 'port' in config
const server = app.listen(process.env.PORT || config.get("port"), function() {
    logger.info("App listening on " + server.address().port);
});
