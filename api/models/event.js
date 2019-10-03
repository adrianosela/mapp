let mongoose = require('mongoose');

let eventSchema = new mongoose.Schema({
  location: { latitude: String, longitude: String },
  date: { type: Date },
  creator: String,
  organizers: [ String ],
});

let Event = module.exports = mongoose.model('Event', eventSchema);
