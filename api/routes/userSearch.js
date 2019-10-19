const router = require('express').Router();

let User = require('../models/user');

router.get('/searchUsers', function(req, resp) {
    const userName = req.query.userName;

    const query = {
        name: { $regex: "^" + userName }
    };

    User.find(query, function(err, users) {
        if (err) {
            console.log(err);
            resp.status(500, 'Could not retrieve users');
        }

        resp.send(users);
    });
});

module.exports = router;
