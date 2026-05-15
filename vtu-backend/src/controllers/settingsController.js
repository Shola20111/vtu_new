const Setting = require('../models/Setting');
const Notification = require('../models/Notification');
const User = require('../models/User');
const LoginHistory = require('../models/LoginHistory');

// ============ SETTINGS ============
const getSettings = async (req, res) => {
  try {
    let settings = await Setting.findOne({ type: 'general' });
    if (!settings) {
      settings = await Setting.create({ type: 'general' });
    }
    res.json({ success: true, settings });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateSettings = async (req, res) => {
  try {
    const updates = req.body;
    let settings = await Setting.findOne({ type: 'general' });
    if (!settings) {
      settings = await Setting.create({ type: 'general', ...updates });
    } else {
      Object.assign(settings, updates);
      await settings.save();
    }
    res.json({ success: true, message: 'Settings updated', settings });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateProviderKeys = async (req, res) => {
  try {
    const { provider, apiKey, publicKey, secretKey } = req.body;
    let settings = await Setting.findOne({ type: 'general' });
    if (!settings) settings = await Setting.create({ type: 'general' });
    
    settings.providerKeys[provider] = { apiKey, publicKey, secretKey };
    settings.markModified('providerKeys');
    await settings.save();
    res.json({ success: true, message: `${provider} keys updated` });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const switchProvider = async (req, res) => {
  try {
    const { primaryProvider, backupProvider } = req.body;
    let settings = await Setting.findOne({ type: 'general' });
    if (!settings) settings = await Setting.create({ type: 'general' });
    
    if (primaryProvider) settings.primaryProvider = primaryProvider;
    if (backupProvider) settings.backupProvider = backupProvider;
    await settings.save();
    res.json({ success: true, message: 'Provider switched', settings });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const checkProviderBalance = async (req, res) => {
  try {
    const settings = await Setting.findOne({ type: 'general' });
    // Mock - in production, call actual provider API
    res.json({
      success: true,
      balances: {
        vtpass: { balance: 'N150,000', status: 'active' },
        clubkonnect: { balance: 'N75,000', status: 'active' },
        smeplug: { balance: 'N0', status: 'inactive' },
        monnify: { balance: 'N200,000', status: 'active' }
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ============ NOTIFICATIONS ============
const sendNotification = async (req, res) => {
  try {
    const { title, message, type, target, targetUser } = req.body;
    const notification = await Notification.create({
      title, message, type: type || 'push',
      target: target || 'all', targetUser, sentBy: req.user._id
    });
    res.json({ success: true, message: 'Notification sent', notification });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const getNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find().sort('-createdAt').limit(50).populate('sentBy', 'fullName');
    res.json({ success: true, notifications });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ============ LOGIN HISTORY ============
const getLoginHistory = async (req, res) => {
  try {
    const history = await LoginHistory.find().sort('-createdAt').limit(100).populate('user', 'fullName email');
    res.json({ success: true, history });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const logoutAllDevices = async (req, res) => {
  try {
    // In production, invalidate all JWT tokens by changing JWT_SECRET
    res.json({ success: true, message: 'All devices logged out. Users will need to login again.' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  getSettings, updateSettings, updateProviderKeys, switchProvider, checkProviderBalance,
  sendNotification, getNotifications, getLoginHistory, logoutAllDevices
};
