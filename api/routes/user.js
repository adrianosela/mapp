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

// Decline user's event invitation
router.post("/user/declineInvite", middleware.verifyToken, userHandlers.decline);

// Get user subscribed events
router.get("/user/subscribed", middleware.verifyToken, userHandlers.subscribed);

// Get user created events
router.get("/user/created", middleware.verifyToken, userHandlers.created);

// follow a user (by user id)
router.post("/user/follow", middleware.verifyToken, userHandlers.follow);

// unfollow a user (by user id)
router.post("/user/unfollow", middleware.verifyToken, userHandlers.unfollow);

// Subscribe user (by user id) to events
router.post("/user/subscribe", middleware.verifyToken, userHandlers.subscribe);

// Unsubscribe user (by user id) to events
router.post("/user/unsubscribe", middleware.verifyToken, userHandlers.unsubscribe);

// get users by username regex
router.get("/user/search", middleware.verifyToken, userHandlers.search);

module.exports = router;
