const User = require('../models/User');
const Transaction = require('../models/Transaction');
const { v4: uuidv4 } = require('uuid');

// ============ DASHBOARD ============
const getDashboardStats = async (req, res) => {
  try {
    const totalUsers = await User.countDocuments();
    const totalResellers = await User.countDocuments({ role: 'reseller' });
    const totalTransactions = await Transaction.countDocuments();
    const successfulTransactions = await Transaction.countDocuments({ status: 'successful' });
    const failedTransactions = await Transaction.countDocuments({ status: 'failed' });
    
    // Revenue
    const allTransactions = await Transaction.find({ status: 'successful' });
    const totalRevenue = allTransactions.reduce((sum, t) => sum + t.amount, 0);
    
    // Today's sales
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayTransactions = await Transaction.find({ status: 'successful', createdAt: { $gte: today } });
    const todaySales = todayTransactions.reduce((sum, t) => sum + t.amount, 0);
    
    // By service type
    const airtimeSales = allTransactions.filter(t => t.serviceType === 'airtime').reduce((s, t) => s + t.amount, 0);
    const dataSales = allTransactions.filter(t => t.serviceType === 'data').reduce((s, t) => s + t.amount, 0);
    const electricitySales = allTransactions.filter(t => t.serviceType === 'electricity').reduce((s, t) => s + t.amount, 0);
    const tvSales = allTransactions.filter(t => t.serviceType === 'tv').reduce((s, t) => s + t.amount, 0);
    
    // Recent transactions
    const recentTransactions = await Transaction.find().sort('-createdAt').limit(10).populate('user', 'fullName email');

    res.json({
      success: true,
      stats: {
        totalUsers, totalResellers, totalTransactions, successfulTransactions, failedTransactions,
        totalRevenue, todaySales, airtimeSales, dataSales, electricitySales, tvSales, recentTransactions
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ============ USERS ============
const getUsers = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const skip = (page - 1) * limit;
    const search = req.query.search || '';

    const query = search ? { $or: [{ fullName: new RegExp(search, 'i') }, { email: new RegExp(search, 'i') }, { username: new RegExp(search, 'i') }, { phone: new RegExp(search, 'i') }] } : {};

    const users = await User.find(query).select('-password').sort('-createdAt').skip(skip).limit(limit);
    const total = await User.countDocuments(query);

    res.json({ success: true, users, pagination: { page, limit, total, pages: Math.ceil(total / limit) } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const getUserDetails = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-password');
    if (!user) return res.status(404).json({ success: false, message: 'User not found' });
    const transactions = await Transaction.find({ user: user._id }).sort('-createdAt').limit(50);
    res.json({ success: true, user, transactions });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const fundUserWallet = async (req, res) => {
  try {
    const { amount } = req.body;
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ success: false, message: 'User not found' });
    user.walletBalance += Number(amount);
    await user.save();
    await Transaction.create({ user: user._id, requestId: uuidv4(), serviceType: 'wallet', serviceName: 'Admin Credit', amount: Number(amount), phone: user.phone, status: 'successful' });
    res.json({ success: true, message: `Wallet credited with N${amount}`, balance: user.walletBalance });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const deductUserWallet = async (req, res) => {
  try {
    const { amount } = req.body;
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ success: false, message: 'User not found' });
    if (user.walletBalance < amount) return res.status(400).json({ success: false, message: 'Insufficient balance' });
    user.walletBalance -= Number(amount);
    await user.save();
    await Transaction.create({ user: user._id, requestId: uuidv4(), serviceType: 'wallet', serviceName: 'Admin Debit', amount: Number(amount), phone: user.phone, status: 'successful' });
    res.json({ success: true, message: `Wallet debited by N${amount}`, balance: user.walletBalance });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateUserRole = async (req, res) => {
  try {
    const { role } = req.body;
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ success: false, message: 'User not found' });
    user.role = role;
    await user.save();
    res.json({ success: true, message: `Role updated to ${role}`, user });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const toggleUserStatus = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ success: false, message: 'User not found' });
    user.isVerified = !user.isVerified;
    await user.save();
    res.json({ success: true, message: user.isVerified ? 'User activated' : 'User suspended', user });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const deleteUser = async (req, res) => {
  try {
    await User.findByIdAndDelete(req.params.id);
    await Transaction.deleteMany({ user: req.params.id });
    res.json({ success: true, message: 'User deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ============ TRANSACTIONS ============
const getAllTransactions = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;
    const skip = (page - 1) * limit;
    const query = {};
    if (req.query.serviceType) query.serviceType = req.query.serviceType;
    if (req.query.status) query.status = req.query.status;
    if (req.query.userId) query.user = req.query.userId;

    const transactions = await Transaction.find(query).sort('-createdAt').skip(skip).limit(limit).populate('user', 'fullName email username');
    const total = await Transaction.countDocuments(query);

    res.json({ success: true, transactions, pagination: { page, limit, total, pages: Math.ceil(total / limit) } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const reverseTransaction = async (req, res) => {
  try {
    const transaction = await Transaction.findById(req.params.id);
    if (!transaction) return res.status(404).json({ success: false, message: 'Transaction not found' });
    if (transaction.status === 'refunded') return res.status(400).json({ success: false, message: 'Already refunded' });
    
    const user = await User.findById(transaction.user);
    if (user) { user.walletBalance += transaction.amount; await user.save(); }
    
    transaction.status = 'refunded';
    await transaction.save();
    res.json({ success: true, message: 'Transaction reversed successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  getDashboardStats, getUsers, getUserDetails, fundUserWallet, deductUserWallet,
  updateUserRole, toggleUserStatus, deleteUser, getAllTransactions, reverseTransaction
};
