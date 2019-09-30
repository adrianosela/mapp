const router = require('express').Router();

// user registration endpoint.
// basic credentials (uname, pw) extracted from authorization header,
// the password is hashed and the user is stored if it does not exist.
router.get('/register', function (req, res) {
  if (!req.headers.authorization || req.headers.authorization.indexOf('Basic ') === -1) {
      return res.status(401).json({ message: 'no basic auth header found' });
  }
  const b64 = req.headers.authorization.split(' ')[1];
  const credentials = Buffer.from(b64, 'base64').toString('ascii');
  const [email, password] = credentials.split(':');
  // TODO: hash password
  // TODO: save user if does not exist

  res.send('you gave ' + email + ' and ' + password); // remove me
});

// user login endpoint.
// basic credentials (uname, pw) extracted from authorization header
// the password is hashed and credentials are compared to whats in db.
router.get('/login', function (req, res) {
  if (!req.headers.authorization || req.headers.authorization.indexOf('Basic ') === -1) {
      return res.status(401).json({ message: 'no basic auth header found' });
  }
  const b64 = req.headers.authorization.split(' ')[1];
  const credentials = Buffer.from(b64, 'base64').toString('ascii');
  const [email, password] = credentials.split(':');
  // TODO: hash password
  // TODO: find user in db

  res.send('you gave ' + email + ' and ' + password); // remove me
}

module.exports = router;
