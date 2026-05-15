const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const {
  purchaseAirtimeHandler,
  purchaseDataHandler,
  getDataPlansHandler,
  purchaseElectricityHandler,
  purchaseTVSubscriptionHandler,
  purchaseExamPINHandler,
  getTransactionsHandler
} = require('../controllers/vtuController');

router.post('/airtime', protect, purchaseAirtimeHandler);
router.post('/data', protect, purchaseDataHandler);
router.get('/data-plans/:network', protect, getDataPlansHandler);
router.post('/electricity', protect, purchaseElectricityHandler);
router.post('/tv', protect, purchaseTVSubscriptionHandler);
router.post('/exam', protect, purchaseExamPINHandler);
router.get('/transactions', protect, getTransactionsHandler);

module.exports = router;