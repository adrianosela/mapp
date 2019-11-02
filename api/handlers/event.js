const isValidCoordinates = require("is-valid-coordinates");
const notifications = require("../notifications/notifications");

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
        console.log(`[error] ${e}`);
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
        if (!name) {
            return resp.status(400).send("No event name provided");
        }
        if (!description) {
            return resp.status(400).send("No event description provided");
        }
        if (!lat || !lon) {
            return resp.status(400).send("No coordinates provided");
        }
        if (!start) {
            return resp.status(400).send("No start time provided");
        }
        if (!end) {
            return resp.status(400).send("No end time provided");
        }
        if (!isValidCoordinates(lon, lat)) {
            return resp.status(400).send("Invalid coordinates");
        }
        if (end < Math.floor(Date.now()/1000)) {
            return resp.status(400).send("Event end time cannot be before now");
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
        console.log(`[error] ${e}`);
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
        console.log(`[error] ${e}`);
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
        console.log(`[error] ${e}`);
        return resp.status(500).send("Can't Invite Users to Event");
    }
};

// get all events within a given radius of given latitude
// and longitude, if event is marked as public
let searchEvent = async function(req, resp) {
    const longitude = req.query.longitude;
    const latitude = req.query.latitude;
    const radius = req.query.radius;

    const lat = Number(latitude);
    const lon = Number(longitude);

    if (!lat || !lon) {
        return resp.status(400).send("No coordinates provided");
    }
    if (!isValidCoordinates(lon, lat)) {
        return resp.status(400).send("Invalid coordinates");
    }
    if (!radius) {
        return resp.status(400).send("No radius specified");
    }
    if (radius > 100000) {
        return resp.status(400).send("Radius cannot exceed 100,000m (100km)");
    }

    const query = {
        location: {
            $near: {
                $maxDistance: radius,
                $geometry: { type: "Point", coordinates: [longitude, latitude] }
            }
        },
        public: true
    };

    Event.find(query, function(err, events) {
        if (err) {
            console.log(`[error] ${err}`);
            return resp.status(500).send("Could not retrieve events");
        }
        resp.send(events);
    });
};

module.exports = {
    get: getEvent,
    create: createEvent,
    update: updateEvent,
    invite: invitePeople,
    search: searchEvent
};
