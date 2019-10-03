let mongoose = require('mongoose');

let userSchema = new mongoose.Schema({
  id: String,
  email: String,
  verified_email: Boolean,
  name: String,
  picture: String,
});

let User = module.exports = mongoose.model('User', userSchema);
