let mongoose = require('mongoose');

let userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true },
    picture: { type: String, required: true },
    id: { type: String, required: true }, // google id
    preferences: {
        categories: { type: [ String ], required: false, default: [] },
        publicMode: { type: Boolean, required: false, default: false }
    },
    followers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: false }],
    following: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: false }]
});

let User = module.exports = mongoose.model('User', userSchema);
