const Fcm = require("fcm-notification");
const logger = require("tracer").console();

class Notifications {
    constructor() {
        this.fcm = null;
    }

    initialize(fcmSettings) {
        this.fcm = new Fcm(fcmSettings);
    }

    notify(data, usersTokens) {
        const message = {
            notification: {
                title: data.title,
                body: data.body
            }
        };

        this.fcm.sendToMultipleToken(message, usersTokens, function(err) {
            if (err) {
                logger.error(err);
            }
        });
    }
}

let notifications = new Notifications();
module.exports = notifications;
