const router = require('express').Router();

router.use(require('./auth'));
router.use(require('./event'));
router.use(require('./healthcheck'));

module.exports = router;
