let validator = require("../validator/validator");

// Test Validate Existing User - user login validation
describe("Test Validate Existing User", function() {
    describe("Positive: Successful Validation", function() {
        it("should return ok = true with valid parameters", function() {
            const input = {
                email: "valid@gmail.com",
                password: "someverysecurepassword"
            };
            let valid = validator.existingUser(input.email, input.password);
            expect(valid.ok).toBe(true);
        });
    });
    describe("Negative: No Email", function() {
        it("should return an error when no email is provided", function() {
            const input = {
                password: "someverysecurepassword"
            };
            let valid = validator.existingUser(input.email, input.password);
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No email provided");
        });
    });
    describe("Negative: No Password", function() {
        it("should return an error when no password is provided", function() {
            const input = {
                email: "valid@gmail.com",
            };
            let valid = validator.existingUser(input.email, input.password);
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No password provided");
        });
    });
    describe("Negative: Invalid Email", function() {
        it("should return an error when the provided email is not valid", function() {
            const input = {
                email: "this is not a valid email",
                password: "someverysecurepassword"
            };
            let valid = validator.existingUser(input.email, input.password);
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Email provided is not a valid email");
        });
    });
});

// Test Validate New User - new user validation
describe("Test Validate New User", function() {
    describe("Positive: Successful Validation", function() {
        it("should return ok = true with valid parameters", function() {
            const input = {
                email: "valid@gmail.com",
                password: "someverysecurepassword",
                name: "johnappleseed"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            expect(valid.ok).toBe(true);
        });
    });
    describe("Negative: No Email", function() {
        it("should return an error when no email is provided", function() {
            const input = {
                password: "someverysecurepassword",
                name: "johnappleseed"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No email provided");
        });
    });
    describe("Negative: No Password", function() {
        it("should return an error when no password is provided", function() {
            const input = {
                email: "valid@gmail.com",
                name: "johnappleseed"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No password provided");
        });
    });
    describe("Negative: No Name", function() {
        it("should return an error when no name is provided", function() {
            const input = {
                email: "valid@gmail.com",
                password: "someverysecurepassword"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No preferred name provided");
        });
    });
    describe("Negative: Invalid Email", function() {
        it("should return an error when the provided email is not valid", function() {
            const input = {
                email: "this is not a valid email",
                password: "someverysecurepassword",
                name: "johnappleseed"
            };
            let valid = validator.newUser(input.email, input.password, input.name);
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Email provided is not a valid email");
        });
    });
});

// Test Validate Event - event validation
describe("Test Validate Event", function() {
    describe("Positive: Successful Validation", function() {
        it("should return ok = true with valid parameters", function() {
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
            expect(valid.ok).toBe(true);
        });
    });
    describe("Negative: No Name", function() {
        it("should return an error when no name is provided", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No event name provided");
        });
    });
    describe("Negative: No Description", function() {
        it("should return an error when no description is provided", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No event description provided");
        });
    });
    describe("Negative: No Latitude", function() {
        it("should return an error when no latitude is provided", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No latitude provided");
        });
    });
    describe("Negative: No Longitude", function() {
        it("should return an error when no longitude is provided", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No longitude provided");
        });
    });
    describe("Negative: Invalid Latitude", function() {
        it("should return an error when an invalid latitude is provided", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Invalid coordinates");
        });
    });
    describe("Negative: Invalid Longitude", function() {
        it("should return an error when an invalid longitude is provided", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Invalid coordinates");
        });
    });
    describe("Negative: No Start Time", function() {
        it("should return an error when no start time is provided", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No start time provided");
        });
    });
    describe("Negative: No End Time", function() {
        it("should return an error when no end time is provided", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No end time provided");
        });
    });
    describe("Negative: End Time Before Start Time", function() {
        it("should return an error when the end date is before the start date", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Event end time cannot be before start time");
        });
    });
    describe("Negative: End Time Before Now", function() {
        it("should return an error when the end date is before the current date", function() {
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
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Event end time cannot be before now");
        });
    });
});

// Test Validate Event Search - event search parameters validation
describe("Test Validate Event Search", function() {
    describe("Positive: Successful Validation", function() {
        it("should return ok = true with valid parameters", function() {
            const input = {
                latitude: 49.267941,
                longitude: -123.247360,
                radius: 25000, // 25km
            };
            let valid = validator.eventSearch(
                Number(input.latitude),
                Number(input.longitude),
                Number(input.radius)
            );
            expect(valid.ok).toBe(true);
        });
    });
    describe("Negative: No Latitude", function() {
        it("should return an error when no latitude is provided", function() {
            const input = {
                longitude: -123.247360,
                radius: 25000, // 25km
            };
            let valid = validator.eventSearch(
                Number(input.latitude),
                Number(input.longitude),
                Number(input.radius)
            );
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No latitude provided");
        });
    });
    describe("Negative: No Longitude", function() {
        it("should return an error when no longitude is provided", function() {
            const input = {
                latitude: 49.267941,
                radius: 25000, // 25km
            };
            let valid = validator.eventSearch(
                Number(input.latitude),
                Number(input.longitude),
                Number(input.radius)
            );
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No longitude provided");
        });
    });
    describe("Negative: No Radius", function() {
        it("should return an error when no radius is provided", function() {
            const input = {
                latitude: 49.267941,
                longitude: -123.247360,
            };
            let valid = validator.eventSearch(
                Number(input.latitude),
                Number(input.longitude),
                Number(input.radius)
            );
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("No radius provided");
        });
    });
    describe("Negative: Invalid Latitude", function() {
        it("should return an error when an invalid latitude is provided", function() {
            const input = {
                latitude: 300.267941,
                longitude: -123.247360,
                radius: 25000, // 25km
            };
            let valid = validator.eventSearch(
                Number(input.latitude),
                Number(input.longitude),
                Number(input.radius)
            );
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Invalid coordinates");
        });
    });
    describe("Negative: Invalid Longitude", function() {
        it("should return an error when an invalid longitude is provided", function() {
            const input = {
                latitude: 49.267941,
                longitude: -323.247360,
                radius: 25000, // 25km
            };
            let valid = validator.eventSearch(
                Number(input.latitude),
                Number(input.longitude),
                Number(input.radius)
            );
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Invalid coordinates");
        });
    });
    describe("Negative: Invalid Radius (negative)", function() {
        it("should return an error when an invalid radius is provided", function() {
            const input = {
                latitude: 49.267941,
                longitude: -123.247360,
                radius: -10000
            };
            let valid = validator.eventSearch(
                Number(input.latitude),
                Number(input.longitude),
                Number(input.radius)
            );
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Radius must be a non-negative integer");
        });
    });
    describe("Negative: Invalid Radius (too large)", function() {
        it("should return an error when an invalid radius is provided", function() {
            const input = {
                latitude: 49.267941,
                longitude: -123.247360,
                radius: 1000000
            };
            let valid = validator.eventSearch(
                Number(input.latitude),
                Number(input.longitude),
                Number(input.radius)
            );
            expect(valid.ok).toBe(false);
            expect(valid.error).toEqual("Radius cannot exceed 100,000m (100km)");
        });
    });
});
