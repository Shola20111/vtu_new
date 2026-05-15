const mongoose = require('mongoose');

const settingSchema = mongoose.Schema({
  type: { type: String, default: 'general' },
  appName: { type: String, default: 'VTU App' },
  logo: { type: String, default: '' },
  supportNumber: { type: String, default: '08000000000' },
  supportEmail: { type: String, default: 'support@vtuapp.com' },
  bankName: { type: String, default: 'GTBank' },
  accountNumber: { type: String, default: '0123456789' },
  accountName: { type: String, default: 'VTU App Ltd' },
  airtimeCharge: { type: Number, default: 0 },
  dataCharge: { type: Number, default: 0 },
  electricityCharge: { type: Number, default: 50 },
  tvCharge: { type: Number, default: 100 },
  examCharge: { type: Number, default: 0 },
  resellerDiscount: { type: Number, default: 2 },
  maintenanceMode: { type: Boolean, default: false },
  primaryProvider: { type: String, default: 'vtpass' },
  backupProvider: { type: String, default: 'clubkonnect' },
  providerKeys: {
    vtpass: { apiKey: String, publicKey: String, secretKey: String },
    clubkonnect: { apiKey: String, publicKey: String },
    smeplug: { apiKey: String, publicKey: String },
    monnify: { apiKey: String, secretKey: String }
  }
}, { timestamps: true });

module.exports = mongoose.model('Setting', settingSchema);
