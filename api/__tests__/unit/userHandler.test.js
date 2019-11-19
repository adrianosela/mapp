const userHandler = require("./../../handlers/user");
const Response = require("jest-express/lib/response").Response;
const mongoose = require("mongoose");
const Event = require("../../models/event");
const User = require("../../models/user");
const UserSettings = require("../../models/userSettings");

describe("Test Event Handlers", function() {
    let response;
    const mockFriends = [mongoose.Types.ObjectId(), mongoose.Types.ObjectId()];
    let mockUser, mockEventWithFriends, mockEventNoFriends;

    beforeAll(async function() {
        await mongoose.connect(process.env.MONGO_URL, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });

        // mock user 1
        let mockUserSettings = await (new UserSettings({
            email: "mock-user4@gmail.com",
            hash: "mock hash",
            fcmToken: "mock-fcm-token-1"
        })).save();
        mockUser = await(new User({
            _id: mockUserSettings._id,
            name: "mock-user4",
            email: "mock-user4@gmail.com",
            following: mockFriends
        })).save();

        // mock user 2
        let mockUserSettings2 = await (new UserSettings({
            email: "mock-user5@gmail.com",
            hash: "mock hash",
            fcmToken: "mock-fcm-token-2"
        })).save();
        await(new User({
            _id: mockUserSettings2._id,
            name: "mock-user5",
            email: "mock-user5@gmail.com",
            following: mockFriends
        })).save();

        // mock event with friends
        mockEventWithFriends = await(new Event({
            name: "mock event name 2",
            description: "mock event description",
            location: { type: "Point", coordinates: [-123.247360, 49.267941] },
            startTime: 1572928473,
            endTime: 1572928573,
            creator: mockUser._id,
            public: true,
            invited: [],
            followers: mockFriends
        })).save();

        // mock event with no friends
        mockEventNoFriends = await(new Event({
            name: "mock event name 3",
            description: "mock event description",
            location: { type: "Point", coordinates: [-123.247360, 49.267941] },
            startTime: 1572928473,
            endTime: 1572928573,
            creator: mockUser._id,
            public: true,
            invited: [],
            followers: []
        })).save();

        let creatorUser = await User.findById(mockUser._id);
        creatorUser.createdEvents.addToSet(mockEventWithFriends._id);
        creatorUser.createdEvents.addToSet(mockEventNoFriends._id);
        await creatorUser.save();
    });

    // wipe mock mongo after testing
    afterAll(async function() {
        const collections = Object.keys(mongoose.connection.collections);
        for (const collectionName of collections) {
            const collection = mongoose.connection.collections[collectionName];
            await collection.deleteMany();
        }
        await mongoose.connection.close();
    });

    beforeEach(() => {
        response = new Response();
    });

    afterEach(() => {
        response.resetMocked();
    });

    describe("Test Get User Handler", function() {
        describe("Positive: Get User", function() {
            it("should get an existing user by id", async function() {
                await userHandler.get({query:{email:mockUser.email}, authorization:{id:mockUser._id}}, response);
                expect(response.json).toBeCalled();
            });
        });
        describe("Negative: Get User", function() {
            it("should not get non existing user", async function() {
                await userHandler.get({query:{email:"idontexist"}, authorization:{id:mockUser._id}}, response);
                expect(response.status).toBeCalledWith(404);
            });
            it("should not get user when no email provided", async function() {
                await userHandler.get({query:{}, authorization:{id:mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
            });
        });
    });

    describe("Test Get Self Handler", function() {
        describe("Positive: Get Self Handler", function() {
            it("should get self with out body", async function() {
                await userHandler.me({authorization:{id:mockUser._id}}, response);
                expect(response.json).toBeCalled();
            });
        });
    });

    describe("Test Get Followers Handler", function() {
        describe("Positive: Get Followers Handler", function() {
            it("should get all followers", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test Get Following Handler", function() {
        describe("Positive: Get Following Handler", function() {
            it("should get all following", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test Get Pending Invites Handler", function() {
        describe("Positive: Get Pending Invites Handler", function() {
            it("should get all pending invites", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test Decline Invite Handler", function() {
        describe("Positive: Decline Invite Handler", function() {
            it("should be able to decline an invite", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test Subscribed Events Handler", function() {
        describe("Positive: Subscribed Events Handler", function() {
            it("should be able to get all events user is susbcribed to", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test Created Events Handler", function() {
        describe("Positive: Created Events Handler", function() {
            it("should be able to get all events user created", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test Follow User Handler", function() {
        describe("Positive: Follow User Handler", function() {
            it("should be able follow given users", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test Unfollow User Handler", function() {
        describe("Positive: Unfollow User Handler", function() {
            it("should be able unfollow given users", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test User Subscribe To Events Handler", function() {
        describe("Positive: Subscribe To Event Handler", function() {
            it("should be able to subscribe to an event", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test User Unsubscribe To Events Handler", function() {
        describe("Positive: Unsubscribe To Event Handler", function() {
            it("should be able to unsubscribe from an event", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });

    describe("Test Search Users Handler", function() {
        describe("Positive: Search Users Handler", function() {
            it("should be able to search users by name substring", async function() {
                // TODO
                expect(true).toBe(true);
            });
        });
    });
});
