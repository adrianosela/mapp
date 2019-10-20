const fcm = require('fcm-notification');

class NotificationsEngine {
    constructor() {
        this.fcm = null;
        this.tokens = [];
    }

    initialize(fcmSettings) {
        this.fcm = new fcm(fcmSettings);
    }

    addToken(userToken) {
        this.tokens.push(userToken);
    }

    notify(data) {
        const message = {
            notification: {
                title: 'New Event Invitation',
                body: `You have been invited to ${data.eventName} by ${data.creator}`
            }
        };

        this.fcm.sendToMultipleToken(message, this.tokens, function(err, resp) {
            if (err) {
                console.log(err);
            }
        });
    }

    clearTokens() {
        this.tokens = [];
    }
}

let notificationsEngine = new NotificationsEngine();
module.exports = notificationsEngine;
