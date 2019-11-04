const emailValidator = require("email-validator");

// validateExistingUserData validates an email, password pair
let validateExistingUserData = function(email, password) {
    if (!email) {
        return {ok: false, error: "No email provided"};
    }
    if (!emailValidator.validate(email)) {
        return {ok: false, error: "Email provided is not a valid email"};
    }
    if (!password) {
        return {ok: false, error: "No password provided"};
    }
    return  {ok: true};
};

// validateNewUserData validates an email, password, name tuple
let validateNewUserData = function(email, password, name) {
    let validation = validateExistingUserData(email, password);
    if (validation.ok === false) {
        return validation;
    }
    if (!name) {
        return {ok: false, error: "No preferred name provided"};
    }
    return  {ok: true};
};

module.exports = {
    existingUser: validateExistingUserData,
    newUser: validateNewUserData
};
