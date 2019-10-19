const router = require('express').Router();

let Event = require('../models/event');

/**
 * GET /findEvents - get all events within a given radius
 *                   of given latitude and longitude, if 
 *                   event is marked as public
 */
router.get('/findEvents', function(req, resp) {
    const longitude = req.query.longitude;
    const latitude = req.query.latitude;
    const radius = req.query.radius;
    // TODO: validate lat, lon, rad

    const query = {
    // TODO: filter events by user filters
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
            resp.status(500, 'Could not retrieve events');
        }

        resp.send(events);
    });
});

module.exports = router;
