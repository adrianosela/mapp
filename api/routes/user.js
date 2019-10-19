const router = require('express').Router();

let User = require('../models/user');

router.get('/user', function(req, resp) {
    User.findById(req.query.id, function(err, user) {
        if (err) {
            console.log(err);
            resp.status(500, `Could not retrieve User with ID: ${req.query.id}`);
        }

        if (!user) {
            resp.status(404, `User (${req.query.id}) not found`);
        }

        resp.json(user);
    });
});

router.post('/newUser', function(req, resp) {
  // TODO: Add user registration
});

module.exports = router;
