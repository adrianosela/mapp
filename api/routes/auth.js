const router = require('express').Router();
const authHandlers = require('../handlers/auth');
const middleware = require('../handlers/middleware');

// register new email + password
router.post('/register', authHandlers.register);

// login with email + password (get auth token)
router.post('/login', authHandlers.login);

// verify validity of auth token
router.get('/whoami', middleware.verifyToken, authHandlers.whoami);

module.exports = router;
