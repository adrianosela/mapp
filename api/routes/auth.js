const router = require('express').Router();
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const config = require('config');
const middleware = require('./middleware');

// import User & UserSettings schemas
let User = require('../models/user');
let UserSettings = require('../models/userSettings');

// email validation function
function emailIsValid(email) {
  let regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return regex.test(email);
}

// register a new user into mapp
router.post('/register', async function(req, resp) {
    // read request body
    const { email, password, name } = req.body;

    // validate inputs
    if (!email) { return resp.status(400).send('no email provided'); }
    if (!password) { return resp.status(400).send('no password provided'); }
    if (!name) { return resp.status(400).send('no preferred name provided'); }

    // check email is not used
    UserSettings.findOne( {email: req.body.email}, function (err, user) {
        if (user) {
            return resp.status(400).send('user with that email already exists');
        }
    });

    // hash password and store
    const hashed = await bcrypt.hash(req.body.password, 10);

    // populate new user settings schema
    let newUserSettings = new UserSettings({
        email: req.body.email,
        hash: hashed
    });

    // save new user settings
    let savedUserSettings;
    try {
        savedUserSettings = await newUserSettings.save();
    }
    catch (e) {
        console.log('[error] ' + e);
        return resp.status(500).send('could not save new user settings');
    }

    // populate new user schema
    let newUser = new User({
        _id: savedUserSettings._id, // same BSON id as user settings
        name: req.body.name
    });

    // save new user
    let savedUser;
    try {
        savedUser = await newUser.save();
    }
    catch (e) {
        console.log(`[error] ${e}`);
        return resp.status(500).send('could not save new user');
    }

    // return saved user
    resp.json(savedUser);
});

// trade basic credentials for a signed JWT
router.post('/login', async function(req, resp) {
    // read request body
    const { email, password } = req.body;

    // check fields are set
    if (!email) { return resp.status(400).send('no email provided'); }
    if (!password) { return resp.status(400).send('no password provided'); }

    // fetch user from db
    let user;
    try {
        user = await UserSettings.findOne({email: req.body.email})
        // note that we are returning a 401 - Unauthorized instead of
        // 404 - NotFound in order not expose whether a given email exists
        if (!user) { return resp.status(401).send("unauthorized"); }
    }
    catch (e) {
        console.log(`[error] ${e}`);
        return resp.status(500).send();
    }

    // check whether hashed password matches stored hash
    try {
        const match = await bcrypt.compare(req.body.password, user.hash);
        if (!match) {
            resp.status(401).send("unauthorized");
            return;
        }
    }
    catch (e) {
        console.log(`[error] ${e}`);
        return resp.status(500).send();
    }

    // construct session token
    let token;
    try {
        token = await jwt.sign({id: user._id, email:user.email}, config.auth.signing_secret, { expiresIn: '24h' });
    }
    catch (e) {
        console.log(`[error] ${e}`);
        return resp.status(401).send("unauthorized");
    }

    resp.json({token: token});
});

router.get('/whoami', middleware.verifyToken, async function(req, resp) {
    resp.json(req.authorization);
});

module.exports = router;
