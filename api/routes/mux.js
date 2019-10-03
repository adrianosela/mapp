const express = require('express');
const router = express.Router();

// parse received json bodies
router.use(express.json());

router.use(require('./auth'));
router.use(require('./event'));
router.use(require('./healthcheck'));

module.exports = router;
