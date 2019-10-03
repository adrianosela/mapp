const router = require('express').Router();

let Event = require('../models/event');

/**
 * GET /events - get all events within a given radius
 *               of given latitude and longitude
 */
router.get('/events', function(req, resp) {
  const latitude = req.latitude;
  const longitude = req.longitude;
  const radius = req.radius;
  // TODO: input validation

  const query = {}; // TODO: create complex query
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
  // TODO: input validation 
  var newEvent = new Event({
    location: {
      latitude: req.latitude,
      longitude: req.longitude
    },
    date: new Date(req.unixdate*1000);,
    duration: req.duration,
    creator: req.creator, // TODO: get user id from authenticated token
    organizers: req.organizers,
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
