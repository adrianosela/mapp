const mongoose = require("mongoose");
const supertest = require("supertest");
const app = require("../server");
const User = require("../models/user");
const request = supertest(app);

describe("Test Auth Endpoints", function() {

    beforeAll(async function() {
        await mongoose.connect(process.env.MONGO_URL, { 
            useNewUrlParser: true,
            useUnifiedTopology: true 
        });
    });

    afterAll(async function() {
        await mongoose.connection.close();
    });

    beforeEach(async function() {
        const reqBody = {
            email: "testing@gmail.com",
            password: "testing123",
            name: "Test Dummy"
        };

        await request.post("/register").send(reqBody);
    });

    afterEach(async function() {
        const collections = Object.keys(mongoose.connection.collections);
        for (const collectionName of collections) {
            const collection = mongoose.connection.collections[collectionName];
            await collection.deleteMany();
        }
    });

    describe("Test Register User", function() {
        it("Should register new user to database", async function() {
            const reqBody = {
                email: "test@gmail.com",
                password: "testing123",
                name: "Auth Test"
            };
            
            const res = await request.post("/register").send(reqBody);
            expect(res.status).toBe(200);

            const newUser = await User.findOne({
                name: "Auth Test"
            });
            expect(newUser._id.toString()).toEqual(res.body._id);
            expect(newUser.name).toEqual(res.body.name);
        });

        it("Should return 400 (Bad Request) when user already exists", async function() {
            const reqBody = {
                email: "testing@gmail.com",
                password: "testing123",
                name: "Test Dummy"
            };

            const res = await request.post("/register").send(reqBody);
            expect(res.status).toBe(400);
        });
    });

    describe("Test Login User", function() {
        it("Should login an existing user", async function() {
            const reqBody = {
                email: "testing@gmail.com",
                password: "testing123"
            };

            const res = await request.post("/login").send(reqBody);
            expect(res.status).toBe(200);
            expect(res.body.token).toBeTruthy();
        });

        it("Should return 401 (forbidden) with incorrect password", async function() {
            const reqBody = {
                email: "testing@gmail.com",
                password: "incorrect"
            };

            const res = await request.post("/login").send(reqBody);
            expect(res.status).toBe(401);
        });

        it("Should return 401 (forbidden) with non-registered user", async function() {
            const reqBody = {
                email: "incorrect@gmail.com",
                password: "incorrect"
            };

            const res = await request.post("/login").send(reqBody);
            expect(res.status).toBe(401);
        });
    });
});
