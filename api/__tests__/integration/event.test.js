const mongoose = require("mongoose");
const supertest = require("supertest");
const notifications = require("../../notifications/notifications");
const app = require("../../server");
const Event = require("../../models/event");
const request = supertest(app);

const DAY_IN_SEC = 86400;
const TODAY_IN_EPOCH = Math.floor(Date.now() / 1000);
const LONGITUDE = -123.249572;
const LATITUDE = 49.261718;
const RADIUS_IN_M = 1000;

const dummyUsersInfo = [{
    email: "dummyUser1@gmail.com",
    password: "dummy1",
    name: "Test Dummy 1"
}, {
    email: "dummyUser2@gmail.com",
    password: "dummy2",
    name: "Test Dummy 2"
}];

var dummyUsers = [];

var dummyEvents = [{
    name: "Dummy Event 1",
    description: "Test Event 1",
    location: {
        type: "Point",
        coordinates: [LONGITUDE, LATITUDE]
    },
    startTime: TODAY_IN_EPOCH,
    endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
    creator: null,
    invited: [],
    categories: [],
    public: true,
}, {
    name: "Dummy Event 2",
    description: "Test Event 2",
    location: {
        type: "Point",
        coordinates: [LONGITUDE, LATITUDE]
    },
    startTime: TODAY_IN_EPOCH,
    endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
    creator: null,
    invited: [],
    categories: [],
    public: false,
}];

