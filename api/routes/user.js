const router = require('express').Router();

// import User & UserSettings schemas
let User = require('../models/user');
let UserSettings = require('../models/userSettings');

// register a new user into mapp
router.post('/register', async function(req, resp) {
    // check fields are set
    if (!req.body.email) { resp.status(400, 'no email provided'); }
    if (!req.body.password) { resp.status(400, 'no password provided'); }
    if (!req.body.name) { resp.status(400, 'no preffered name provided'); }

    // check email is unused
    let user = await UserSettings.find({ email: req.body.email });
    if (user) { resp.status(400, 'user with that email exists'); }

    // populate new user settings schema
    let newUserSettings = new UserSettings({
	email: req.body.email,
	hash: hashed
    });

    // save new user settings
    let savedUserSettings;
    try {
	savedUserSettings = await newUserSettings.save();
    } catch (e) {
	console.log(e);
	resp.status(500, 'could not save new user settings');
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
    } catch (e) {
	console.log(e);
	resp.status(500, 'could not save new user');
    }

    // return saved user
    resp.json(savedUser);
});

// trade basic credentials for a signed JWT
router.get('/login'

module.exports = router;
