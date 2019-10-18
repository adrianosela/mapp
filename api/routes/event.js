const router = require('express').Router();

let Event = require('../models/event');

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
    const public = req.body.public;
    // TODO: input validation

    var newEvent = new Event({
        location: { type: 'Point', coordinates: [longitude, latitude] },
        date: Date.now(),
        duration: 1000,
        creator: 'some user', // TODO: get user id from authenticated token
        public: public
    });

    newEvent.save(function(err) {
        if (err) {
            console.log(err);
            resp.status(500).send('failed to create event :(');
        }

        resp.send('event created successfully!');
    });
});

module.exports = router;
