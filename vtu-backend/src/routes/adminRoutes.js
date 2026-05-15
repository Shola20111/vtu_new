const express = require('express');
const router = express.Router();
const { protect, admin } = require('../middleware/authMiddleware');
const {
  getDashboardStats, getUsers, getUserDetails, fundUserWallet, deductUserWallet,
  updateUserRole, toggleUserStatus, deleteUser, getAllTransactions, reverseTransaction
} = require('../controllers/adminController');
const {
  getSettings, updateSettings, updateProviderKeys, switchProvider, checkProviderBalance,
  sendNotification, getNotifications, getLoginHistory, logoutAllDevices
} = require('../controllers/settingsController');

// Dashboard & Users
router.get('/stats', protect, admin, getDashboardStats);
router.get('/users', protect, admin, getUsers);
router.get('/users/:id', protect, admin, getUserDetails);
router.put('/users/:id/fund', protect, admin, fundUserWallet);
router.put('/users/:id/deduct', protect, admin, deductUserWallet);
router.put('/users/:id/role', protect, admin, updateUserRole);
router.put('/users/:id/toggle-status', protect, admin, toggleUserStatus);
router.delete('/users/:id', protect, admin, deleteUser);

// Transactions
router.get('/transactions', protect, admin, getAllTransactions);
router.put('/transactions/:id/reverse', protect, admin, reverseTransaction);

// Settings
router.get('/settings', protect, admin, getSettings);
router.put('/settings', protect, admin, updateSettings);
router.put('/settings/providers', protect, admin, switchProvider);
router.put('/settings/providers/keys', protect, admin, updateProviderKeys);
router.get('/settings/providers/balance', protect, admin, checkProviderBalance);

// Notifications
router.get('/notifications', protect, admin, getNotifications);
router.post('/notifications/send', protect, admin, sendNotification);

// Security
router.get('/login-history', protect, admin, getLoginHistory);
router.post('/logout-all', protect, admin, logoutAllDevices);

module.exports = router;
