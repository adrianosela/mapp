let mongoose = require('mongoose');

let eventSchema = new mongoose.Schema({
  // time/place
  location: { 
    latitude: { type: String, required: true },
    longitude: { type: String, required: true },
  },
  date: { type: Date, required: true },
  duration: { type: Number, required: true },

  // people
  creator: { type: String, required: true },
  organizers: { type: [ String ], required: true },
  followers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: false }],

  // metadata
  categories: { type: [ String ], required: false },
});

let Event = module.exports = mongoose.model('Event', eventSchema);
