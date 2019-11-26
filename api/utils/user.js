const notifications = require("../notifications/notifications");

let UserSettings = require("../models/userSettings");

let notifyNewFollower = async function(followee, follower, notify = true) {
    let userTokens = [];
    let userSettings = await UserSettings.findById(followee._id);

    if (!userSettings.fcmToken) {
        return;
    }

    let notification = {
        title: "New Follower",
        body: `${follower.name} just followed you`
    };
    if (notify) {
        notifications.notify(notification, userTokens);
    }
};

module.exports = {
    notifyFollowee: notifyNewFollower
};
