const mongoose = require("mongoose");
const supertest = require("supertest");
const app = require("../../server");
const User = require("../../models/user");
const request = supertest(app);

describe("Test Authentication Handlers", function() {
    // connect to mock mongo before testing
    beforeAll(async function() {
        await mongoose.connect(process.env.MONGO_URL, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
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

    describe("Positive: Register User", function() {
        it("Should register new user to database", async function() {
            const reqBody = {
                email: "test@gmail.com",
                password: "testing123",
                name: "Auth Test"
            };
            const res = await request.post("/register").send(reqBody);
            expect(res.status).toBe(200);

            const newUser = await User.findOne({name: "Auth Test"});
            expect(newUser._id.toString()).toEqual(res.body._id);
            expect(newUser.name).toEqual(res.body.name);
        });
    });

    describe("Positive: Login User", function() {
        it("Should login user", async function() {
            const reqBody = {
                email: "test@gmail.com",
                password: "testing123",
                name: "Auth Test"
            };
            const res = await request.post("/login").send(reqBody);
            expect(res.status).toBe(200);
        });
    });

    describe("Negative: Login User With Bad Password", function() {
        it("Should not login user with incorrect password", async function() {
            const reqBody = {
                email: "test@gmail.com",
                password: "badpassword",
                name: "Auth Test"
            };
            const res = await request.post("/login").send(reqBody);
            expect(res.status).toBe(401);
        });
    });

    describe("Negative: Login User Not in DB", function() {
        it("Should not login user with bad password", async function() {
            const reqBody = {
                email: "incorrect@gmail.com",
                password: "incorrect"

            };
            const res = await request.post("/login").send(reqBody);
            expect(res.status).toBe(401);
        });
    });
});
