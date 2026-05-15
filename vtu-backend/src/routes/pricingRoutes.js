const express = require('express');
const router = express.Router();
const { protect, admin } = require('../middleware/authMiddleware');
const {
  getPricing, updateAirtimeDiscounts, updateServiceCharges, updateResellerCommission,
  getDataPlans, addDataPlan, updateDataPlan, toggleDataPlan, deleteDataPlan,
  getProfitSummary
} = require('../controllers/pricingController');

// Pricing settings
router.get('/pricing', protect, admin, getPricing);
router.put('/pricing/airtime-discounts', protect, admin, updateAirtimeDiscounts);
router.put('/pricing/service-charges', protect, admin, updateServiceCharges);
router.put('/pricing/reseller-commission', protect, admin, updateResellerCommission);

// Data plans management
router.get('/data-plans', protect, admin, getDataPlans);
router.post('/data-plans', protect, admin, addDataPlan);
router.put('/data-plans/:id', protect, admin, updateDataPlan);
router.put('/data-plans/:id/toggle', protect, admin, toggleDataPlan);
router.delete('/data-plans/:id', protect, admin, deleteDataPlan);

// Profit summary
router.get('/profit', protect, admin, getProfitSummary);

module.exports = router;
