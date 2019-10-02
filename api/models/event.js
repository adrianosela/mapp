var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var eventSchema = new Schema({
  location: { latitude: String, longitude: String }
  date: { type: Date },
  creator: String,
  organizers: [ String ],
});
