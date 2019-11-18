const Fcm = require("fcm-notification");
const logger = require("tracer").console();

class Notifications {
    constructor() {
        this.fcm = null;
        this.allow = true;
    }

    initialize(fcmSettings, allowNotifications = true) {
        this.allow = allowNotifications;
        if (this.allow) {
            this.fcm = new Fcm(fcmSettings);
        }
    }

    notify(data, usersTokens) {
        if (!this.allow) {
            return;
        }
        
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