describe("Test Event Handlers", function() {

    beforeAll(async function() {
        await mongoose.connect(process.env.MONGO_URL, { 
            useNewUrlParser: true,
            useUnifiedTopology: true 
        });

        // Dont Notify in Testing Mode
        notifications.initialize(null, false);
        
        await registerDummyUsers();
        await createDummyEvents(dummyUsers[0]._id);
    });

    afterAll(async function() {
        const collections = Object.keys(mongoose.connection.collections);
        for (const collectionName of collections) {
            const collection = mongoose.connection.collections[collectionName];
            await collection.deleteMany();
        }

        await mongoose.connection.close();
    });

    describe("Positive: User Create Event", function() {
        it("Should create a new event", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const reqBody = {
                name: "Test Event 1",
                description: "Testing Events from dummy user 1",
                latitude: LATITUDE,
                longitude: LONGITUDE,
                startTime: TODAY_IN_EPOCH,
                endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                public: true
            };
            const res = await request.post("/event")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(200);

            const testEvent = await Event.findOne({name: "Test Event 1"});
            expect(testEvent._id.toString()).toEqual(res.body.data.eventId);
            expect(testEvent.name).toEqual(reqBody.name);
        });
    });

    describe("Negative: User Create Event with Missing Fields", function() {
        it("Should return 400 (Bad Request) with missing fields", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const reqBody = {
                name: "Test Event 2",
                description: "Testing Events from dummy user 1",
                latitude: LATITUDE,
                longitude: LONGITUDE,
                public: true
            };
            const res = await request.post("/event")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(400);
        });
    });

    describe("Positive: Get Event", function() {
        it("Should get event based on id", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                id: dummyEvents[0]._id.toString()
            };
            const res = await request.get("/event")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(200);
            expect(JSON.parse(JSON.stringify(res.body))).toMatchObject(JSON.parse(JSON.stringify(dummyEvents[0])));
        });
    });

    describe("Negative: Get Event with Incorrect Id", function() {
        it("Should return 404 (not found) with non-existent event id", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                id: mongoose.Types.ObjectId().toString()
            };
            const res = await request.get("/event")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(404);
        });
    });

    describe("Positive: Update Event", function() {
        it("Should update existing event", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const updatedEvent = {
                _id: dummyEvents[1]._id,
                name: dummyEvents[1].name,
                description: "Updating Dummy Event 2 from dummy user 1",
                latitude: LATITUDE,
                longitude: LONGITUDE,
                startTime: dummyEvents[1].startTime,
                endTime: dummyEvents[1].endTime,
                public: dummyEvents[1].public
            };

            const reqBody = {
                "event": updatedEvent
            };
            const res = await request.put("/event")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(200);

            const dummyEvent = await Event.findOne({name: dummyEvents[1].name});
            expect(dummyEvent._id.toString()).toEqual(updatedEvent._id.toString());
            expect(dummyEvent.description).toEqual(updatedEvent.description);
        });
    });

    describe("Negative: Update Event with Unauthorized User", function() {
        it("Should return 403 (forbidden) if updating user is not event creator", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const updatedEvent = {
                _id: dummyEvents[1]._id,
                name: dummyEvents[1].name,
                description: "Updating Dummy Event from dummy user 1",
                latitude: LATITUDE,
                longitude: LONGITUDE,
                startTime: dummyEvents[1].startTime,
                endTime: dummyEvents[1].endTime,
                public: dummyEvents[1].public
            };

            const reqBody = {
                "event": updatedEvent
            };
            const res = await request.put("/event")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(403);
        });
    });

    describe("Positive: Find Nearby Events", function() {
        it("Should return events nearby to user's location (two)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const query = {
                latitude: LATITUDE,
                longitude: LONGITUDE,
                radius: RADIUS_IN_M
            };
            const res = await request.get("/event/find")
                .set("Authorization", `Bearer ${userToken}`) 
                .query(query); 

            expect(res.status).toBe(200);
            expect(res.body.length).toBe(2);
        });

        it("Should return events nearby to user's location (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const query = {
                latitude: 49.243250,
                longitude: -122.974190,
                radius: RADIUS_IN_M
            };
            const res = await request.get("/event/find")
                .set("Authorization", `Bearer ${userToken}`) 
                .query(query); 

            expect(res.status).toBe(200);
            expect(JSON.stringify(res.body)).toEqual(JSON.stringify([]));
        });
    });

    describe("Negative: Find Nearby Events", function() {
        it("Should return 400 (Bad Request) with missing fields", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const query = {
                latitude: LATITUDE,
                longitude: LONGITUDE
            };
            const res = await request.get("/event/find")
                .set("Authorization", `Bearer ${userToken}`) 
                .query(query); 

            expect(res.status).toBe(400);
        });
    });

    describe("Positive: Invite Users", function() {
        it("Should invite user to event", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const reqBody = {
                eventId: dummyEvents[0]._id.toString(),
                invited: [dummyUsers[1]._id.toString()]
            };
            const res = await request.post("/event/invite")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);
            
            expect(res.status).toBe(200);

            const testEvent = await Event.findOne({name: dummyEvents[0].name});
            expect(testEvent._id.toString()).toEqual(res.body.data.eventId);
            expect(JSON.parse(JSON.stringify(testEvent.invited))).toContain(dummyUsers[1]._id);
        });
    });

    describe("Negative: Invite Users with Incorrect Id", function() {
        it("Should return 404 (not found) with non-existent event id", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const reqBody = {
                eventId: mongoose.Types.ObjectId().toString(),
                invited: [dummyUsers[1]._id.toString()]
            };
            const res = await request.post("/event/invite")
                .set("Authorization", `Bearer ${userToken}`)
                .send(reqBody);

            expect(res.status).toBe(404);
        });
    });

    describe("Positive: Search Events", function() {
        it("Should return events based on event name (two)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const query = {
                eventName: "Event"
            };
            const res = await request.get("/event/search")
                .set("Authorization", `Bearer ${userToken}`) 
                .query(query); 

            expect(res.status).toBe(200);
            expect(res.body.length).toBe(2);
        });

        it("Should return events based on event name (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const query = {
                eventName: "Incorrect Name"
            };
            const res = await request.get("/event/search")
                .set("Authorization", `Bearer ${userToken}`) 
                .query(query); 

            expect(res.status).toBe(200);
            expect(JSON.stringify(res.body)).toEqual(JSON.stringify([]));
        });
    });

    describe("Negative: Delete Event with Unauthorized User", function() {
        it("Should return 401 (unauthorized) if deleting user is not event creator", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const query = {
                id: dummyEvents[1]._id.toString()
            };
            const res = await request.delete("/event")
                .set("Authorization", `Bearer ${userToken}`) 
                .query(query);

            expect(res.status).toBe(401);
        });
    });

    describe("Positive: Delete Event", function() {
        it("Should delete existing event", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                id: dummyEvents[1]._id.toString()
            };
            const res = await request.delete("/event")
                .set("Authorization", `Bearer ${userToken}`) 
                .query(query);

            expect(res.status).toBe(200);

            let deletedEvent = await Event.findOne({name: dummyEvents[1].name});
            expect(deletedEvent).toEqual(null);
            expect(dummyEvents[1]._id.toString()).toEqual(res.body.data.eventId);
        });
    });

    describe("Negative: Delete Event with Non-existent Event", function() {
        it("Should return 404 (not found) if event does not exist", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                id: mongoose.Types.ObjectId().toString()
            };
            const res = await request.delete("/event")
                .set("Authorization", `Bearer ${userToken}`) 
                .query(query);

            expect(res.status).toBe(404);
        });
    });
});

var registerDummyUsers = async function() {
    let generatedUsers = [];
    for (let dummyUser of dummyUsersInfo) {
        let res = await request.post("/register").send(dummyUser);
        generatedUsers.push(res.body);
    }
    
    dummyUsers = generatedUsers;
};

var loginDummyUser = async function(dummyUserInfo) {
    let res = await request.post("/login").send(dummyUserInfo);
    
    return res.body.token;
};

var createDummyEvents = async function(creatorId) {
    let generatedEvents = [];
    for (let dummyEvent of dummyEvents) {
        dummyEvent.creator = mongoose.Types.ObjectId(creatorId);
        dummyEvent = new Event(dummyEvent);
        generatedEvents.push(await dummyEvent.save());
    }

    dummyEvents = generatedEvents;
};
