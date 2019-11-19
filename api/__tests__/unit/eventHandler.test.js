const eventHandler = require("./../../handlers/event");
const Response = require("jest-express/lib/response").Response;
const mongoose = require("mongoose");
const Event = require("../../models/event");
const User = require("../../models/user");
const UserSettings = require("../../models/userSettings");

const DAY_IN_SEC = 86400;
const TODAY_IN_EPOCH = Math.floor(Date.now() / 1000);
const LONGITUDE = -123.249572;
const LATITUDE = 49.261718;

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

    describe("Test Get Event Handler", function() {
        describe("Positive: Get Event", function() {
            it("should get an existing event by id", async function() {
                await eventHandler.get({query:{id:mockEventWithFriends._id}}, response);
                expect(response.json).toBeCalled();
            });
        });
        describe("negative: Get Event", function() {
            it("should not get non-existent event by id", async function() {
                await eventHandler.get({query:{id:"501f77bcf7f86cd799439011"}}, response);
                expect(response.status).toBeCalledWith(404);
            });
            it("should not get non-existent event with bad id", async function() {
                await eventHandler.get({query:{id:"bad id"}}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should not get non-existent event with no id provided", async function() {
                await eventHandler.get({query:{id:""}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("No event id in query string");
            });
        });
    });

    describe("Test Create Event Handler", function() {
        describe("Positive: Create Event", function() {
            it("should create a valid event", async function() {
                let mockE = {
                    name: "Dummy Event 17",
                    description: "Test Event 17",
                    latitude: LATITUDE,
                    longitude: LONGITUDE,
                    startTime: TODAY_IN_EPOCH,
                    endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                    _public: false,
                };
                await eventHandler.create({body:mockE, authorization: {id: mockUser._id}}, response);
                expect(response.json).toBeCalled();
            });
        });
        describe("Negative: Create Event", function() {
            it("should not create event without name", async function() {
                let mockE = {
                    description: "Test Event 17",
                    latitude: LATITUDE,
                    longitude: LONGITUDE,
                    startTime: TODAY_IN_EPOCH,
                    endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                    _public: false,
                };
                await eventHandler.create({body:mockE, authorization: {id: mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("No event name provided");
            });
            it("should not create event without description", async function() {
                let mockE = {
                    name: "Test Event 17",
                    latitude: LATITUDE,
                    longitude: LONGITUDE,
                    startTime: TODAY_IN_EPOCH,
                    endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                    _public: false,
                };
                await eventHandler.create({body:mockE, authorization: {id: mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("No event description provided");
            });
            it("should not create event without latitude", async function() {
                let mockE = {
                    name: "test event 18",
                    description: "Test Event 18 description",
                    longitude: LONGITUDE,
                    startTime: TODAY_IN_EPOCH,
                    endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                    _public: false,
                };
                await eventHandler.create({body:mockE, authorization: {id: mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("No latitude provided");
            });
            it("should not create event without longitude", async function() {
                let mockE = {
                    description: "Test Event 17",
                    name: "someeventname",
                    latitude: LATITUDE,
                    startTime: TODAY_IN_EPOCH,
                    endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                    _public: false,
                };
                await eventHandler.create({body:mockE, authorization: {id: mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("No longitude provided");
            });
            it("should not create an event without start time", async function() {
                let mockE = {
                    name: "Dummy Event 17",
                    description: "Test Event 17",
                    latitude: LATITUDE,
                    longitude: LONGITUDE,
                    endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                    _public: false,
                };
                await eventHandler.create({body:mockE, authorization: {id: mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("No start time provided");
            });
            it("should not create an event without end time", async function() {
                let mockE = {
                    name: "Dummy Event 17",
                    description: "Test Event 17",
                    latitude: LATITUDE,
                    longitude: LONGITUDE,
                    startTime: TODAY_IN_EPOCH,
                    _public: false,
                };
                await eventHandler.create({body:mockE, authorization: {id: mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("No end time provided");
            });
            it("should not create an event with end time before start time ", async function() {
                let mockE = {
                    name: "Dummy Event 17",
                    description: "Test Event 17",
                    latitude: LATITUDE,
                    longitude: LONGITUDE,
                    endTime: TODAY_IN_EPOCH,
                    startTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                    _public: false,
                };
                await eventHandler.create({body:mockE, authorization: {id: mockUser._id}}, response);
                expect(response.status).toBeCalledWith(400);
                expect(response.send).toBeCalledWith("Event end time cannot be before start time");
            });
        });

        describe("Test Update Event Handler", function() {
            describe("Positive: Update Event", function() {
                it("should get an existing event by id", async function() {
                    let mockE = {
                        _id: mockEventWithFriends._id,
                        creator: mockUser._id,
                        name: "Dummy Event 17",
                        description: "Test Event 17",
                        latitude: LATITUDE,
                        longitude: LONGITUDE,
                        startTime: TODAY_IN_EPOCH,
                        endTime: TODAY_IN_EPOCH + DAY_IN_SEC,
                        _public: false,
                    };
                    await eventHandler.update({body:{event:mockE}, authorization: {id: mockUser._id}}, response);
                    expect(response.json).toBeCalled();
                });
            });
        });
    });
});
