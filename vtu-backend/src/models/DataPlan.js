const mongoose = require('mongoose');

const dataPlanSchema = mongoose.Schema({
  network: { type: String, required: true, enum: ['MTN', 'Airtel', 'Glo', '9mobile'] },
  planName: { type: String, required: true },
  planCode: { type: String, required: true, unique: true },
  category: { type: String, default: 'SME', enum: ['SME', 'Gifting', 'Corporate', 'Direct'] },
  size: { type: String, required: true },
  validity: { type: String, default: '30 days' },
  providerPrice: { type: Number, required: true },
  userPrice: { type: Number, required: true },
  resellerPrice: { type: Number, required: true },
  isActive: { type: Boolean, default: true }
}, { timestamps: true });

module.exports = mongoose.model('DataPlan', dataPlanSchema);
