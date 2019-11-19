let notifications = require("../../notifications/notifications");
const nHandler = require("./../../handlers/push");
const Response = require("jest-express/lib/response").Response;
const mongoose = require("mongoose");
const User = require("../../models/user");
const UserSettings = require("../../models/userSettings");

describe("Test Notifications Handlers", function() {
    let response;
    const mockFriends = [mongoose.Types.ObjectId(), mongoose.Types.ObjectId()];
    let mockUser, mockUser2;

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
            followers: mockFriends,
            following: mockFriends
        })).save();

        // mock user 2
        let mockUserSettings2 = await (new UserSettings({
            email: "mock-user99@gmail.com",
            hash: "mock hash",
        })).save();
        mockUser2 = await(new User({
            _id: mockUserSettings2._id,
            name: "mock-user4",
            email: "mock-user99@gmail.com",
            followers: mockFriends,
            following: mockFriends
        })).save();

        notifications.initialize({}, false); // disabled push
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

    describe("Test Push Token Handler", function() {
        describe("Positive: Push Token Handler", function() {
            it("should be disabled when given allowNotify = false", async function() {
                await nHandler.post({body:{fcmToken:"anytoken"}, authorization:{id:mockUser._id}}, response);
                expect(response.json).toBeCalled();
            });
        });
        describe("Negative: Push Token Handler", function() {
            it("should reject request without fcm token", async function() {
                await nHandler.post({body:{}, authorization:{id:mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("No fcm token supplied");
            });
        });
    });

    describe("Test Test-Token Handler", function() {
        describe("Positive: Push Token Handler", function() {
            it("should send a testing push notification", async function() {
                await nHandler.test({body:{userId:mockUser._id.toString()}, authorization:{id:mockUser._id}}, response);
                expect(response.json).toBeCalled();
            });
        });

        describe("Negative: Push Token Handler", function() {
            it("should not send a testing push notification if no user id specified", async function() {
                await nHandler.test({body:{}, authorization:{id:mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should not send a testing push notification if empty user id specified", async function() {
                await nHandler.test({body:{userId: ""}, authorization:{id:mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should return failure if user to send does not have fcm token", async function() {
                await nHandler.test({body:{userId:mockUser2._id.toString()}, authorization:{id:mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
            });
        });
    });
});
