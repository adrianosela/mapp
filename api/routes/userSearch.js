const router = require('express').Router();

let User = require('../models/user');

router.get('/searchUsers', function(req, resp) {
    const userInfo = req.query.userName;

    const query = {
        $or: [ 
            { name: { $regex: "^" + userInfo } },
            { email: { $regex: "^" + userInfo } }
        ]
    };

    User.find(query, function(err, users) {
        if (err) {
            console.log(err);
            resp.status(500).send('Could not retrieve users');
        }

        resp.send(users);
    });
});

module.exports = router;
