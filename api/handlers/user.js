const router = require("express").Router();

let User = require("../models/user");

let getUser = async function(req, res) {
  try {
    const id = req.query.id;
    if (!id) {
      return res.status(404).send("no id specified");
    }

    let user = await User.findById(id);
    if (!user) {
      res.status(404).send("User not found");
    }

    res.json(user);
  } catch (e) {
    console.log(`[error] ${e}`);
    res.status(500).send("Could not retrieve user");
  }
};

let getSelf = async function(req, res) {
  try {
    let user = await User.findById(req.authorization.id);
    if (!user) {
      res.status(404).send("User not found");
    }
    res.json(user);
  } catch (e) {
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

    let response = [];
    for (let follower of user.followers) {
      let followerUser = await User.findById(follower);
      if (followerUser) {
        let followerObject = {
          id: followerUser._id,
          name: followerUser.name
        };
        response.push(followerObject);
      }
    }

    res.json(response);
  } catch (e) {
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

    let response = [];
    for (let followee of user.following) {
      let followeeUser = await User.findById(followee);
      if (followeeUser) {
        let followeeObject = {
          id: followeeUser._id,
          name: followeeUser.name
        };
        response.push(followeeObject);
      }
    }

    res.json(response);
  } catch (e) {
    console.log(`[error] ${e}`);
    res.status(500).send("Could not retrieve user's following");
  }
};

let followUser = async function(req, res) {
  try {
    const userId = req.authorization.id;
    const userToFollowId = req.body.userToFollowId;
    if (!userToFollowId) {
      return res.status(400).send("no user to follow specified");
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
  } catch (error) {
    console.log(error);
    res.status(500).send("Could not follow user");
  }
};

// get users by username regex
let searchUsers = async function(req, resp) {
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
      resp.status(500).send("Could not retrieve users");
    }
    resp.send(users);
  });
};

module.exports = {
  get: getUser,
  me: getSelf,
  followers: getFollowers,
  following: getFollowing,
  follow: followUser,
  search: searchUsers
};
