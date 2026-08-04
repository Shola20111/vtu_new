const User = require('../models/User');
const Transaction = require('../models/Transaction');

const getWalletBalance = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    
    res.json({
      success: true,
      data: user.walletBalance
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const fundWallet = async (req, res) => {
  try {
    const { amount } = req.body;
    const user = await User.findById(req.user._id);
    
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    
    if (!amount || amount <= 0) {
      return res.status(400).json({ success: false, message: 'Invalid amount' });
    }
    
    user.walletBalance += Number(amount);
    await user.save();
    
    res.json({
      success: true,
      message: 'Wallet funded successfully',
      data: user.walletBalance
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const transferFunds = async (req, res) => {
  try {
    const { recipientUsername, amount, description } = req.body;
    const sender = await User.findById(req.user._id);
    
    if (!sender) {
      return res.status(404).json({ success: false, message: 'Sender not found' });
    }
    
    if (!amount || amount <= 0) {
      return res.status(400).json({ success: false, message: 'Invalid amount' });
    }
    
    if (sender.walletBalance < amount) {
      return res.status(400).json({ success: false, message: 'Insufficient balance' });
    }
    
    const recipient = await User.findOne({ 
      $or: [{ username: recipientUsername }, { email: recipientUsername }, { phone: recipientUsername }] 
    });
    
    if (!recipient) {
      return res.status(404).json({ success: false, message: 'Recipient not found' });
    }
    
    if (recipient._id.toString() === sender._id.toString()) {
      return res.status(400).json({ success: false, message: 'Cannot transfer to yourself' });
    }
    
    sender.walletBalance -= Number(amount);
    recipient.walletBalance += Number(amount);
    
    await sender.save();
    await recipient.save();
    
    // Record transaction for sender
    await Transaction.create({
      user: sender._id,
      requestId: require('uuid').v4(),
      serviceType: 'transfer',
      serviceName: `Transfer to ${recipient.fullName}`,
      amount: Number(amount),
      phone: recipient.phone,
      status: 'successful'
    });
    
    // Record transaction for recipient
    await Transaction.create({
      user: recipient._id,
      requestId: require('uuid').v4(),
      serviceType: 'transfer',
      serviceName: `Received from ${sender.fullName}`,
      amount: Number(amount),
      phone: sender.phone,
      status: 'successful'
    });
    
    res.json({
      success: true,
      message: `Successfully transferred N${amount} to ${recipient.fullName}`,
      data: {
        senderBalance: sender.walletBalance,
        recipientName: recipient.fullName
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { getWalletBalance, fundWallet, transferFunds };