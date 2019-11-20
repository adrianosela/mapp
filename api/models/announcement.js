let mongoose = require("mongoose");

let announcementSchema = new mongoose.Schema({
    eventId: { type: mongoose.Schema.Types.ObjectId, ref: "Event", required: true },
    messages: { type: [String], required: false, default: [] }
});

module.exports = mongoose.model("Announcement", announcementSchema);
