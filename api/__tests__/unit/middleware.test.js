const mw = require("./../../handlers/middleware");
const jwt = require("jsonwebtoken");
const config = require("config");
const Response = require("jest-express/lib/response").Response;

describe("Test Auth Middleware", function() {
    let response;
    let mockCallback = jest.fn(() => {});
    beforeEach(() => {
        response = new Response();
    });
    afterEach(() => {
        response.resetMocked();
    });

    describe("Positive: VerifyToken", function() {
        it("should pass when valid token is provided in x-access-token header", async function() {
          let token = await jwt.sign(
              { id: "anything", email: "someemail@gmail.com" },
              config.auth.signing_secret,
              { expiresIn: "24h" }
          );
            await mw.verifyToken({headers:{"x-access-token":token}}, response, mockCallback);
            expect(mockCallback).toBeCalled();
        });
        it("should pass when valid token is provided in authorization header", async function() {
          let token = await jwt.sign(
              { id: "anything", email: "someemail@gmail.com" },
              config.auth.signing_secret,
              { expiresIn: "24h" }
          );
            await mw.verifyToken({headers:{"authorization":token}}, response, mockCallback);
            expect(mockCallback).toBeCalled();
        });
    });
    
    describe("Negative: VerifyToken", function() {
        it("should fail when no token is found", async function() {
            await mw.verifyToken({headers:{}}, response);
            expect(response.status).toBeCalledWith(401);
            expect(response.send).toBeCalledWith("No auth token in header");
        });
        it("should fail when invalid token is given in x-access-token header", async function() {
            await mw.verifyToken({headers:{"x-access-token": "Bearer srdatfyguhij"}}, response);
            expect(response.status).toBeCalledWith(401);
            expect(response.send).toBeCalledWith("Invalid token: JsonWebTokenError: jwt malformed");
        });
        it("should fail when invalid token is given in authorization header", async function() {
            await mw.verifyToken({headers:{"authorization": "Bearer srdatfyguhij"}}, response);
            expect(response.status).toBeCalledWith(401);
            expect(response.send).toBeCalledWith("Invalid token: JsonWebTokenError: jwt malformed");
        });
    });
});
