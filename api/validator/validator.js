const emailValidator = require("email-validator");
const isValidCoordinates = require("is-valid-coordinates");

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

// validateEventMetadata validates an event's name and description
let validateEventMetadata = function(name, description) {
    if (!name) {
        return {ok: false, error: "No event name provided"};
    }
    if (!description) {
        return {ok: false, error: "No event description provided"};
    }
    return  {ok: true};
};

// validateCoordinates validates a pair of coordinates (latitude, longitude)
let validateCoordinates = function(lat, lon) {
    if (!lat) {
        return {ok: false, error: "No latitude provided"};
    }
    if (!lon) {
        return {ok: false, error: "No longitude provided"};
    }
    if (!isValidCoordinates(lon, lat)) {
        return {ok: false, error: "Invalid coordinates"};
    }
    return  {ok: true};
};

// validateTime validates the time interval set for an event
let validateTime = function(start, end) {
    if (!start) {
        return {ok: false, error: "No start time provided"};
    }
    if (!end) {
        return {ok: false, error: "No end time provided"};
    }
    if (end < start) {
        return {ok: false, error: "Event end time cannot be before start time"};
    }
    if (end < Math.floor(Date.now()/1000)) {
        return {ok: false, error: "Event end time cannot be before now"};
    }
    return  {ok: true};
};

// validateEventData validates the data regarding an event
let validateEventData = function(name, description, lat, lon, start, end) {
    let meta = validateEventMetadata(name, description);
    if (meta.ok === false) {
        return meta;
    }
    let coords = validateCoordinates(lat, lon);
    if (coords.ok === false) {
        return coords;
    }
    let time = validateTime(start, end);
    if (time.ok === false) {
        return time;
    }
    return {ok: true};
};

// validateEventSearch validates the data regarding an event search
let validateEventSearch = function(lat, lon, rad) {
    let coords = validateCoordinates(lat, lon);
    if (coords.ok === false) {
        return coords;
    }
    if (!rad) {
        return {ok: false, error: "No radius provided"};
    }
    if (rad < 0) {
        return {ok: false, error: "Radius must be a non-negative integer"};
    }
    if (rad > 100000) {
        return {ok: false, error: "Radius cannot exceed 100,000m (100km)"};
    }
    return {ok: true};
};

module.exports = {
    existingUser: validateExistingUserData,
    newUser: validateNewUserData,
    event: validateEventData,
    eventSearch: validateEventSearch
};
