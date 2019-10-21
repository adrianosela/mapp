const router = require('express').Router();

let User = require('../models/user');

router.get('/user', async function(req, res) {
    try {
        let user = await User.findById(req.query.id);
        if(!user) {
            res.status(404).send('User not found');
        }

        res.json(user);
    }
    catch (error) {
        console.log(error);
        res.status(500).send('Could not retrieve user');
    }
});

module.exports = router;
