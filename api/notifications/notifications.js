const fcm = require("fcm-notification");

class Notifications {
    constructor() {
        this.fcm = null;
    }

    initialize(fcmSettings) {
        this.fcm = new fcm(fcmSettings);
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
                console.log(err);
            }
        });
    }
}

let notifications = new Notifications();
module.exports = notifications;
