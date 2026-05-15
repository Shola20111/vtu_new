const mongoose = require('mongoose');

const loginHistorySchema = mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  ip: String,
  device: String,
  browser: String,
  location: String,
  success: { type: Boolean, default: true }
}, { timestamps: true });

module.exports = mongoose.model('LoginHistory', loginHistorySchema);
