const jwt = require("jsonwebtoken");
const config = require("config");

let verifyToken = (req, res, next) => {
    let token = req.headers["x-access-token"] || req.headers["authorization"];
    if (!token) {
        return res.status(401).send("No bearer token in header");
    }

    if (token.startsWith("Bearer ")) {
        token = token.slice(7, token.length);
    }

    if (token) {
        jwt.verify(token, config.auth.signing_secret, (err, decoded) => {
            if (err) {
                return res.status(401).send(`Invalid token: ${err}`);
            } 
            else {
                req.authorization = decoded;
                next();
            }
        });
    } 
    else {
        return res.status(401).send("No auth token in header");
    }
};

module.exports = { verifyToken };
