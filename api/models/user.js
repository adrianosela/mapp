let mongoose = require("mongoose");

let userSchema = new mongoose.Schema({
    // id taken from the auth user / user settings
    _id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "UserSettings",
        required: true
    },
    name: { type: String, required: true },
    email: { type: String, required: true },
    followers: [
        { type: mongoose.Schema.Types.ObjectId, ref: "User", required: false }
    ],
    following: [
        { type: mongoose.Schema.Types.ObjectId, ref: "User", required: false }
    ],
    subscribedEvents: [
        { type: mongoose.Schema.Types.ObjectId, ref: "Event", required: false }
    ],
    createdEvents: [
        { type: mongoose.Schema.Types.ObjectId, ref: "Event", required: false }
    ],
    pendingInvites: [
        { type: mongoose.Schema.Types.ObjectId, ref: "Event", required: false }
    ]
});

module.exports = mongoose.model("User", userSchema);
