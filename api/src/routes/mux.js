var router = require('express').Router();
var healthHandlers = require('./healthcheck');

router.use(healthHandlers);

module.exports = router;
