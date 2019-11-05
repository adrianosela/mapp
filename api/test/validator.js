var mocha = require("mocha");
var assert = require("assert");
var validator = require("../validator/validator");

// Test Validate Existing User - user login validation
mocha.describe("Test Validate Existing User", function() {
    mocha.describe("Positive: Successful Validation", function() {
        mocha.it("should return ok = true with valid parameters", function() {
            const input = {
                email: "valid@gmail.com",
                password: "someverysecurepassword"
            };
            let valid = validator.existingUser(input.email, input.password);
            assert.equal(valid.ok, true);
        });
    });
    mocha.describe("Negative: No Email", function() {
        mocha.it("should return an error when no email is provided", function() {
            const input = {
                password: "someverysecurepassword"
            };
            let valid = validator.existingUser(input.email, input.password);
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No email provided");
        });
    });
    mocha.describe("Negative: No Password", function() {
        mocha.it("should return an error when no password is provided", function() {
            const input = {
                email: "valid@gmail.com",
            };
            let valid = validator.existingUser(input.email, input.password);
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No password provided");
        });
    });
    mocha.describe("Negative: Invalid Email", function() {
        mocha.it("should return an error when the provided email is not valid", function() {
            const input = {
                email: "this is not a valid email",
                password: "someverysecurepassword"
            };
            let valid = validator.existingUser(input.email, input.password);
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "Email provided is not a valid email");
        });
    });
});

// Test Validate New User - new user validation
mocha.describe("Test Validate New User", function() {
    mocha.describe("Positive: Successful Validation", function() {
        mocha.it("should return ok = true with valid parameters", function() {
            const input = {
                email: "valid@gmail.com",
                password: "someverysecurepassword",
                name: "johnappleseed"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            assert.equal(valid.ok, true);
        });
    });
    mocha.describe("Negative: No Email", function() {
        mocha.it("should return an error when no email is provided", function() {
            const input = {
                password: "someverysecurepassword",
                name: "johnappleseed"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No email provided");
        });
    });
    mocha.describe("Negative: No Password", function() {
        mocha.it("should return an error when no password is provided", function() {
            const input = {
                email: "valid@gmail.com",
                name: "johnappleseed"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No password provided");
        });
    });
    mocha.describe("Negative: No Name", function() {
        mocha.it("should return an error when no name is provided", function() {
            const input = {
                email: "valid@gmail.com",
                password: "someverysecurepassword"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No preferred name provided");
        });
    });
    mocha.describe("Negative: Invalid Email", function() {
        mocha.it("should return an error when the provided email is not valid", function() {
            const input = {
                email: "this is not a valid email",
                password: "someverysecurepassword",
                name: "johnappleseed"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "Email provided is not a valid email");
        });
    });
});

// Test Validate Event - event validation
mocha.describe("Test Validate Event", function() {
    mocha.describe("Positive: Successful Validation", function() {
        mocha.it("should return ok = true with valid parameters", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                latitude: 49.267941,
                longitude: -123.247360,
                startTime: 4573927175,
                endTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, true);
        });
    });
    mocha.describe("Negative: No Name", function() {
        mocha.it("should return an error when no name is provided", function() {
            const input = {
                description: "Open to all! BYOB",
                latitude: 49.267941,
                longitude: -123.247360,
                startTime: 4573927175,
                endTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No event name provided");
        });
    });
    mocha.describe("Negative: No Description", function() {
        mocha.it("should return an error when no description is provided", function() {
            const input = {
                name: "John's Birthday Celebration",
                latitude: 49.267941,
                longitude: -123.247360,
                startTime: 4573927175,
                endTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No event description provided");
        });
    });
    mocha.describe("Negative: No latitude", function() {
        mocha.it("should return an error when no latitude is provided", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                longitude: -123.247360,
                startTime: 4573927175,
                endTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No latitude provided");
        });
    });
    mocha.describe("Negative: No Longitude", function() {
        mocha.it("should return an error when no longitude is provided", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                latitude: 49.267941,
                startTime: 4573927175,
                endTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No longitude provided");
        });
    });
    mocha.describe("Negative: Invalid Latitude", function() {
        mocha.it("should return an error when an invalid latitude is provided", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                latitude: 300.267941,
                longitude: -123.247360,
                startTime: 4573927175,
                endTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "Invalid coordinates");
        });
    });
    mocha.describe("Negative: Invalid Longitude", function() {
        mocha.it("should return an error when an invalid longitude is provided", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                latitude: 49.267941,
                longitude: -323.247360,
                startTime: 4573927175,
                endTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "Invalid coordinates");
        });
    });
    mocha.describe("Negative: No Start Time", function() {
        mocha.it("should return an error when no start time is provided", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                latitude: 49.267941,
                longitude: -129.247360,
                endTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No start time provided");
        });
    });
    mocha.describe("Negative: No End Time", function() {
        mocha.it("should return an error when no end time is provided", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                latitude: 49.267941,
                longitude: -129.247360,
                startTime: 9573927176
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "No end time provided");
        });
    });
    mocha.describe("Negative: End Time Before Start Time", function() {
        mocha.it("should return an error when the end date is before the start date", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                latitude: 49.267941,
                longitude: -123.247360,
                startTime: 9573927176,
                endTime: 9573927030
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "Event end time cannot be before start time");
        });
    });
    mocha.describe("Negative: End Time Before Now", function() {
        mocha.it("should return an error when the end date is before the current date", function() {
            const input = {
                name: "John's Birthday Celebration",
                description: "Open to all! BYOB",
                latitude: 49.267941,
                longitude: -123.247360,
                startTime: 1572928473,
                endTime: 1572928573
            };
            let valid = validator.event(
                input.name,
                input.description,
                Number(input.latitude),
                Number(input.longitude),
                Number(input.startTime),
                Number(input.endTime)
            );
            assert.equal(valid.ok, false);
            assert.equal(valid.error, "Event end time cannot be before now");
        });
    });
});
