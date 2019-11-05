const logger = require("tracer").console();
const notifications = require("../notifications/notifications");
const validator = require("../validator/validator");

// import Event and User schemas
let Event = require("../models/event");
let User = require("../models/user");
let UserSettings = require("../models/userSettings");

// retrieve all data on an event by id in query string
let getEvent = async function(req, resp) {
    try {
        const eventId = req.query.id;
        if (!eventId) {
            return resp.status(400).send("No event id in query string");
        }

        let event = await Event.findById(eventId);
        if (!event) {
            return resp.status(404).send("Event not found");
        }
        resp.json(event);
    }
    catch (e) {
        logger.error(e);
        return resp.status(500).send("Could not retrieve event");
    }
};

// create an event (from json request body)
let createEvent = async function(req, resp) {
    try {
    // creator from token
        const creator = req.authorization.id;

        // event details from req body
        const {
            name,
            description,
            latitude,
            longitude,
            startTime,
            endTime,
            public
        } = req.body;

        // enforce types
        const lat = Number(latitude);
        const lon = Number(longitude);
        const start = Number(startTime);
        const end = Number(endTime);

        let invited = req.body.invited;
        if (!invited) {
            // avoid null array
            invited = [];
        }

        // validate inputs
        let val = validator.event(name, description, lat, lon, start, end);
        if (val.ok === false) {
            return resp.status(400).send(val.error);
        }

        let newEvent = new Event({
            name: name,
            description: description,
            location: { type: "Point", coordinates: [lon, lat] },
            startTime: start,
            endTime: end,
            creator: creator,
            public: public,
            invited: invited
        });

        let event = await newEvent.save();

        let creatorUser = await User.findById(creator);
        creatorUser.createdEvents.push(event._id);
        await creatorUser.save();

        if (invited != null && invited.length !== 0) {
            let users = await User.find({
                _id: { $in: invited }
            });
            for (let user of users) {
                user.pendingInvites.push(event._id);
                await user.save();
            }

            // Notify Invited Users
            let userSettings = await UserSettings.find({
                _id: { $in: invited }
            });

            let invitedUsersTokens = [];
            for (let user of userSettings) {
                invitedUsersTokens.push(user.fcmToken);
            }

            let notification = {
                title: "New Event Invitation",
                body: `You have been invited to ${event.name} by ${event.creator}`
            };
            notifications.notify(notification, invitedUsersTokens);
        }

        let response = {
            message: "Event created successfully!",
            data: {
                eventId: event._id
            }
        };
        resp.json(response);
    }
    catch (e) {
        logger.error(e);
        return resp.status(500).send("Failed to create event");
    }
};

// update an event if user is creator
let updateEvent = async function(req, resp) {
    try {
        const userId = req.authorization.id;

        const newEvent = req.body.event;
        if (!newEvent) {
            return resp.status(400).send("No updated event specified");
        }

        // validate input event
        let val = validator.event(
            newEvent.name,
            newEvent.description,
            Number(newEvent.latitude),
            Number(newEvent.longitude),
            Number(newEvent.startTime),
            Number(newEvent.endTime)
        );
        if (val.ok === false) {
            return resp.status(400).send(val.error);
        }

        let event = await Event.findById(newEvent._id);
        if (userId != event.creator) {
            return resp.status(403).send("Requesting user is not the event creator");
        }

        for (let property in newEvent) {
            event[property] = newEvent[property];
        }
        await event.save();

        resp.send(event);
    }
    catch (e) {
        logger.error(e);
        return resp.status(500).send("Error updating event");
    }
};

// invite people to an event
let invitePeople = async function(req, resp) {
    try {
        const eventId = req.body.eventId;
        if (!eventId) {
            return resp.status(400).send("No event id provided");
        }

        let invited = req.body.invited;
        if (!invited) {
            invited = [];
        }

        let event = await Event.findById(eventId);
        if (!event) {
            return resp.status(404).send("Event not found");
        }

        let users = await User.find({
            _id: { $in: invited }
        });
        for (let user of users) {
            event.invited.push(user._id);
            user.pendingInvites.push(event._id);
            await user.save();
        }

        await event.save();

        let userSettings = await UserSettings.find({
            _id: { $in: invited }
        });

        let invitedUsersTokens = [];
        for (let user of userSettings) {
            invitedUsersTokens.push(user.fcmToken);
        }

        let notification = {
            title: "New Event Invitation",
            body: `You have been invited to ${event.name} by ${event.creator}`
        };
        notifications.notify(notification, invitedUsersTokens);

        let response = {
            message: "Event updated with invited users",
            data: {
                eventId: event._id
            }
        };
        resp.json(response);
    }
    catch (e) {
        logger.error(e);
        return resp.status(500).send("Can't Invite Users to Event");
    }
};

// get all events within a given radius of given latitude
// and longitude, if event is marked as public
let findEvents = async function(req, res) {
    const userId = req.authorization.id;

    const longitude = req.query.longitude;
    const latitude = req.query.latitude;
    const radius = req.query.radius;
    const categories = req.query.categories;

    const lat = Number(latitude);
    const lon = Number(longitude);

    // validate inputs
    let val = validator.eventSearch(lat, lon, radius);
    if (val.ok === false) {
        return res.status(400).send(val.error);
    }

    let nearEventsQuery = {
        location: {
            $near: {
                $maxDistance: radius,
                $geometry: { type: "Point", coordinates: [longitude, latitude] }
            }
        },
        public: true
    };

    if (categories && categories.length != 0) {
        nearEventsQuery.categories = { $all: categories };
    }

    const userEventsQuery = {
        $or: [
            { creator: userId },
            { followers: userId },
            { invited: userId }
        ]
    };

    try {
        let user = await User.findById(userId);
        if (!user) {
            return res.status(404).send("Requesting user not found");
        }

        let nearEvents = await Event.find(nearEventsQuery)
            .gte("endTime", (Date.now() / 1000));
        let relevantEvents = getRelevantEventsForUser(nearEvents, user);

        let userEvents = await Event.find(userEventsQuery)
            .gte("endTime", (Date.now() / 1000));

        let events = userEvents.concat(relevantEvents);
        res.json(events);
    }
    catch (e) {
        logger.error(e);
        res.status(500).send("Could not retrieve events");
    }
};

let searchEvents = async function(req, res) {
    const userId = req.authorization.id;

    const eventName = req.query.eventName;
    const categories = req.query.categories;

    let query = {
        $and: [
            { name: { $regex: `${eventName}`, $options: "$i" } },
            {
                $or: [
                    { public: true },
                    { creator: userId },
                    { followers: userId },
                    { invited: userId }
                ]
            }
        ]
    };

    if (categories && categories.length != 0) {
        query.$and.push({
            categories: { $all: categories }
        });
    }

    try {
        let events = await Event.find(query)
            .gte("endTime", (Date.now() / 1000));
        res.json(events);
    }
    catch (e) {
        logger.error(e);
        res.status(500).send("Could not search for events");
    }
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

module.exports = {
    get: getEvent,
    create: createEvent,
    update: updateEvent,
    invite: invitePeople,
    find: findEvents,
    search: searchEvents
};
