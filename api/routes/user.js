const router = require("express").Router();
const userHandlers = require("../handlers/user");
const middleware = require("../handlers/middleware");

// get a user (by user id)
router.get("/user", userHandlers.get);

// get self
router.get("/user/me", middleware.verifyToken, userHandlers.me);

// get user followers (by user id)
router.get("/user/followers", middleware.verifyToken, userHandlers.followers);

// get user following (by user id)
router.get("/user/following", middleware.verifyToken, userHandlers.following);

// Get user pending event invitations
router.get("/user/pending", middleware.verifyToken, userHandlers.pending);

// Get user subscribed events
router.get("/user/subscribed", middleware.verifyToken, userHandlers.subscribed);

// follow a user (by user id)
router.post("/user/follow", middleware.verifyToken, userHandlers.follow);

// Subscribe user (by user id) to events
router.post("/user/subscribe", middleware.verifyToken, userHandlers.subscribe);

// get users by username regex
router.get("/user/search", userHandlers.search);

module.exports = router;
