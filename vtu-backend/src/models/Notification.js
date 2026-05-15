const mongoose = require('mongoose');

const notificationSchema = mongoose.Schema({
  title: { type: String, required: true },
  message: { type: String, required: true },
  type: { type: String, enum: ['push', 'sms', 'email', 'all'], default: 'push' },
  target: { type: String, enum: ['all', 'users', 'resellers', 'user'], default: 'all' },
  targetUser: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  sentBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  status: { type: String, enum: ['pending', 'sent', 'failed'], default: 'pending' },
  readBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }]
}, { timestamps: true });

module.exports = mongoose.model('Notification', notificationSchema);
