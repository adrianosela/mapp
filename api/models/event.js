let mongoose = require('mongoose');

let eventSchema = new mongoose.Schema({
    // time/place
    location: {
        type: { type: String, required: true },
        coordinates: []
    },
    date: { type: Date, required: true },
    duration: { type: Number, required: true },

    // people
    creator: { type: String, required: true },
    organizers: { type: [ String ], required: true },
    followers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: false }],
    invited: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: false }],

    // metadata
    categories: { type: [ String ], required: false, default: [] }
});

// set geospatial indexing
eventSchema.index({ location: "2dsphere" });

let Event = module.exports = mongoose.model('Event', eventSchema);
