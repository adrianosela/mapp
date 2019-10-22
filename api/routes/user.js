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

// TODO: Prevent duplicate follow, input validation
router.post('/user/follow', async function(req, res) {
    try {
        const userId = req.body.userId;
        const userToFollowId = req.body.userToFollowId;

        let userToFollow = await User.findById(userToFollowId);
        if (!userToFollow) {
            res.status(404).send('User to follow not found');
        }

        let user = await User.findById(userId);
        if (!user) {
            res.status(404).send('Requesting user not found');
        }

        user.following.push(userToFollowId);
        await User.findByIdAndUpdate(user._id, user, {
            useFindAndModify: false
        });

        userToFollow.followers.push(user._id);
        await User.findByIdAndUpdate(userToFollow._id, userToFollow, {
            useFindAndModify: false
        });

        res.send('Successfully followed requested user');
    }
    catch (error) {
        console.log(error);
        res.status(500).send('Could not follow user');
    }
});

module.exports = router;
