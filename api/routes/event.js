const router = require('express').Router();

let Event = require('../models/event');

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
    if (!event) { resp.status(404, 'event not found'); }
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

  var newEvent = new Event({
    location: { type: 'Point', coordinates: [longitude, latitude] },
    date: Date.now(),
    duration: 1000,
    creator: 'some user', // TODO: get user id from authenticated token
    organizers: ['x', 'y', 'z'],
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
