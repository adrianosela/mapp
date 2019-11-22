const logger = require("tracer").console();
const Event = require("../models/event");
const UserSettings = require("../models/userSettings");
const notifications = require("../notifications/notifications");

const ONE_HOUR_IN_S = 3600;

let remind = async function() {
    try {
        const now = Math.floor(Date.now() / 1000);
        
        let events = await Event.find({})
            .gte("startTime", now)
            .lte("startTime", now + ONE_HOUR_IN_S);

        for (let event of events) {
            let userSettings = await UserSettings.find({
                _id: { $in: event.followers }
            });

            let subscribedUsersTokens = [];
            for (let user of userSettings) {
                subscribedUsersTokens.push(user.fcmToken);
            }

            let notification = {
                title: "Upcoming Event",
                body: `${event.name} is starting soon...`
            };
            notifications.notify(notification, subscribedUsersTokens);
        }
    }
    catch (e) {
        logger.error(e);
    }
};

module.exports = {
    remindUsers: remind
};
