var mocha = require("mocha");
var assert = require("assert");

// TODO: write tests, below is an example
mocha.describe("Array", function() {
    mocha.describe("#indexOf()", function() {
        mocha.it("should return -1 when the value is not present", function() {
            assert.equal([1, 2, 3].indexOf(4), -1);
        });
    });
});
