const Pricing = require('../models/Pricing');
const DataPlan = require('../models/DataPlan');
const Setting = require('../models/Setting');

// ============ PRICING SETTINGS ============
const getPricing = async (req, res) => {
  try {
    let pricing = await Pricing.findOne({ type: 'main' });
    if (!pricing) {
      pricing = await Pricing.create({ type: 'main' });
    }
    res.json({ success: true, pricing });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateAirtimeDiscounts = async (req, res) => {
  try {
    const { MTN, Airtel, Glo, '9mobile': mobile9 } = req.body;
    let pricing = await Pricing.findOne({ type: 'main' });
    if (!pricing) pricing = await Pricing.create({ type: 'main' });
    
    pricing.airtimeDiscounts = {
      MTN: MTN || pricing.airtimeDiscounts.MTN,
      Airtel: Airtel || pricing.airtimeDiscounts.Airtel,
      Glo: Glo || pricing.airtimeDiscounts.Glo,
      '9mobile': mobile9 || pricing.airtimeDiscounts['9mobile']
    };
    pricing.markModified('airtimeDiscounts');
    await pricing.save();
    res.json({ success: true, message: 'Airtime discounts updated', pricing });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateServiceCharges = async (req, res) => {
  try {
    const { electricity, cable, exam } = req.body;
    let pricing = await Pricing.findOne({ type: 'main' });
    if (!pricing) pricing = await Pricing.create({ type: 'main' });
    
    if (electricity !== undefined) pricing.serviceCharges.electricity = electricity;
    if (cable !== undefined) pricing.serviceCharges.cable = cable;
    if (exam !== undefined) pricing.serviceCharges.exam = exam;
    pricing.markModified('serviceCharges');
    await pricing.save();
    res.json({ success: true, message: 'Service charges updated', pricing });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateResellerCommission = async (req, res) => {
  try {
    const { commission } = req.body;
    let pricing = await Pricing.findOne({ type: 'main' });
    if (!pricing) pricing = await Pricing.create({ type: 'main' });
    
    pricing.resellerCommission = commission;
    await pricing.save();
    res.json({ success: true, message: 'Reseller commission updated', pricing });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ============ DATA PLANS ============
const getDataPlans = async (req, res) => {
  try {
    const { network } = req.query;
    const query = network ? { network: network.toUpperCase() } : {};
    const plans = await DataPlan.find(query).sort('network planName');
    res.json({ success: true, plans });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const addDataPlan = async (req, res) => {
  try {
    const { network, planName, planCode, category, size, validity, providerPrice, userPrice, resellerPrice } = req.body;
    
    const exists = await DataPlan.findOne({ planCode });
    if (exists) return res.status(400).json({ success: false, message: 'Plan code already exists' });
    
    const plan = await DataPlan.create({
      network: network.toUpperCase(),
      planName, planCode, category, size, validity,
      providerPrice, userPrice, resellerPrice
    });
    res.status(201).json({ success: true, message: 'Data plan added', plan });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateDataPlan = async (req, res) => {
  try {
    const plan = await DataPlan.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!plan) return res.status(404).json({ success: false, message: 'Plan not found' });
    res.json({ success: true, message: 'Data plan updated', plan });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const toggleDataPlan = async (req, res) => {
  try {
    const plan = await DataPlan.findById(req.params.id);
    if (!plan) return res.status(404).json({ success: false, message: 'Plan not found' });
    plan.isActive = !plan.isActive;
    await plan.save();
    res.json({ success: true, message: plan.isActive ? 'Plan enabled' : 'Plan disabled', plan });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const deleteDataPlan = async (req, res) => {
  try {
    await DataPlan.findByIdAndDelete(req.params.id);
    res.json({ success: true, message: 'Data plan deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ============ PROFIT CALCULATION ============
const getProfitSummary = async (req, res) => {
  try {
    const Transaction = require('../models/Transaction');
    const transactions = await Transaction.find({ status: 'successful' });
    
    const pricing = await Pricing.findOne({ type: 'main' });
    const dataPlans = await DataPlan.find();
    
    let totalRevenue = 0;
    let totalProviderCost = 0;
    let airtimeProfit = 0;
    let dataProfit = 0;
    let electricityProfit = 0;
    let tvProfit = 0;
    let examProfit = 0;
    
    for (const t of transactions) {
      totalRevenue += t.amount;
      
      if (t.serviceType === 'airtime') {
        const discount = pricing?.airtimeDiscounts?.MTN || 3;
        const cost = t.amount * (1 - discount / 100);
        totalProviderCost += cost;
        airtimeProfit += t.amount - cost;
      } else if (t.serviceType === 'data') {
        const plan = dataPlans.find(p => t.serviceName.includes(p.planName));
        const cost = plan?.providerPrice || t.amount * 0.85;
        totalProviderCost += cost;
        dataProfit += t.amount - cost;
      } else if (t.serviceType === 'electricity') {
        const charge = pricing?.serviceCharges?.electricity || 100;
        totalProviderCost += t.amount - charge;
        electricityProfit += charge;
      } else if (t.serviceType === 'tv') {
        const markup = pricing?.tvMarkup || 300;
        totalProviderCost += t.amount - markup;
        tvProfit += markup;
      } else if (t.serviceType === 'exam') {
        const markup = pricing?.examMarkup || 200;
        totalProviderCost += t.amount - markup;
        examProfit += markup;
      }
    }
    
    res.json({
      success: true,
      profit: {
        totalRevenue,
        totalProviderCost,
        netProfit: totalRevenue - totalProviderCost,
        airtimeProfit,
        dataProfit,
        electricityProfit,
        tvProfit,
        examProfit
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  getPricing, updateAirtimeDiscounts, updateServiceCharges, updateResellerCommission,
  getDataPlans, addDataPlan, updateDataPlan, toggleDataPlan, deleteDataPlan,
  getProfitSummary
};
