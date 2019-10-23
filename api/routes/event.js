const router = require('express').Router();
const notifications = require('../notifications/notifications');
const middleware = require('./middleware');

// import Event and User schemas
let Event = require('../models/event');
let User = require('../models/user');
let UserSettings = require('../models/userSettings');

// retrieve all data on an event by id in query string
router.get('/event', middleware.verifyToken, async function(req, resp) {
    try {
        let event = await Event.findById(req.query.id);
        if (!event) {
            resp.status(404).send('Event not found');
        }

        resp.json(event);
    }
    catch (error) {
        console.log(error);
        resp.status(500).send('Could not retrieve event');
    }
});

// create an event (from json request body)
router.post('/event', middleware.verifyToken, async function(req, resp) {
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
            public,
            invited
        } = req.body;

        // enforce types
        const lat = Number(latitude);
        const lon = Number(longitude);
        const start = Number(startTime);
        const end = Number(endTime);

        if (!name) { return resp.status(400).send("no event name provided"); }
        if (!description) { return resp.status(400).send("no event description provided"); }
        if (!lat || !lon) { return resp.status(400).send("invalid coordinates"); }
        if (!start) { return resp.status(400).send("no start time provided"); }
        if (!end) { return resp.status(400).send("no end time provided"); }

        let newEvent = new Event({
            name: name,
            description: description,
            location: { type: 'Point', coordinates: [lon, lat] },
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

        let response = {
            message: 'Event created successfully!',
            data: {
                eventId: event._id
            }
        }
        resp.json(response);
    }
    catch (error) {
        console.log(error);
        resp.status(500).send('Failed to create event');
    }
});

// update an event if user is creator
router.put('/event', middleware.verifyToken, async function(req, resp) {

    try {
        let newEvent = req.body.event;

        let event = await Event.findByIdAndUpdate(newEvent._id, newEvent);

        resp.send(event);
    }
    catch (error) {
        console.log(error);
        resp.status(500).send("Error updating event");
    }
});

// invite people to an event
router.post('/event/invite', middleware.verifyToken, async function(req, resp) {
    const invited = req.body.invited;

    let userSettings = await UserSettings.find({
        '_id': { $in: invited }
    })
    // TODO: check nonempty
    let invitedUsersTokens = [];
    for(let user of userSettings) {
        invitedUsersTokens.push(user.fcmToken);
    }

    try {
        const filter = { _id: req.body.eventId };
        const update = { invited: invited };
        let updatedEvent = await Event.findOneAndUpdate(filter, update, {
            new: true,       // Flag for returning updated event
            useFindAndModify: false
        });

        let notification = {
            title: "New Event Invitation",
            body: `You have been invited to ${updatedEvent.eventName} by ${updatedEvent.creator}`
        }
        notifications.notify(notification, invitedUsersTokens);

        let response = {
            message: 'Event updated with invited users',
            data: {
                eventId: updatedEvent._id
            }
        }
        resp.json(response);
    }
    catch (error) {
        console.log(error);
        resp.status(500).send("Can't Invite Users to Event");
    }
});

// get all events within a given radius of given latitude
// and longitude, if event is marked as public
router.get('/event/search', function(req, resp) {
    const longitude = req.query.longitude;
    const latitude = req.query.latitude;
    const radius = req.query.radius;

    // TODO: validate latitude, longitude, and radius (enforce max - return 400)

    const query = {
        // TODO: include user-set filters
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
            console.log(err);
            resp.status(500).send('Could not retrieve events');
        }

        resp.send(events);
    });
});

module.exports = router;
