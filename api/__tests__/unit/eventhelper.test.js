const mongoose = require("mongoose");
const eventHelper = require("../../utils/event");
const User = require("../../models/user");
const UserSettings = require("../../models/userSettings");
const Event = require("../../models/event");

describe("Test Event Utils", function() {
    const mockfriends = [mongoose.Types.ObjectId(), mongoose.Types.ObjectId()];
    let mockU, mockU2, mockEWithFriends, mockENoFriends;

    // create mock users and events before testing
    beforeAll(async function() {
        await mongoose.connect(process.env.MONGO_URL, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });

        // mock user 1
        let mockUS = await (new UserSettings({
            email: "mock-user-1@gmail.com",
            hash: "mock hash"
        })).save();
        mockU = await(new User({
            _id: mockUS._id,
            name: "mock-user-1",
            fcmToken: "mock-fcm-token-1",
            following: mockfriends
        })).save();

        // mock user 2
        let mockUS2 = await (new UserSettings({
            email: "mock-user-2@gmail.com",
            hash: "mock hash"
        })).save();
        mockU2 = await(new User({
            _id: mockUS2._id,
            name: "mock-user-2",
            fcmToken: "mock-fcm-token-2",
            following: mockfriends
        })).save();

        // mock event with friends
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

        // mock event with no friends
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

    describe("Test inviteUsers", function() {
        describe("Test inviteUsers [with add = false]", function() {
            it("should send no invites if invited array is null",async function() {
                expect(await eventHelper.inviteUsers(mockEWithFriends, [/*empty*/],false, false)).toEqual(0);
            });
            it("should send no invites if invited array is undefined", async function() {
                expect(await eventHelper.inviteUsers(mockEWithFriends, undefined,false,  false)).toEqual(0);
            });
            it("should send invite if invite array has an element",async function() {
                const users = [mockU];
                expect(await eventHelper.inviteUsers(mockEWithFriends, users,false,  false)).toEqual(users.length);
            });
            it("should send multiple invites if invited array has multiple elements",async function() {
                const users = [mockU, mockU2];
                expect(await eventHelper.inviteUsers(mockEWithFriends, users, false, false)).toEqual(users.length);
            });
        });
        describe("Test inviteUsers [with add = true]", function() {
            it("should send no invites if invited array is null",async function() {
                expect(await eventHelper.inviteUsers(mockEWithFriends, [/*empty*/],true, false)).toEqual(0);
            });
            it("should send no invites if invited array is undefined", async function() {
                expect(await eventHelper.inviteUsers(mockEWithFriends, undefined,true,  false)).toEqual(0);
            });
            it("should send invite and add to event if invite array has an element",async function() {
                const users = [mockU];
                expect(await eventHelper.inviteUsers(mockEWithFriends, users, true,  false)).toEqual(users.length);
                // check event has user in 'invited'
                let event = await Event.findById(mockEWithFriends._id);
                expect(event.invited).toContainEqual(mockU._id);
                // check user has event in 'pendingInvites'
                let user = await User.findById(mockU._id);
                expect(user.pendingInvites).toContainEqual(mockEWithFriends._id);
            });
        });
    });
});
