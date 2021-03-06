const logger = require("tracer").console();
const validator = require("../validator/validator");
const eventHelpers = require("../utils/event");

// import Event, User, and Announcement schemas
let Event = require("../models/event");
let User = require("../models/user");
let Announcement = require("../models/announcement");

// retrieve all data on an event by id in query string
let getEvent = async function(req, res) {
    try {
        const userId = req.authorization.id;
        const eventId = req.query.id;

        // validate id
        let val = validator.mongoId(eventId);
        if (val.ok === false) {
            return res.status(400).send(val.error);
        }

        let event = await Event.findById(eventId);
        if (!event) {
            return res.status(404).send("Event not found");
        }

        if (!event.public) {
            if (event.creator != userId && !event.invited.includes(userId) && !event.followers.includes(userId)) {
                // Return 404 (Not Found) as user can't know about private event
                return res.status(404).send("Event not found");
            }
        }

        let eventObject = event.toJSON();
        if (event.creator == userId) {
            eventObject.relevance = "created";
        }
        else if (event.followers.includes(userId)) {
            eventObject.relevance = "subscribed";
        }
        else if (event.invited.includes(userId)) {
            eventObject.relevance = "invited";
        }
        else {
            eventObject.relevance = "public";
        }

        res.json(eventObject);
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Could not retrieve event");
    }
};

// create an event (from json request body)
let createEvent = async function(req, res) {
    try {
        // creator from token
        const creator = req.authorization.id;

        // event details from req body
        const name = req.body.name;
        const description = req.body.description;
        const latitude = req.body.latitude;
        const longitude = req.body.longitude;
        const startTime = req.body.startTime;
        const endTime = req.body.endTime;
        const _public = req.body.public;

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

        let categories = req.body.categories;
        if (!categories) {
            // avoid null array
            categories = [];
        }

        // validate inputs
        let val = validator.event(name, description, lat, lon, start, end);
        if (val.ok === false) {
            return res.status(400).send(val.error);
        }

        let event = await (new Event({
            name: name,
            description: description,
            location: { type: "Point", coordinates: [lon, lat] },
            startTime: start,
            endTime: end,
            creator: creator,
            public: _public,
            invited: invited,
            categories: categories
        })).save();

        let creatorUser = await User.findById(creator);
        creatorUser.createdEvents.addToSet(event._id);
        await creatorUser.save();

        // add = false, notify = true
        await eventHelpers.inviteUsers(event, invited, false, true);

        let response = {
            message: "Event created successfully!",
            data: {
                eventId: event._id
            }
        };
        res.json(response);
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Failed to create event");
    }
};

// update an event if user is creator
let updateEvent = async function(req, res) {
    try {
        const userId = req.authorization.id;

        const eventId = req.body.eventId;
        const newEvent = req.body.event;
        if (!newEvent || !eventId) {
            return res.status(400).send("No updated event specified");
        }

        // validate id
        let valid = validator.mongoId(eventId);
        if (valid.ok === false) {
            return res.status(400).send(val.error);
        }

        let latitude = Number(newEvent.latitude);
        let longitude = Number(newEvent.longitude);
        delete newEvent.latitude;
        delete newEvent.longitude;

        // validate input event
        let val = validator.event(
            newEvent.name,
            newEvent.description,
            latitude,
            longitude,
            Number(newEvent.startTime),
            Number(newEvent.endTime)
        );
        if (val.ok === false) {
            return res.status(400).send(val.error);
        }

        let event = await Event.findById(eventId);

        if (userId != event.creator) {
            return res.status(403).send("Requesting user is not the event creator");
        }

        newEvent.location = { type: "Point", coordinates: [longitude, latitude] };
        for (let property in newEvent) {
            event[property] = newEvent[property];
        }
        await event.save();
        res.json(event);
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Error updating event");
    }
};

let deleteEvent = async function(req, res) {
    const userId = req.authorization.id;

    const eventId = req.query.id;

    // validate id
    let val = validator.mongoId(eventId);
    if (val.ok === false) {
        return res.status(400).send(val.error);
    }

    try {
        let event = await Event.findById(eventId);
        if (!event) {
            return res.status(404).send("Event not found");
        }

        if (event.creator != userId) {
            return res.status(401).send("Requesting user can't delete event");
        }

        await Event.findByIdAndDelete(eventId);

        let response = {
            message: "Event deleted successfully!",
            data: {
                eventId: eventId
            }
        };
        res.json(response);
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Can't Delete Event");
    }
};

