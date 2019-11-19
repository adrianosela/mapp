const authHandler = require("./../../handlers/auth");
const Response = require("jest-express/lib/response").Response;
const mongoose = require("mongoose");
const User = require("../../models/user");
const UserSettings = require("../../models/userSettings");

let response;

describe("Test Auth Handlers", function() {
    beforeAll(async function() {
        await mongoose.connect(process.env.MONGO_URL, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });

        // mock user 1
        let mockUS = await (new UserSettings({
            email: "mock-user-1@gmail.com",
            hash: "$2b$10$leEcrYCMWT58sla73v00E.r4pnhLfBgAf6TMHvgUIDnQnxf3wSveC", // hash of "mock_password"
            fcmToken: "mock-fcm-token-1"
        })).save();
        await(new User({
            _id: mockUS._id,
            name: "mock-user-1",
            email: "mock-user-1@gmail.com",
            following: [mongoose.Types.ObjectId(), mongoose.Types.ObjectId()],
        })).save();
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

    describe("Test Register Handler", function() {
        describe("Positive: Register", function() {
            it("should register a new user when valid input is provided", async function() {
                await authHandler.register({body:{
                    email: "mock_value@gmail.com",
                    password: "mock_value",
                    name: "mock_value",
                }}, response);
                expect(response.json).toBeCalled();
            });
        });
        describe("Negative: Register", function() {
            it("should not register already existing user", async function() {
                await authHandler.register({body:{
                    email: "mock-user-1@gmail.com",
                    password: "mock_value",
                    name: "mock_value",
                }}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should not register a user when no email provided", async function() {
                await authHandler.register({body:{
                    password: "mock_value",
                    name: "mock_value",
                }}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should not register a user when no password provided", async function() {
                await authHandler.register({body:{
                    email: "mock_value",
                    name: "mock_value",
                }}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should not register a user when no name provided", async function() {
                await authHandler.register({body:{
                    email: "mock_value",
                    password: "mock_value",
                }}, response);
                expect(response.status).toBeCalledWith(400);
            });
        });
    });


    describe("Test Login Handler", function() {
        describe("Positive: Login", function() {
            it("should login an existing user if valid credentials provided", async function() {
                await authHandler.login({body:{
                    email: "mock_value@gmail.com",
                    password: "mock_value",
                }}, response);
                expect(response.json).toBeCalled();
            });
        });
        describe("Negative: Login", function() {
            it("should not login existing user with invalid credentials", async function() {
                await authHandler.login({body:{
                    email: "mock_value@gmail.com",
                    password: "mock_value-bad",
                }}, response);
                expect(response.status).toBeCalledWith(401);
            });
            it("should not login user when no email is provided", async function() {
                await authHandler.login({body:{
                    password: "mock_value",
                }}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should not login user when bad email is provided", async function() {
                await authHandler.login({body:{
                    email: "mock_value-noat",
                    password: "mock_value",
                }}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should not login user when no password is provided", async function() {
                await authHandler.login({body:{
                    email: "mock_value@gmail.com",
                }}, response);
                expect(response.status).toBeCalledWith(400);
            });
            it("should not login non-existing user", async function() {
                await authHandler.login({body:{
                    password: "mock_value-bad@gmail.com",
                    name: "mock_value",
                }}, response);
                expect(response.status).toBeCalledWith(400);
            });
        });
    });

    describe("Test Whoami Handler", function() {
        describe("Positive: Whoami", function() {
            it("should return request body.authorization", async function() {
                let mockAuth = {
                    id: "mockID",
                    name: "mockName",
                };
                await authHandler.whoami({authorization:mockAuth}, response);
                expect(response.json).toBeCalledWith(mockAuth);
            });
        });
    });
});
