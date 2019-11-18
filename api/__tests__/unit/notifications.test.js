let notifications = require("../../notifications/notifications");

describe("Test Notifications Controller", function() {
    describe("Positive: Successful Initialization", function() {
        it("should be disabled when given allowNotify = false", function() {
            notifications.initialize({}, false);
            expect(notifications.isEnabled()).toBe(false);
        });
    });
    describe("Positive: Successful Notify", function() {
        it("should not notify anyone when null array is given", function() {
            let mockTokens;
            notifications.initialize({}, false);
            expect(notifications.notify("mock message", mockTokens)).toBe(0);
        });
        it("should not notify anyone when empty array is given", function() {
            let mockTokens = [];
            notifications.initialize({}, false);
            expect(notifications.notify("mock message", mockTokens)).toBe(0);
        });
        it("should notify user when one user is given", function() {
            let mockTokens = ["mock-user-token"];
            notifications.initialize({}, false);
            expect(notifications.notify("mock message", mockTokens)).toBe(mockTokens.length);
        });
        it("should notify multiple when multiple users is given", function() {
            let mockTokens = ["mock-user-token", "mock-user-token-2"];
            notifications.initialize({}, false);
            expect(notifications.notify("mock message", mockTokens)).toBe(mockTokens.length);
        });
    });
});
