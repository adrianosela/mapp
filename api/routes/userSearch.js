const router = require('express').Router();

// import User schema
let User = require('../models/user');

// get users by username regex
router.get('/user/search', function(req, resp) {

    const userInfo = req.query.username;
    const query = {
        $or: [
            { name: { $regex: "^" + userInfo } },
            { email: { $regex: "^" + userInfo } }
        ]
    };

    User.find(query, function(err, users) {
        if (err) {
            console.log(err);
            resp.status(500).send('could not retrieve users');
        }
        resp.send(users);
    });

});

module.exports = router;
