const express = require('express');
const router = express.Router();

// parse received json bodies
router.use(express.json());

router.use(require('./auth'));
router.use(require('./user'));
router.use(require('./event'));

// healthcheck endpoint
router.get('/healthcheck', function (req, res) {
  	res.send('server is up and running!');
});

module.exports = router;
