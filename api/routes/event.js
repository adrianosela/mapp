const router = require("express").Router();
const eventHandlers = require("../handlers/event");
const middleware = require("../handlers/middleware");

// get an event (by id)
router.get("/event", middleware.verifyToken, eventHandlers.get);

// create an event
router.post("/event", middleware.verifyToken, eventHandlers.create);

// update an event
router.put("/event", middleware.verifyToken, eventHandlers.update);

// Delete event
router.delete("/event", middleware.verifyToken, eventHandlers.delete);

// invite people to an event
router.post("/event/invite", middleware.verifyToken, eventHandlers.invite);

// Get Event Announcements
router.get("/event/announcements", middleware.verifyToken, eventHandlers.getAnnouncements);

// Create new event announcement and notify users assiting to event
router.post("/event/announcement", middleware.verifyToken, eventHandlers.announcement);

// get all public events within a given radius of user coordinates
// which satisfy conditions in the request
router.get("/event/find", middleware.verifyToken, eventHandlers.find);

// Get events for requesting user based on name
router.get("/event/search", middleware.verifyToken, eventHandlers.search);

module.exports = router;
