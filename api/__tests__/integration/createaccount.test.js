const mongoose = require("mongoose");
const supertest = require("supertest");
const config = require("config");
const app = require("../../server");
const request = supertest(app);

describe("Test Authentication Flow", function() {
    beforeAll(async function() {
        const url = config.get("database.url");
        await mongoose.connect(url, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
    });

    afterEach(async function() {
        const collections = Object.keys(mongoose.connection.collections);
        for (const collectionName of collections) {
            const collection = mongoose.connection.collections[collectionName];
            await collection.deleteMany();
        }
    });

    afterAll(async function() {
        await mongoose.connection.close();
    });

    describe("Test Register and Then Login", function() {
        it("Should be able to login after register", async function() {
            // register
            const registerBody = {
                email: "mock-user-1@gmail.com",
                password: "testing123",
                name: "Mock User #1"
            };
            const registerRes = await request.post("/register").send(registerBody);
            expect(registerRes.status).toBe(200);
            // login
            const loginBody = {
                email: "mock-user-1@gmail.com",
                password: "testing123"
            };
            const loginRes = await request.post("/login").send(loginBody);
            expect(loginRes.status).toBe(200);
        });
    });
});
