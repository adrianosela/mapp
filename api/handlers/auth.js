const bcrypt = require("bcrypt");
const config = require("config");
const jwt = require("jsonwebtoken");
const logger = require("tracer").console();
const validator = require("../validator/validator");

// import User & UserSettings schemas
let User = require("../models/user");
let UserSettings = require("../models/userSettings");

let register = async function(req, res) {
    // read request body
    const { email, password, name } = req.body;

    // validate inputs
    let validation = validator.newUser(email, password, name);
    if (validation.ok === false) {
        return res.status(400).send(validation.error);
    }

    try {
         // check email is not used
        let user = await UserSettings.findOne({ email: req.body.email });
        if (user) {
            return res.status(400).send("User with that email already exists");
        }

        const hashed = await bcrypt.hash(req.body.password, 10);

        let newUserSettings = new UserSettings({
            email: req.body.email,
            hash: hashed
        });
        await newUserSettings.save();

        let newUser = new User({
            _id: newUserSettings._id, // same BSON id as user settings
            name: req.body.name
        });
        await newUser.save();

        res.json(newUser);
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Could not register user");
    }
};

// trade basic credentials for a signed JWT
let login = async function(req, res) {
    // read request body
    const { email, password } = req.body;

    // validate inputs
    let validation = validator.existingUser(email, password);
    if (validation.ok === false) {
        return res.status(400).send(validation.error);
    }

    try {
        let user = await UserSettings.findOne({ email: req.body.email });
        // note that we are returning a 401 - Unauthorized instead of
        // 404 - NotFound in order not expose whether a given email exists
        if (!user) {
            return res.status(401).send("Unauthorized");
        }

        // check whether hashed password matches stored hash
        const match = await bcrypt.compare(req.body.password, user.hash);
        if (!match) {
            res.status(401).send("Unauthorized");
            return;
        }

        // construct session token
        let token = await jwt.sign(
            { id: user._id, email: user.email },
            config.auth.signing_secret,
            { expiresIn: "24h" }
        );

        res.json({ token });
    }
    catch (e) {
        logger.error(e);
        return res.status(500).send("Could not login user");
    }
};

let whoami = async function(req, resp) {
    resp.json(req.authorization);
};

module.exports = { register, login, whoami };
