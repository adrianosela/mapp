const router = require('express').Router();

// import Event schema
let Event = require('../models/event');

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
