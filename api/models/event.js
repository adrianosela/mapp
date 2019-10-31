let mongoose = require("mongoose");

let eventSchema = new mongoose.Schema({
    name: { type: String, required: true },
    description: { type: String, required: false, default: "" },

    // time/place
    location: {
        type: { type: String, required: true },
        coordinates: []
    },
    startTime: { type: Number, required: true },
    endTime: { type: Number, required: true },

    // people
    creator: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    followers: [
        { type: mongoose.Schema.Types.ObjectId, ref: "User", required: false }
    ],
    invited: [
        { type: mongoose.Schema.Types.ObjectId, ref: "User", required: false }
    ],

    // metadata
    categories: { type: [String], required: false, default: [] },
    public: { type: Boolean, required: false, default: true }
});

// set geospatial indexing
eventSchema.index({ location: "2dsphere" });

module.exports = mongoose.model("Event", eventSchema);
