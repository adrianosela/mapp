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

    isEnabled() {
        return this.allow;
    }

    notify(data, usersTokens) {
        if (!usersTokens) {
            return 0;
        }
        const message = {
            notification: {
                title: data.title,
                body: data.body
            }
        };

        if (this.allow) {

            this.fcm.sendToMultipleToken(message, usersTokens, function(err) {
                if (err) {
                    logger.error(err);
                }
            });
        }
        return usersTokens.length;
    }
}

let notifications = new Notifications();
module.exports = notifications;
