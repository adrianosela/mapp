const router = require('express').Router();

router.get('/healthcheck', function (req, res) {
  res.send('server is up and running!');
});

module.exports = router;
