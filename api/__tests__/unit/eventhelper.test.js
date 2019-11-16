const mongoose = require("mongoose");
const eventHelper = require("../../utils/event");
const User = require("../../models/user");
const UserSettings = require("../../models/usersettings");
const Event = require("../../models/event");

describe("Test Event Utils", function() {
    const mockfriends = [mongoose.Types.ObjectId(), mongoose.Types.ObjectId()];
    let mockU, mockE;

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

        mockE = await(new Event({
            name: "mock event name",
            description: "mock event description",
            location: { type: "Point", coordinates: [-123.247360, 49.267941] },
            startTime: 1572928473,
            endTime: 1572928573,
            creator: mockU._id,
            public: true,
            followers: mockfriends
        })).save();

        let creatorUser = await User.findById(mockU._id);
        creatorUser.createdEvents.addToSet(mockE._id);
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
        it("should return list of user friends going to event", function() {
            let going = eventHelper.friendsGoing(mockU, mockE);
            expect(going).toEqual(mockfriends.length);
        });
    });
});
