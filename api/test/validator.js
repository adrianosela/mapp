var mocha = require("mocha");
var assert = require("assert");
var validator = require("../validator/validator");

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
