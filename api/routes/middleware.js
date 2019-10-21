const jwt = require('jsonwebtoken');
const config = require('config');

let verifyToken = (req, res, next) => {
    let token = req.headers['x-access-token'] || req.headers['authorization'];
    if (!token) {
	res.status(401).send('no bearer token in hedaer');
	return;
    }

    if (token.startsWith('Bearer ')) {
        token = token.slice(7, token.length);
    }

    if (token) {
        jwt.verify(token, config.auth.signing_secret, (err, decoded) => {
            if (err) {
                return res.json({
                    success: false,
                    message: 'Token is not valid'
                });
            }
            else {
                req.authorization = decoded;
                next();
            }
        });
    } 
    else {
        return res.json({
            success: false,
            message: 'Auth token is not supplied'
        });
    }
};

module.exports = {
	verifyToken: verifyToken
};
