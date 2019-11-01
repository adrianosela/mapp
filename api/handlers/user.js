let User = require("../models/user");
let Event = require("../models/event");

let getUser = async function(req, res) {
    try {
        const userEmail = req.query.email;
        if (!userEmail) {
            return res.status(400).send("No email specified");
        }

        let user = await User.findOne({ email: userEmail });
        if (!user) {
            return res.status(404).send("User not found");
        }

        res.json(user);
    } 
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Could not retrieve user");
    }
};

let getSelf = async function(req, res) {
    try {
        let user = await User.findById(req.authorization.id);
        if (!user) {
            return res.status(404).send("User not found");
        }

        res.json(user);
    } 
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Could not retrieve user");
    }
};

let getFollowers = async function(req, res) {
    try {
        const userId = req.authorization.id;

        let user = await User.findById(userId);
        if (!user) {
            res.status(404).send("User not found");
        }

        let followers = User.find({
            _id: { $in: user.followers }
        });

        let response = [];
        for (let follower of followers) {
            let followerObject = {
                id: follower._id,
                name: follower.name
            };
            response.push(followerObject);
        }

        res.json(response);
    } 
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Could not retrieve user's followers");
    }
};

let getFollowing = async function(req, res) {
    try {
        const userId = req.authorization.id;

        let user = await User.findById(userId);
        if (!user) {
            res.status(404).send("User not found");
        }

        let following = User.find({
            _id: { $in: user.following }
        });

        let response = [];
        for (let followee of following) {
            let followeeObject = {
                id: followee._id,
                name: followee.name
            };
            response.push(followeeObject);
        }

        res.json(response);
    } 
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Could not retrieve user's following");
    }
};

let getPendingInvites = async function(req, res) {
    try {
        const userId = req.authorization.id;
        let user = await User.findById(userId);
        if (!user) {
            res.status(404).send("Requesting user not found");
        }

        let pendingEvents = await Event.find({
            _id: { $in: user.pendingInvites }
        });
        res.json(pendingEvents);
    }
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Could not retrieve user's pending invites");
    }
};

let getSubscribedEvents = async function(req, res) {
    try {
        const userId = req.authorization.id;
        let user = await User.findById(userId);
        if (!user) {
            res.status(404).send("Requesting user not found");
        }

        let subscribedEvents = await Event.find({
            _id: { $in: user.subscribedEvents }
        });

        let response = [];
        for (let event of subscribedEvents) {
            let eventObject = {
                id: event._id,
                name: event.name
            };
            response.push(eventObject);
        }

        res.json(response);
    }
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Could not retrieve user's subscribed events");
    }
};

let followUser = async function(req, res) {
    try {
        const userId = req.authorization.id;

        const userToFollowId = req.body.userToFollowId;
        if (!userToFollowId) {
            return res.status(400).send("No user to follow specified");
        }

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
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Could not follow user");
    }
};

let subscribeToEvents = async function(req, res) {
    const userId = req.authorization.id;

    const eventIds = req.body.eventIds;
    if (!eventIds || eventIds.length == 0) {
        return res.status(400).send("No events to subscribe to");
    }

    try {
        let user = await User.findById(userId);
        if (!user) {
            return res.status(404).send("Requesting user not found");
        }

        let events = await Event.find({
            _id: { $in: eventIds }
        });

        for (let event of events) {
            let eventIndex = user.pendingInvites.indexOf(event._id);
            user.pendingInvites.splice(eventIndex, eventIndex + 1);
            user.subscribedEvents.push(event._id);

            let userIndex = event.invited.indexOf(user._id);
            event.invited.splice(userIndex, userIndex + 1);
            event.followers.push(userId);
            await event.save();
        }

        await user.save(); 

        res.send(user.subscribedEvents);
    }
    catch (e) {
        console.log(`[error] ${e}`);
        res.status(500).send("Could not subscribe to events");
    }
};

// get users by username regex
let searchUsers = async function(req, res) {
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
            res.status(500).send("Could not retrieve users");
        }
        res.send(users);
    });
};

module.exports = {
    get: getUser,
    me: getSelf,
    followers: getFollowers,
    following: getFollowing,
    pending: getPendingInvites,
    subscribed: getSubscribedEvents,
    follow: followUser,
    subscribe: subscribeToEvents,
    search: searchUsers
};