// Get Announcements for specific event
let getAnnouncementsForEvent = async function(req, res) {
    const userId = req.authorization.id;

    const eventId = req.query.id;

    // validate id
    let val = validator.mongoId(eventId);
    if (val.ok === false) {
        return res.status(400).send(val.error);
    }

    try {
        let event = await Event.findById(eventId);
        if (!event) {
            return res.status(404).send("Event not found");
        }

        if (!event.public) {
            if (event.creator != userId && !event.invited.includes(userId) && !event.followers.includes(userId)) {
                // Return 404 (Not Found) as user can't know about private event
                return res.status(404).send("Event not found");
            }
        }

        let announcements = await Announcement.findOne({
            eventId: eventId
        });
        return res.json(announcements);
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Cannot get announcements for event");
    }
};

// Create Event Announcement and notify subscribers
let createAnnouncement = async function(req, res) {
    const userId = req.authorization.id;

    const eventId = req.body.eventId;
    const message = req.body.message;
    // TODO: Move to Validator
    if (!eventId || !message) {
        return res.status(400).send("Event id and/or message not provided");
    }

    // validate id
    let val = validator.mongoId(eventId);
    if (val.ok === false) {
        return res.status(400).send(val.error);
    }

    try {
        let event = await Event.findById(eventId);
        if (!event) {
            return res.status(404).send("Event not found");
        }

        if (event.creator != userId) {
            return res.status(401).send("Requesting user can't create announcement to event");
        }

        let announcements = await Announcement.findOne({
            eventId: eventId
        });
        if (!announcements) {
            announcements = await (new Announcement({
                eventId: eventId
            }));
        }

        let msgObject = {
            message: message,
            timestamp: Math.floor((Date.now() / 1000))
        };
        announcements.messages.addToSet(msgObject);
        await announcements.save();

        await eventHelpers.notifyAnnouncements(event, userId);

        return res.send("Announcement created successfully");
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Can't create announcement");
    }
};

// Get Users that are attending an event
let getSubscribedToEvent = async function(req, res) {
    const userId = req.authorization.id;
    
    const eventId = req.query.id;
    if (!eventId) {
        return res.status(400).send("No event Id provided");
    }

    // validate id
    let val = validator.mongoId(eventId);
    if (val.ok === false) {
        return res.status(400).send(val.error);
    }

    try {
        let event = await Event.findById(eventId);
        if (!event) {
            return res.status(404).send("Event not found");
        }

        if (!event.public) {
            if (event.creator != userId && !event.invited.includes(userId) && !event.followers.includes(userId)) {
                // Return 404 (Not Found) as user can't know about private event
                return res.status(404).send("Event not found");
            }
        }

        let subscribedUsers = await User.find({
            _id: { $in: event.followers }
        });

        let response = [];
        for (let user of subscribedUsers) {
            let userObject = {
                id: user._id,
                name: user.name
            };
            response.push(userObject);
        }

        res.json(response);
    }
    catch (e) {
        logger.error(e);
        res.status(500).send("Could not retrieve event's subscribed users");
    }
};

// invite people to an event
let invitePeople = async function(req, res) {
    try {
        const eventId = req.body.eventId;

        // validate id
        let val = validator.mongoId(eventId);
        if (val.ok === false) {
            return res.status(400).send(val.error);
        }

        let invited = req.body.invited;

        let event = await Event.findById(eventId);
        if (!event) {
            return res.status(404).send("Event not found");
        }

        // add = true, notify = true
        await eventHelpers.inviteUsers(event, invited, true, (!req.body.mock || req.body.mock === false));
        let response = {
            message: "Event updated with invited users",
            data: {
                eventId: event._id
            }
        };

        res.json(response);
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Can't Invite Users to Event");
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

        let relevantEvents = eventHelpers.relevantForUser(nearEvents, user);

        let userEvents = await Event.find(userEventsQuery)
            .gte("endTime", (Date.now() / 1000));

        let events = userEvents.concat(relevantEvents);

        let eventsObject = [];
        for (let event of events) {
            let eventObject = event.toJSON();
            if (event.creator == userId) {
                eventObject.relevance = "created";
            }
            else if (event.followers.includes(userId)) {
                eventObject.relevance = "subscribed";
            }
            else if (event.invited.includes(userId)) {
                eventObject.relevance = "invited";
            }
            else {
                eventObject.relevance = "public";
            }

            eventsObject.push(eventObject);
        }

        res.json(eventsObject);
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

module.exports = {
    get: getEvent,
    create: createEvent,
    update: updateEvent,
    delete: deleteEvent,
    getAnnouncements: getAnnouncementsForEvent,
    announcement: createAnnouncement,
    subscribed: getSubscribedToEvent,
    invite: invitePeople,
    find: findEvents,
    search: searchEvents
};
