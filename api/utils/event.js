const notifications = require("../notifications/notifications");

let User = require("../models/user");
let UserSettings = require("../models/userSettings");

let friendsGoingToEvent = function(user, event) {
    if (event == null) {
        return 0;
    }

    let userFriends = user.following;
    let attendingEvent = event.followers;

    let attendingFriends = 0;
    for (let friend of userFriends) {
        if (attendingEvent.includes(friend)) {
            attendingFriends++;
        }
    }

    return attendingFriends;
};

let getRelevantEventsForUser = function(events, user, limit = 50) {
    for (let event of events) {
        event.attendingFriends = friendsGoingToEvent(user, event);
    }

    events.sort(function(eventA, eventB) {
        if ((eventA.attendingFriends > 0) || (eventB.attendingFriends > 0)) {
            return eventB.attendingFriends - eventA.attendingFriends;
        }

        return eventB.followers.length - eventA.followers.length;
    });

    if (limit > events.length) {
        limit = events.length;
    }

    events.splice(limit);
    return events;
};

let addUsersAndSendInvites = async function(event, invited, add = false, notify = true) {
    let invitedUsersTokens = [];
    if (invited != null && invited.length !== 0) {
        let users = await User.find({
            _id: { $in: invited }
        });
        for (let user of users) {
            if (add === true) {
                event.invited.addToSet(user._id);
            }
            user.pendingInvites.addToSet(event._id);
            await user.save();
        }

        if (add === true) {
            await event.save();
        }

        let userSettings = await UserSettings.find({
            _id: { $in: invited }
        });
        for (let user of userSettings) {
            invitedUsersTokens.push(user.fcmToken);
        }

        let creator = await User.findById(event.creator);

        let notification = {
            title: "New Event Invitation",
            body: `You have been invited to ${event.name} by ${creator.name}`
        };
        if (notify === true) {
            notifications.notify(notification, invitedUsersTokens);
        }
    }
    return invitedUsersTokens.length;
};

let notifyNewAnnouncement = async function(event, creator, notify = true) {
    if (event.followers != null && event.followers.length !== 0) {
        let userSettings = await UserSettings.find({
            _id: { $in: event.followers }
        });

        let subscribedUsersTokens = [];
        for (let user of userSettings) {
            subscribedUsersTokens.push(user.fcmToken);
        }

        let notification = {
            title: "New Event Announcement",
            body: `${creator.name} just announced to ${event.name}`
        };
        if (notify) {
            notifications.notify(notification, subscribedUsersTokens);
        }
    }
};

module.exports = {
    friendsGoing: friendsGoingToEvent,
    relevantForUser: getRelevantEventsForUser,
    inviteUsers: addUsersAndSendInvites,
    notifyAnnouncements: notifyNewAnnouncement
};
