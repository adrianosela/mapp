const router = require('express').Router();
const notificationsEngine = require('../notifications/notificationsEngine');

let Event = require('../models/event');
let User = require('../models/user');

/**
 * GET /event - retrieve all data on an event by id.
 *               there should be an 'id' query param
 */
router.get('/event', function(req, resp) {
    Event.findById(req.query.id, function(err, event) {
        if (err) {
            console.log(err);
            resp.status(500, 'could not retrieve event');
        }
        if (!event) { 
            resp.status(404, 'event not found'); 
        }

        resp.json(event);
    });
});

/**
 * POST /event - create an event (from json request body)
 */
router.post('/event', function(req, resp) {
    const name = req.body.name;
    const description = req.body.description;
    const creator = req.token.sub;
    const latitude = Number(req.body.latitude);
    const longitude = Number(req.body.longitude);
    const eventDate = Number(req.body.eventDate);
    const eventDuration = Number(req.body.eventDuration);
    const public = req.body.public;
    const invited = req.body.invited;
    // TODO: input validation

    let newEvent = new Event({
        name: name,
        description: description,
        location: { type: 'Point', coordinates: [longitude, latitude] },
        date: eventDate,
        duration: eventDuration,
        creator: creator, // TODO: get user id from authenticated token
        public: public,
        invited: invited
    });

    newEvent.save(function(err, event) {
        if (err) {
            console.log(err);
            resp.status(500).send('Failed to create event');
        }

        let response = {
            message: 'Event created successfully!',
            data: {
                eventId: event._id
            }
        }

        resp.json(response);
    });
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
        invitedUsers.push(user);
        // TODO: Send notification to user
        // notificationsEngine.invited.push(user.id);
    }

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
});

// TODO: Add PUT for updating event

module.exports = router;
