const router = require('express').Router();
const userHandlers = require('../handlers/user');
const middleware = require('../handlers/middleware');

// get a user (by user id)
router.get('/user', userHandlers.get);

// get user followers (by user id)
router.get('/user/followers', middleware.verifyToken, userHandlers.followers);

// get user following (by user id)
router.get('/user/following', middleware.verifyToken, userHandlers.following);

// follow a user (by user id)
router.post('/user/follow', middleware.verifyToken, userHandlers.follow);

// get users by username regex
router.get('/user/search', userHandlers.search);

module.exports = router;
