const router = require('express').Router();
const pushHandlers = require('../handlers/push');
const middleware = require('../handlers/middleware');

// set an fcm token for authenticated user
router.post('/fcmToken', middleware.verifyToken, pushHandlers.post);

// test push notification token for a user
router.post('/push', middleware.verifyToken, pushHandlers.test);

module.exports = router;
