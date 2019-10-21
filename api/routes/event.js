const router = require('express').Router();
const notificationsEngine = require('../notifications/notificationsEngine');

let Event = require('../models/event');
let User = require('../models/user');

/**
 * GET /event - retrieve all data on an event by id.
 *               there should be an 'id' query param
 */
router.get('/event', async function(req, resp) {
    try {
        let event = await Event.findById(req.query.id);

        if (!event) {
            resp.status(404, 'Event not found');
        }

        resp.json(event);
    }
    catch (error) {
        console.log(error);
        resp.status(500, 'Could not retrieve event');
    }
});

/**
 * POST /event - create an event (from json request body)
 */
router.post('/event', async function(req, resp) {
    try {
        const name = req.body.name;
        const description = req.body.description;
        // const creator = req.token.sub;
        const latitude = Number(req.body.latitude);
        const longitude = Number(req.body.longitude);
        const startTime = Number(req.body.startTime);
        const endTime = Number(req.body.endTime);
        const public = req.body.public;
        const invited = req.body.invited;
        // TODO: input validation

        let newEvent = new Event({
            name: name,
            description: description,
            location: { type: 'Point', coordinates: [longitude, latitude] },
            startTime: startTime,
            endTime: endTime,
            creator: "someone",     // TODO: Change it back to token
            public: public,
            invited: invited
        });

        let event = await newEvent.save();

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

router.post('/event/invite', async function(req, resp) {
    const invited = req.body.invited;

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
        resp.status(500, "Can't Invite Users to Event");
    }
});

// TODO: Add PUT for updating event

module.exports = router;
