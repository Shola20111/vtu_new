const mongoose = require('mongoose');

const pricingSchema = mongoose.Schema({
  type: { type: String, default: 'main', unique: true },
  
  // Airtime Discounts (percentage)
  airtimeDiscounts: {
    MTN: { type: Number, default: 3 },
    Airtel: { type: Number, default: 2 },
    Glo: { type: Number, default: 1.5 },
    '9mobile': { type: Number, default: 2 }
  },
  
  // Reseller Commission (%)
  resellerCommission: { type: Number, default: 2 },
  
  // Service Charges (flat Naira)
  serviceCharges: {
    electricity: { type: Number, default: 100 },
    cable: { type: Number, default: 50 },
    exam: { type: Number, default: 0 }
  },
  
  // TV Subscription Markup
  tvMarkup: { type: Number, default: 300 },
  
  // Exam PIN Markup
  examMarkup: { type: Number, default: 200 },
  
  // Minimum wallet balance
  minWalletBalance: { type: Number, default: 100 },
  
  // Maximum single transaction
  maxTransactionLimit: { type: Number, default: 100000 }
}, { timestamps: true });

module.exports = mongoose.model('Pricing', pricingSchema);
