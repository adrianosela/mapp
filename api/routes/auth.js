const router = require('express').Router();
const authenticator = require('../auth/authenticator');

//router.get('/login', function(req, resp) {
//    resp.send(authenticator.getGoogleAuthUrl());
//});

router.get('/googlecallback', async function(req, resp) {
    await authenticator.getGoogleAuthTokens(req.query.code).then(async function(tokens){
  	    console.log(tokens);
  	    await authenticator.getGoogleUserProfile(tokens.access_token).then((profile) => {
  		    console.log(profile);
  		    resp.end('authentication successful, return to mapp');
  	    }).catch((e) => {
  		    console.log(e);
  		    resp.status(401).send('could not get user profile');
  	    });
    }).catch((e) => {
        console.log(e);
        resp.status(401).send('failed to authenticate :(');
    });
});

module.exports = router;
