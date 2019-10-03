let mongoose = require('mongoose');

let userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  picture: { type: String, required: true },
  id: { type: String, required: true }, // google id
});

let User = module.exports = mongoose.model('User', userSchema);
