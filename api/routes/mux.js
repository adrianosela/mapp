const express = require('express');
const router = express.Router();

// parse received json bodies
router.use(express.json());

router.use(require('./healthcheck'));
router.use(require('./auth'));
router.use(require('./event'));
router.use(require('./eventSearch'));
router.use(require('./user'));
router.use(require('./userSearch'));

module.exports = router;
