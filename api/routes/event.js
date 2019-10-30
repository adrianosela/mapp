const router = require('express').Router();
const eventHandlers = require('../handlers/event');
const middleware = require('../handlers/middleware');

// get an event (by id)
router.get('/event', middleware.verifyToken, eventHandlers.get);

// create an event
router.post('/event', middleware.verifyToken, eventHandlers.create);

// update an event
router.put('/event', middleware.verifyToken, eventHandlers.update);

// invite people to an event
router.post('/event/invite', middleware.verifyToken, eventHandlers.invite);

// get all public events within a given radius of user coordinates
// which satisfy conditions in the request
router.get('/event/search', middleware.verifyToken, eventHandlers.search);

module.exports = router;
