const router = require('express').Router();

let Event = require('../models/event');

// FIXME: don't return all events, auth, etc...
router.get('/events', function(req, resp) {
  Event.find({}, function(err, events) {
    if (err) {
      console.log(err);
      resp.status(500, 'could not retrieve events');
    }
    resp.send(events);
  });
});

// FIXME: dont use hardcoded event, read from req
// write validation function for event schema
router.post('/event', function(req, resp) {
  var newEvent = new Event({
    location: {
      latitude: 'some lat',
      longitude: 'some lon'
    },
    date: Date.now(),
    creator: 'adriano',
    organizers: [ 'x', 'y', 'z' ],
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
