const mongoose = require('mongoose');

const transactionSchema = mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  requestId: { type: String, required: true, unique: true },
  serviceType: { type: String, enum: ['airtime', 'data', 'tv', 'electricity', 'exam'], required: true },
  serviceName: { type: String, required: true },
  amount: { type: Number, required: true },
  commission: { type: Number, default: 0 },
  phone: { type: String, required: true },
  status: { type: String, enum: ['pending', 'processing', 'successful', 'failed', 'refunded'], default: 'pending' },
  providerResponse: { type: Object },
  createdAt: { type: Date, default: Date.now }
}, { timestamps: true });

const Transaction = mongoose.model('Transaction', transactionSchema);
module.exports = Transaction;