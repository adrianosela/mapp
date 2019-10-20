const router = require('express').Router();
const bcrypt = require('bcrypt');

// import User & UserSettings schemas
let User = require('../models/user');
let UserSettings = require('../models/userSettings');

// register a new user into mapp
router.post('/register', async function(req, resp) {
    // check fields are set
    if (!req.body.email) { resp.status(400).send('no email provided'); }
    if (!req.body.password) { resp.status(400).send('no password provided'); }
    if (!req.body.name) { resp.status(400).send('no preffered name provided'); }

    // check email is not used
    UserSettings.findOne( {email: req.body.email}, function (err, user) {
	if (user) { resp.status(400).send('user with that email already exists'); }
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
    }

    // return saved user
    resp.json(savedUser);
});

module.exports = router;
