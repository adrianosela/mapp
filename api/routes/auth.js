const router = require('express').Router();
const authenticator = require('../auth/authenticator');

router.get('/login', function(req, resp) {
  resp.send(authenticator.getURL());
});

router.get('/googlecallback', async function (req, resp) {
  await authenticator.getGoogleUser(req.query.code).then((u) => {
    console.log(u);
    resp.end('authentication successful, return to mapp');
  }).catch((e) => {
    console.log(e);
    resp.status(401).send('failed to authenticate :(');
  });
});

module.exports = router;
