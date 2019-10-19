const router = require('express').Router();
const notificationsEngine = require('../notifications/notificationsEngine');

let Event = require('../models/event');
let User = require('../models/user');

/**
 * GET /events - get all events within a given radius
 *               of given latitude and longitude
 */
router.get('/events', function(req, resp) {
  const longitude = req.query.longitude;
  const latitude = req.query.latitude;
  const radius = req.query.radius;
  // TODO: validate lat, lon, rad

  const query = {
  // TODO: filter events not-visible to user
  // TODO: filter events by user filters
    location: {
      $near: {
        $maxDistance: radius,
	    $geometry: { type: "Point", coordinates: [longitude, latitude] }
      }
    }
  };

  Event.find(query, function(err, events) {
    if (err) {
      console.log(err);
      resp.status(500, 'could not retrieve events');
    }
    resp.send(events);
  });
});

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
    const latitude = Number(req.body.latitude);
    const longitude = Number(req.body.longitude);
    // TODO: input validation

    let newEvent = new Event({
        name: name,
        location: { type: 'Point', coordinates: [longitude, latitude] },
        date: Date.now(),
        duration: 1000,
        creator: 'some user', // TODO: get user id from authenticated token
        organizers: ['x', 'y', 'z'],
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
    for(let userEmail of invited) {
        let query = {
            email: userEmail
        }

        let user = await User.findOne(query);
        invitedUsers.push(user);
        // TODO: Send notification to user
        // notificationsEngine.invited.push(user.id);
    }

    const filter = { _id: req.body.eventId };
    const update = { invited: invitedUsers };
    let updatedEvent = await Event.findOneAndUpdate(filter, update, {
        new: true
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
