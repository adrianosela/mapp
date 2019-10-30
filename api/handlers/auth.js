const bcrypt = require("bcrypt");
const config = require("config");
const jwt = require("jsonwebtoken");
const emailValidator = require("email-validator");

// import User & UserSettings schemas
let User = require("../models/user");
let UserSettings = require("../models/userSettings");

let register = async function(req, resp) {
  // read request body
  const { email, password, name } = req.body;

  // validate inputs
  if (!email) {
    return resp.status(400).send("No email provided");
  }
  if (!password) {
    return resp.status(400).send("No password provided");
  }
  if (!name) {
    return resp.status(400).send("No preferred name provided");
  }
  if (!emailValidator.validate(email)) {
    return resp.status(400).send("Email provided is invalid");
  }

  // check email is not used
  UserSettings.findOne({ email: req.body.email }, function(err, user) {
    if (user) {
      return resp.status(400).send("User with that email already exists");
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
  } catch (e) {
    console.log(`[error] ${e}`);
    return resp.status(500).send("Could not save new user settings");
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
    console.log(`[error] ${e}`);
    return resp.status(500).send("Could not save new user");
  }

  // return saved user
  resp.json(savedUser);
};

// trade basic credentials for a signed JWT
let login = async function(req, resp) {
  // read request body
  const { email, password } = req.body;

  // check fields are set
  if (!email) {
    return resp.status(400).send("No email provided");
  }
  if (!password) {
    return resp.status(400).send("No password provided");
  }

  // fetch user from db
  let user;
  try {
    user = await UserSettings.findOne({ email: req.body.email });
    // note that we are returning a 401 - Unauthorized instead of
    // 404 - NotFound in order not expose whether a given email exists
    if (!user) {
      return resp.status(401).send("Unauthorized");
    }
  } catch (e) {
    console.log(`[error] ${e}`);
    return resp.status(500).send();
  }

  // check whether hashed password matches stored hash
  try {
    const match = await bcrypt.compare(req.body.password, user.hash);
    if (!match) {
      resp.status(401).send("Unauthorized");
      return;
    }
  } catch (e) {
    console.log(`[error] ${e}`);
    return resp.status(500).send();
  }

  // construct session token
  let token;
  try {
    token = await jwt.sign(
      { id: user._id, email: user.email },
      config.auth.signing_secret,
      { expiresIn: "24h" }
    );
  } catch (e) {
    console.log(`[error] ${e}`);
    return resp.status(401).send("Unauthorized");
  }

  resp.json({ token });
};

let whoami = async function(req, resp) {
  resp.json(req.authorization);
};

module.exports = { register, login, whoami };
