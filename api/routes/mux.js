const express = require('express');
const router = express.Router();

// parse received json bodies
router.use(express.json());

router.use(require('./auth')); // authentication & authorization
router.use(require('./push')); // push notifications
router.use(require('./user')); // users (people)
router.use(require('./event')); // events

// healthcheck endpoint
router.get('/healthcheck', function (req, res) {
  	res.send('Server is up and running!');
});

module.exports = router;
