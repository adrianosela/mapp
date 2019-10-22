const router = require('express').Router();
const notifications = require('../notifications/notifications');
const middleware = require('./middleware');

// import Event and User schemas
let Event = require('../models/event');
let User = require('../models/user');

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

        // TODO: event validation method

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

// invite people to an event
router.post('/event/invite', middleware.verifyToken, async function(req, resp) {
    const invited = req.body.invited;

    // TODO: check nonempty

    let invitedUsers = []
    for(let userInfo of invited) {
        let query = {
            $or: [
                { email: userInfo },
                { name: userInfo }
            ]
        }

        let user = await User.findOne(query);

        if (user != null) {
            invitedUsers.push(user);
        }

        // TODO: Send notification to user
        // notificationsEngine.invited.push(user.id);
    }

    try {
        const filter = { _id: req.body.eventId };
        const update = { invited: invitedUsers };
        let updatedEvent = await Event.findOneAndUpdate(filter, update, {
            new: true,       // Flag for returning updated event
            useFindAndModify: false
        });

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

module.exports = router;
