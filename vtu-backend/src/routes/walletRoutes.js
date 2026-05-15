// const express = require('express');
// const router = express.Router();
// const { protect } = require('../middleware/authMiddleware');
// const { getWalletBalance, fundWallet } = require('../controllers/walletController');

// router.get('/balance', protect, getWalletBalance);
// router.post('/fund', protect, fundWallet);

// module.exports = router;



const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const { getWalletBalance, fundWallet, transferFunds } = require('../controllers/walletController');

router.get('/balance', protect, getWalletBalance);
router.post('/fund', protect, fundWallet);
router.post('/transfer', protect, transferFunds);

module.exports = router;