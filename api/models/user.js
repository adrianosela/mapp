var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var userSchema = new Schema({
  id: String,
  email: String,
  verified_email: Boolean,
  name: String,
  picture: String,
});
