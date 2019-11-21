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

describe("Test User Handlers", function() {
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

    describe("Positive: Get User", function() {
        it("Should retrieve a user based on user email", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                email: dummyUsersInfo[1].email
            };
            const res = await request.get("/user")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(200);
            expect(json(res.body)).toMatchObject(json(dummyUsers[1]));
        });
    });

    describe("Negative: Get User with Incorrect Parameters", function() {
        it("Should return 400 (Bad Request) with no email provided", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                email: ""
            };
            const res = await request.get("/user")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(400);
        });

        it("Should return 404 (Not Found) with non-existent email", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                email: "non-existent@gmail.com"
            };
            const res = await request.get("/user")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(404);
        });
    });

    describe("Positive: Get My User Info", function() {
        it("Should return requesting user object", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const res = await request.get("/user/me")
                .set("Authorization", `Bearer ${userToken}`);
            
            expect(res.status).toBe(200);
            expect(json(res.body)).toMatchObject(json(dummyUsers[0]));
        });
    });

    describe("Positive: Get User's Created Events", function() {
        it("Should return user's created events (two)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const res = await request.get("/user/created")
                .set("Authorization", `Bearer ${userToken}`);

            expect(res.status).toBe(200);
            expect(json(res.body)).toMatchObject(json(dummyUsers[0].createdEvents));
        });

        it("Should return user's created events (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const res = await request.get("/user/created")
                .set("Authorization", `Bearer ${userToken}`);

            expect(res.status).toBe(200);
            expect(json(res.body)).toMatchObject(json(dummyUsers[1].createdEvents));
        });
    });

    describe("Positive: Search Users", function() {
        it("Should return users that contain name (one, not myself)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                username: "Test Dummy"
            };
            const res = await request.get("/user/search")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(200);
            expect(json(res.body[0].id)).toEqual(json(dummyUsers[1]._id));
            expect(json(res.body[0].name)).toEqual(json(dummyUsers[1].name));
        });

        it("Should return users that match name (one)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                username: dummyUsers[1].name.toString()
            };
            const res = await request.get("/user/search")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(200);
            expect(json(res.body[0].id)).toEqual(json(dummyUsers[1]._id));
            expect(json(res.body[0].name)).toEqual(json(dummyUsers[1].name));
        });

        it("Should return users that contain name (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                username: "Non-existent User"
            };
            const res = await request.get("/user/search")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(200);
            expect(json(res.body)).toEqual([]);
        });

        it("Should return users that contain email (one, not myself)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                username: "dummyUser"
            };
            const res = await request.get("/user/search")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(200);
            expect(json(res.body[0].id)).toEqual(json(dummyUsers[1]._id));
            expect(json(res.body[0].name)).toEqual(json(dummyUsers[1].name));
        });

        it("Should return users that match email (one)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                username: dummyUsersInfo[1].email
            };
            const res = await request.get("/user/search")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(200);
            expect(json(res.body[0].id)).toEqual(json(dummyUsers[1]._id));
            expect(json(res.body[0].name)).toEqual(json(dummyUsers[1].name));
        });

        it("Should return users that contain email (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const query = {
                username: "noUser@gmail.com"
            };
            const res = await request.get("/user/search")
                .set("Authorization", `Bearer ${userToken}`)
                .query(query);

            expect(res.status).toBe(200);
            expect(json(res.body)).toEqual([]);
        });
    });

    describe("Positive: Follow User", function() {
        it("Should follow selected user", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {
                userToFollowId: dummyUsers[0]._id.toString()
            };
            const res = await request.post("/user/follow")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(200);
            expect(json(res.text)).toEqual("Successfully followed requested user");
        });
    });

    describe("Negative: Follow User With Incorrect Parameters", function() {
        it("Should return 400 (Bad Request) with missing parameters", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {};
            const res = await request.post("/user/follow")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(400);
        });

        it("Should return 404 (Not Found) with non-existing user id", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {
                userToFollowId: mongoose.Types.ObjectId().toString()
            };
            const res = await request.post("/user/follow")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(404);
        });
    });

    describe("Positive: Get User's Followers", function() {
        it("Should return user's followers", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);
    
            const res = await request.get("/user/followers")
                .set("Authorization", `Bearer ${userToken}`);

            expect(res.status).toBe(200);
            expect(json(res.body[0].id)).toEqual(json(dummyUsers[1]._id));
            expect(json(res.body[0].name)).toEqual(json(dummyUsers[1].name));
        });

        it("Should return user's followers (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const res = await request.get("/user/followers")
                .set("Authorization", `Bearer ${userToken}`);

            expect(res.status).toBe(200);
            expect(json(res.body)).toEqual([]);
        });
    });

    describe("Positive: Get User's Following", function() {
        it("Should return user's following (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);
    
            const res = await request.get("/user/following")
                .set("Authorization", `Bearer ${userToken}`);

            expect(res.status).toBe(200);
            expect(json(res.body)).toEqual([]);
        });

        it("Should return user's following (one)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const res = await request.get("/user/following")
                .set("Authorization", `Bearer ${userToken}`);

            expect(res.status).toBe(200);
            expect(json(res.body[0].id)).toEqual(json(dummyUsers[0]._id));
            expect(json(res.body[0].name)).toEqual(json(dummyUsers[0].name));
        });
    });

    describe("Positive: Subscribe to Event", function() {
        it("Should subscribe to public event", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {
                eventIds: [dummyEvents[0]._id.toString()]
            };
            const res = await request.post("/user/subscribe")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(200);
            expect(json(res.body)).toContain(json(dummyEvents[0]._id));
        });
    });

    describe("Negative: Subscribe to Event With Incorrect Parameters", function() {
        it("Should return 400 (Bad Request) with missing parameters", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {};
            const res = await request.post("/user/subscribe")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(400);
        });
    });

    describe("Positive: Get User's Subscribed Events", function() {
        it("Should return user's subscribed events (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);
    
            const res = await request.get("/user/subscribed")
                .set("Authorization", `Bearer ${userToken}`);

            expect(res.status).toBe(200);
            expect(json(res.body)).toEqual([]);
        });

        it("Should return user's subscribed events (one)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const res = await request.get("/user/subscribed")
                .set("Authorization", `Bearer ${userToken}`);

            expect(res.status).toBe(200);
            expect(json(res.body[0].id)).toEqual(json(dummyEvents[0]._id));
            expect(json(res.body[0].name)).toEqual(json(dummyEvents[0].name));
        });
    });

    describe("Positive: Retrieve Pending Invites", function() {
        it("Should return user's pending invitations (one)", async function() {
            const userToken1 = await loginDummyUser(dummyUsersInfo[0]);
            const status = await inviteUserToEvent(userToken1, dummyEvents[1]._id.toString(), dummyUsers[1]._id.toString());
            expect(status).toBe(200);

            const userToken2 = await loginDummyUser(dummyUsersInfo[1]);

            const res = await request.get("/user/pending")
                .set("Authorization", `Bearer ${userToken2}`);
            
            expect(res.status).toBe(200);
            expect(json(res.body[0].id)).toEqual(json(dummyEvents[1]._id));
            expect(json(res.body[0].name)).toEqual(json(dummyEvents[1].name));
        });

        it("Should return user's pending invitations (none)", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const res = await request.get("/user/pending")
                .set("Authorization", `Bearer ${userToken}`);
            
            expect(res.status).toBe(200);
            expect(json(res.body)).toEqual([]);
        });
    });

    describe("Positive: Decline Invite", function() {
        it("Should decline pending invitation", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[0]);

            const reqBody = {
                eventId: dummyEvents[1]._id.toString()
            };
            const res = await request.post("/user/declineInvite")
                .set("Authorization", `Bearer ${userToken}`)
                .send(reqBody);
            
            expect(res.status).toBe(200);
            expect(json(res.text)).toEqual("Successfully removed event invite");
        });
    });

    describe("Negative: Decline Invite With Incorrect Parameters", function() {
        it("Should return 400 (Bad Request) with missing parameters", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {};
            const res = await request.post("/user/declineInvite")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(400);
        });

        it("Should return 404 (Not Found) with non-existing event id", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {
                eventId: mongoose.Types.ObjectId().toString()
            };
            const res = await request.post("/user/declineInvite")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(404);
        });
    });

    describe("Positive: Unfollow User", function() {
        it("Should unfollow selected user", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {
                userToUnfollowId: dummyUsers[0]._id.toString()
            };
            const res = await request.post("/user/unfollow")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(200);
            expect(json(res.text)).toEqual("Successfully unfollowed requested user");
        });
    });

    describe("Negative: Unfollow User With Incorrect Parameters", function() {
        it("Should return 400 (Bad Request) with missing parameters", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {};
            const res = await request.post("/user/unfollow")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(400);
        });

        it("Should return 404 (Not Found) with non-existing user id", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {
                userToUnfollowId: mongoose.Types.ObjectId().toString()
            };
            const res = await request.post("/user/unfollow")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(404);
        });
    });

    describe("Positive: Unsubscribe from Event", function() {
        it("Should unsubscribe from public event", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {
                eventIds: [dummyEvents[0]._id.toString()]
            };
            const res = await request.post("/user/unsubscribe")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(200);
            expect(json(res.body)).not.toContain(json(dummyEvents[0]._id));
        });
    });

    describe("Negative: Unsubscribe from Event With Incorrect Parameters", function() {
        it("Should return 400 (Bad Request) with missing parameters", async function() {
            const userToken = await loginDummyUser(dummyUsersInfo[1]);

            const reqBody = {};
            const res = await request.post("/user/unsubscribe")
                .set("Authorization", `Bearer ${userToken}`) 
                .send(reqBody);

            expect(res.status).toBe(400);
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

var json = function(object) {
    return JSON.parse(JSON.stringify(object));
};
