const mongoose = require("mongoose");
const eventHelper = require("../../utils/event");
const User = require("../../models/user");
const UserSettings = require("../../models/userSettings");
const Event = require("../../models/event");

describe("Test Event Utils", function() {
    const mockfriends = [mongoose.Types.ObjectId(), mongoose.Types.ObjectId()];
    let mockU, mockEWithFriends, mockENoFriends;

    // create mock user and events before testing
    beforeAll(async function() {
        await mongoose.connect(process.env.MONGO_URL, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });

        let mockUS = await (new UserSettings({
            email: "mock-user-1@gmail.com",
            hash: "mock hash"
        })).save();

        mockU = await(new User({
            _id: mockUS._id,
            name: "mock-user-1",
            following: mockfriends
        })).save();

        mockEWithFriends = await(new Event({
            name: "mock event name",
            description: "mock event description",
            location: { type: "Point", coordinates: [-123.247360, 49.267941] },
            startTime: 1572928473,
            endTime: 1572928573,
            creator: mockU._id,
            public: true,
            followers: mockfriends
        })).save();

        mockENoFriends = await(new Event({
            name: "mock event name",
            description: "mock event description",
            location: { type: "Point", coordinates: [-123.247360, 49.267941] },
            startTime: 1572928473,
            endTime: 1572928573,
            creator: mockU._id,
            public: true,
            followers: []
        })).save();

        let creatorUser = await User.findById(mockU._id);
        creatorUser.createdEvents.addToSet(mockEWithFriends._id);
        creatorUser.createdEvents.addToSet(mockENoFriends._id);
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

    describe("Test friendsGoing", function() {
        it("should return 0 when no user friends are going to event", function() {
            expect(eventHelper.friendsGoing(mockU, mockENoFriends)).toEqual(0);
        });
        it("should return number of friends going to event", function() {
            expect(eventHelper.friendsGoing(mockU, mockEWithFriends))
                .toEqual(mockfriends.length);
        });
    });

    describe("Test relevantForUser", function() {
        it("should return 'limit' amount of events", function() {
            let events = [mockENoFriends, mockEWithFriends];
            for (var lim = 0; lim < events.legnth; lim++) {
                expect(eventHelper.relevantForUser(events, mockU, lim).length).toEqual(lim);
            }
        });
        it("should return the most relevant event", function() {
            let events = [mockENoFriends, mockEWithFriends];
            expect(eventHelper.relevantForUser(events, mockU, 1).length).toEqual(1);
            expect(eventHelper.relevantForUser(events, mockU, 1)).toContain(mockEWithFriends);
        });
    });
});
