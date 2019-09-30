const router = require('express').Router();
const healthHandlers = require('./healthcheck');
const authHandlers = require('./auth');

router.use(healthHandlers);
router.use(authHandlers);

module.exports = router;
