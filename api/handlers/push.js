const notifications = require("../notifications/notifications");

let UserSettings = require("../models/userSettings");

let postToken = async function(req, res) {
    try {
        const userId = req.authorization.id;
        const userFcmToken = req.body.fcmToken;

        if (!userFcmToken) {
            return res.status(400).send("No fcm token supplied");
        }

        let userSettings = await UserSettings.findById(userId);

        userSettings.fcmToken = userFcmToken;
        await userSettings.save();

        // return the received fcm token as confirmation
        res.json({ token: userFcmToken });
    } 
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Error storing FCM Token");
    }
};

// test push notification endpoint
let testPush = async function(req, res) {
    try {
        const uid = req.body.userId;
        if (!uid) {
            return res.status(400).send("No user id specified");
        }

        let userToNotify = await UserSettings.findById(uid);

        if (!userToNotify) {
            return res.status(400).send("User does not exist");
        }

        if (!userToNotify.fcmToken) {
            // should never happen
            console.log(
                `tried to send notification to ${userToNotify.name} but they had no valid FCM token`
            );
            return res.status(400).send("User does not have valid fcm token");
        }

        let notification = {
            title: "New Test Notification!",
            body: `You received a test push notification from ${req.authorization.email}`
        };
        notifications.notify(notification, [userToNotify.fcmToken]);

        res.json({ success: true, message: "User notified" });
    } 
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Error sending push notification");
    }
};

module.exports = {
    post: postToken,
    test: testPush
};
