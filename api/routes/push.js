const router = require('express').Router();
const notifications = require('../notifications/notifications');
const middleware = require('./middleware');

// import UserSettings schema
let UserSettings = require('../models/userSettings');

router.post('/fcmToken', middleware.verifyToken, async function(req, res) {
    try {
        const userId = req.authorization.id;
        const userFcmToken = req.body.fcmToken;

        let userSettings = await UserSettings.findById(userId);

        userSettings.fcmToken = userFcmToken;
        await userSettings.save();

        // return the received fcm token as confirmation
        res.json({token: userFcmToken});
    }
    catch (error) {
        console.log(error);
        res.status(500).send("Error storing FCM Token");
    }
});

// test push notification endpoint
router.post('/push', middleware.verifyToken, async function(req, res) {
    try {
        const uid = req.body.userId;
        if (!uid) { return res.status(400).send("no user id specified"); }

        let userToNotify = await UserSettings.findById(uid);

        let notification = {
            title: "New Test Notification!",
            body: `You received a test push notification from ${req.authorization.email}`
        }
        notifications.notify(notification, [userToNotify.fcmToken]);

        res.json({success: true, message: "user notified"});
    }
    catch (error) {
        console.log(error);
        res.status(500).send("Error sending push notification");
    }
});

module.exports = router;
