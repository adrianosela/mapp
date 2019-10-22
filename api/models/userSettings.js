let mongoose = require('mongoose');

let userSettingsSchema = new mongoose.Schema({
    email: { type: String, required: true },
    hash: { type: String, required: true },
    fcmToken: { type: String, required: false },
    preferences: {
        categories: { type: [ String ], required: false, default: [] },
        publicMode: { type: Boolean, required: false, default: false }
    }
});

let UserSettings = module.exports = mongoose.model('UserSettings', userSettingsSchema);
