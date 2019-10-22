const router = require('express').Router();
const middleware = require('./middleware');

let User = require('../models/user');

router.get('/user', async function(req, res) {
    try {
        let user = await User.findById(req.query.id);
        if(!user) {
            res.status(404).send("User not found");
        }

        res.json(user);
    }
    catch (error) {
        console.log(error);
        res.status(500).send("Could not retrieve user");
    }
});

router.get('/user/followers', middleware.verifyToken, async function(req, res) {
    try {
        const userId = req.authorization.id;

        let user = await User.findById(userId);
        if (!user) {
            res.status(404).send("User not found");
        }

        let response = [];
        for (let follower of user.followers) {
            let followerUser = await User.findById(follower);
            if (followerUser) {
                let followerObject = {
                    id: followerUser._id,
                    name: followerUser.name
                }
                response.push(followerObject);
            }
        }

        res.json(response);
    }
    catch (error) {
        console.log(error);
        res.status(500).send("Could not retrieve user's followers");
    }
});

router.get('/user/following', middleware.verifyToken, async function(req, res) {
    try {
        const userId = req.authorization.id;

        let user = await User.findById(userId);
        if (!user) {
            res.status(404).send("User not found");
        }

        let response = [];
        for (let followee of user.following) {
            let followeeUser = await User.findById(followee);
            if (followeeUser) {
                let followeeObject = {
                    id: followeeUser._id,
                    name: followeeUser.name
                }
                response.push(followeeObject);
            }
        }

        res.json(response);
    }
    catch (error) {
        console.log(error);
        res.status(500).send("Could not retrieve user's following");
    }
});

// TODO: Prevent duplicate follow, input validation
router.post('/user/follow', middleware.verifyToken, async function(req, res) {
    try {
        const userId = req.authorization.id;
        const userToFollowId = req.body.userToFollowId;

        let userToFollow = await User.findById(userToFollowId);
        if (!userToFollow) {
            res.status(404).send("User to follow not found");
        }

        let user = await User.findById(userId);
        if (!user) {
            res.status(404).send("Requesting user not found");
        }

        user.following.push(userToFollowId);
        await User.findByIdAndUpdate(user._id, user, {
            useFindAndModify: false
        });

        userToFollow.followers.push(user._id);
        await User.findByIdAndUpdate(userToFollow._id, userToFollow, {
            useFindAndModify: false
        });

        res.send("Successfully followed requested user");
    }
    catch (error) {
        console.log(error);
        res.status(500).send("Could not follow user");
    }
});

module.exports = router;
