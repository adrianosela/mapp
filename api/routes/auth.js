const router = require('express').Router();
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const config = require('config');

// import User & UserSettings schemas
let User = require('../models/user');
let UserSettings = require('../models/userSettings');

// register a new user into mapp
router.post('/register', async function(req, resp) {
    // check fields are set
    if (!req.body.email) { resp.status(400).send('no email provided'); return; }
    if (!req.body.password) { resp.status(400).send('no password provided'); return; }
    if (!req.body.name) { resp.status(400).send('no preffered name provided'); return; }

    // check email is not used
    UserSettings.findOne( {email: req.body.email}, function (err, user) {
        if (user) {
	    resp.status(400).send('user with that email already exists');
	    return;
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
        console.log(e);
        resp.status(500).send('could not save new user settings');
	return;
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
        console.log(e);
        resp.status(500).send('could not save new user');
	return;
    }

    // return saved user
    resp.json(savedUser);
});

// trade basic credentials for a signed JWT
router.post('/login', async function(req, resp) {
    // check fields are set
    if (!req.body.email) { resp.status(400).send('no email provided'); return; }
    if (!req.body.password) { resp.status(400).send('no password provided'); return; }

    // fetch user from db
    let user;
    try {
    	user = await UserSettings.findOne({email: req.body.email})
    	if (!user) {
    		resp.status(401).send("unauthorized");
		return;
    	}
    }
    catch (e) {
	console.log(e);
        resp.status(500).send();
	return;
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
	console.log(e);
	resp.status(500).send();
	return;
    }
    
    // construct session token
    let token;
    try {
        token = await jwt.sign({id: user._id}, config.auth.signing_secret, { expiresIn: '24h' });
    }
    catch (e) {
	console.trace(e);
	resp.status(401).send("unauthorized");
	return;
    }

    resp.json({token: token});
});

module.exports = router;
