const logger = require("tracer").console();
const Event = require("../models/event");
const UserSettings = require("../models/userSettings");
const notifications = require("../notifications/notifications");

const ONE_HOUR_IN_S = 3600;

let remind = async function() {
    try {
        const start = Math.floor(Date.now() / 1000);
        const end = start + ONE_HOUR_IN_S;

        logger.info(`[reminders] starting sweep from ${start} to ${end}`);

        let events = await Event.find({})
            .gte("startTime", start)
            .lte("startTime", end);

        logger.info(`[reminders] ${events.length} events require sending reminders`);

        for (let event of events) {
            let userSettings = await UserSettings.find({
                _id: { $in: event.followers }
            });

            let subscribedUsersTokens = [];
            for (let user of userSettings) {
                if (user.fcmToken) {
                    subscribedUsersTokens.push(user.fcmToken);
                }
                else {
                    logger.info(`could not remind ${user.email} of event ${event._id}. no fcm token for user found`);
                }
            }

            let notification = {
                title: "Upcoming Event",
                body: `${event.name} is starting soon...`
            };
            logger.info(`[reminders] sending ${notification}`);
            notifications.notify(notification, subscribedUsersTokens);
            logger.info(`[reminders] sent ${notification}`);
        }

        logger.info(`[reminders] finished sweep from ${start} to ${end} successfully!`);
    }
    catch (e) {
        logger.error(e);
    }
};

module.exports = {
    remindUsers: remind
};
