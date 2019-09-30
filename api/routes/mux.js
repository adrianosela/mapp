const router = require('express').Router();
const healthHandlers = require('./healthcheck');

router.use(healthHandlers);

module.exports = router;
