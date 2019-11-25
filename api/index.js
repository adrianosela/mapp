const config = require("config");
const logger = require("tracer").console();
const app = require("./server");
const db = require("./store/datastore");
const notifications = require("./notifications/notifications");
const reminder = require("./reminders/reminders");
const cron = require("node-cron");

db.initialize(config.get("database.url"), config.get("database.name"));

notifications.initialize(config.get("notifications.firebase"));

// run a cron job in the background which sends 
// reminder notifications at minute 30 of every hour
cron.schedule("* * * * *", function() {
    reminder.remindUsers();
});

// serve http - when running on Google App Engine, the PORT env variable
// gets set by the runtime. Otherwise we use the default 'port' in config
const server = app.listen(process.env.PORT || config.get("port"), function() {
    logger.info("App listening on " + server.address().port);
});
