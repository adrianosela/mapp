const mongoose = require("mongoose");
const supertest = require("supertest");
const { performance } = require("perf_hooks");
const notifications = require("../../notifications/notifications");
const app = require("../../server");
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

describe("Test Non-functional Requirements", function() {
    beforeAll(async function() {
        await mongoose.connect(process.env.MONGO_URL, { 
            useNewUrlParser: true,
            useUnifiedTopology: true 
        });

        // Dont Notify in Testing Mode
        notifications.initialize(null, false);
        
        await registerDummyUsers();
    });

    afterAll(async function() {
        const collections = Object.keys(mongoose.connection.collections);
        for (const collectionName of collections) {
            const collection = mongoose.connection.collections[collectionName];
            await collection.deleteMany();
        }

        await mongoose.connection.close();
    });

    describe("Event Privacy", function() {
        it("Should only disclose private events to authorized users", async function() {
            const userTokenA = await loginDummyUser(dummyUsersInfo[0]);
            const userTokenB = await loginDummyUser(dummyUsersInfo[1]);

            // User A creates new private event
            const newEvent = {
                name: "Dummy Event 1",
                description: "Test Event 1",
                latitude: LATITUDE,
                longitude: LONGITUDE,
                startTime: TODAY_IN_EPOCH,
                endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                invited: [],
                categories: [],
                public: false
            };
            let res = await createEvent(userTokenA, newEvent);
            expect(res.status).toBe(200);
            
            // User B tries to get private event
            const eventId = res.body.data.eventId;
            res = await getEvent(userTokenB, eventId);
            expect(res.status).toBe(404);

            // User A invites user B to private event
            const status = await inviteUserToEvent(userTokenA, eventId.toString(), dummyUsers[1]._id.toString());
            expect(status).toBe(200);

            // User B fetches private event (allowed since he is now invited)
            res = await getEvent(userTokenB, eventId);
            expect(res.status).toBe(200);
            expect(json(res.body._id)).toEqual(json(eventId));
        });
    });

    describe("Find Events Efficiency", function() {
        it("Should return newly created events within 3 secs", async function() {
            const userTokenA = await loginDummyUser(dummyUsersInfo[0]);
            const userTokenB = await loginDummyUser(dummyUsersInfo[1]);

            // User A creates new public event
            const newEvent = {
                name: "Dummy Event 2",
                description: "Test Event 2",
                latitude: LATITUDE,
                longitude: LONGITUDE,
                startTime: TODAY_IN_EPOCH,
                endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                invited: [],
                categories: [],
                public: true
            };
            let res = await createEvent(userTokenA, newEvent);
            expect(res.status).toBe(200);

            // Record staritng of Search Time as event is now created
            const t0 = performance.now();
            
            // User B retrieves nearby public events
            const eventId = res.body.data.eventId;
            res = await findEvents(userTokenB);

            // Record ending of Search Time
            const t1 = performance.now();
            expect(res.status).toBe(200);
            expect(json(res.body[1]._id)).toEqual(json(eventId));
            expect(t1-t0).toBeLessThanOrEqual(3000); // In milliseconds
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

var createEvent = async function(userToken, eventInfo) {
    const reqBody = eventInfo;
    const res = await request.post("/event")
        .set("Authorization", `Bearer ${userToken}`) 
        .send(reqBody);

    return res;
};

var getEvent = async function(userToken, eventId) {
    const query = {
        id: eventId
    };
    const res = await request.get("/event")
        .set("Authorization", `Bearer ${userToken}`) 
        .query(query);

    return res;
};

var inviteUserToEvent = async function(userToken, eventId, invitedUser) {
    const reqBody = {
        eventId: eventId,
        invited: [invitedUser]
    };
    const res = await request.post("/event/invite")
        .set("Authorization", `Bearer ${userToken}`) 
        .send(reqBody);

    return res.status;
};

var findEvents = async function(userToken) {
    const query = {
        latitude: LATITUDE,
        longitude: LONGITUDE,
        radius: RADIUS_IN_M
    };
    const res = await request.get("/event/find")
        .set("Authorization", `Bearer ${userToken}`) 
        .query(query);
    
    return res;
};

var json = function(object) {
    return JSON.parse(JSON.stringify(object));
};
