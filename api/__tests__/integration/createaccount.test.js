const mongoose = require("mongoose");
const supertest = require("supertest");
const config = require("config");
const app = require("../../server");
const User = require("../../models/user");
const request = supertest(app);

describe("Test Authentication Flow", function() {
    beforeAll(async function() {
        const url = config.get("database.url");
        const db = config.get("database.name");
        await mongoose.connect(url + "/" + db, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
    });

    afterAll(async function() {
        await mongoose.connection.close();
    });

    describe("Test Register and Get User", function() {
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
        // it("Should return 400 (Bad Request) when user already exists", async function() {
        //     const reqBody = {
        //         email: "testing@gmail.com",
        //         password: "testing123",
        //         name: "Test Dummy"
        //     };
        //     const res = await request.post("/register").send(reqBody);
        //     expect(res.status).toBe(400);
        // });
    });
});
