const { v4: uuidv4 } = require('uuid');
const Transaction = require('../models/Transaction');
const User = require('../models/User');

// @desc    Purchase Airtime
const purchaseAirtimeHandler = async (req, res) => {
  try {
    const { network, phone, amount } = req.body;
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    if (user.walletBalance < amount) {
      return res.status(400).json({ success: false, message: 'Insufficient wallet balance' });
    }

    const requestId = uuidv4();

    const transaction = await Transaction.create({
      user: user._id,
      requestId,
      serviceType: 'airtime',
      serviceName: `${network} Airtime ₦${amount}`,
      amount,
      phone,
      status: 'successful'
    });

    user.walletBalance -= amount;
    await user.save();

    res.json({
      success: true,
      message: 'Airtime purchased successfully',
      transaction: {
        id: transaction._id,
        requestId,
        amount,
        phone,
        network
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get Data Plans
const getDataPlansHandler = async (req, res) => {
  const { network } = req.params;
  
  const dataPlans = {
    mtn: [
      { code: "M1024", name: "1GB", validity: "30 days", price: 280 },
      { code: "M2048", name: "2GB", validity: "30 days", price: 550 },
      { code: "M5120", name: "5GB", validity: "30 days", price: 1300 },
      { code: "M10240", name: "10GB", validity: "30 days", price: 2500 }
    ],
    airtel: [
      { code: 'A1024', name: '1GB - 30 Days', price: 270 },
      { code: 'A2048', name: '2GB - 30 Days', price: 530 },
      { code: 'A5120', name: '5GB - 30 Days', price: 1250 }
    ],
    glo: [
      { code: 'G1024', name: '1GB - 30 Days', price: 250 },
      { code: 'G2048', name: '2GB - 30 Days', price: 500 }
    ],
    '9mobile': [
      { code: '9M1024', name: '1GB - 30 Days', price: 260 },
      { code: '9M2048', name: '2GB - 30 Days', price: 520 }
    ]
  };

  res.json({
    success: true,
    network: network.toUpperCase(),
    plans: dataPlans[network.toLowerCase()] || []
  });
};

// @desc    Purchase Data
const purchaseDataHandler = async (req, res) => {
  try {
    const { network, phone, dataPlan } = req.body;
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const dataPlans = {
      'M1024': { name: 'MTN 1GB', price: 280 },
      'M2048': { name: 'MTN 2GB', price: 550 },
      'A1024': { name: 'Airtel 1GB', price: 270 },
      'A2048': { name: 'Airtel 2GB', price: 530 },
      'G1024': { name: 'Glo 1GB', price: 250 },
      'G2048': { name: 'Glo 2GB', price: 500 },
      '9M1024': { name: '9mobile 1GB', price: 260 },
      '9M2048': { name: '9mobile 2GB', price: 520 }
    };

    const plan = dataPlans[dataPlan];
    if (!plan) {
      return res.status(400).json({ success: false, message: 'Invalid data plan' });
    }

    if (user.walletBalance < plan.price) {
      return res.status(400).json({ success: false, message: 'Insufficient wallet balance' });
    }

    const requestId = uuidv4();

    const transaction = await Transaction.create({
      user: user._id,
      requestId,
      serviceType: 'data',
      serviceName: plan.name,
      amount: plan.price,
      phone,
      status: 'successful'
    });

    user.walletBalance -= plan.price;
    await user.save();

    res.json({
      success: true,
      message: 'Data purchased successfully',
      transaction: {
        id: transaction._id,
        requestId,
        amount: plan.price,
        phone,
        network,
        dataPlan: plan.name
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Purchase Electricity
const purchaseElectricityHandler = async (req, res) => {
  try {
    const { disco, meterNumber, amount, meterType } = req.body;
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    if (user.walletBalance < amount) {
      return res.status(400).json({ success: false, message: 'Insufficient wallet balance' });
    }

    const requestId = uuidv4();

    const transaction = await Transaction.create({
      user: user._id,
      requestId,
      serviceType: 'electricity',
      serviceName: `${disco} Electricity Token`,
      amount,
      phone: meterNumber,
      status: 'successful'
    });

    user.walletBalance -= amount;
    await user.save();

    res.json({
      success: true,
      message: 'Electricity token generated successfully',
      transaction: {
        id: transaction._id,
        requestId,
        token: '1234-5678-9012-3456',
        units: (amount * 3).toString(),
        amount,
        disco
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Purchase TV Subscription
const purchaseTVSubscriptionHandler = async (req, res) => {
  try {
    const { provider, smartcardNumber, package } = req.body;
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const packages = {
      dstv: { 'premium': 18400, 'compact-plus': 12400, 'compact': 7900, 'family': 4600 },
      gotv: { 'supa-plus': 5500, 'supa': 3900, 'max': 2900, 'jolli': 1900 }
    };

    const amount = packages[provider.toLowerCase()]?.[package.toLowerCase()];
    if (!amount) {
      return res.status(400).json({ success: false, message: 'Invalid package selected' });
    }

    if (user.walletBalance < amount) {
      return res.status(400).json({ success: false, message: 'Insufficient wallet balance' });
    }

    const requestId = uuidv4();

    const transaction = await Transaction.create({
      user: user._id,
      requestId,
      serviceType: 'tv',
      serviceName: `${provider.toUpperCase()} ${package}`,
      amount,
      phone: smartcardNumber,
      status: 'successful'
    });

    user.walletBalance -= amount;
    await user.save();

    res.json({
      success: true,
      message: 'TV subscription renewed successfully',
      transaction: {
        id: transaction._id,
        requestId,
        amount,
        smartcardNumber,
        package
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Purchase Exam PIN
const purchaseExamPINHandler = async (req, res) => {
  try {
    const { examType, quantity = 1 } = req.body;
    const user = await User.findById(req.user._id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const examPrices = {
      waec: 3500,
      neco: 2000,
      jamb: 5000
    };

    const amount = examPrices[examType.toLowerCase()] * quantity;
    
    if (!amount) {
      return res.status(400).json({ success: false, message: 'Invalid exam type' });
    }

    if (user.walletBalance < amount) {
      return res.status(400).json({ success: false, message: 'Insufficient wallet balance' });
    }

    const requestId = uuidv4();

    const transaction = await Transaction.create({
      user: user._id,
      requestId,
      serviceType: 'exam',
      serviceName: `${examType.toUpperCase()} PIN x${quantity}`,
      amount,
      phone: user.phone,
      status: 'successful'
    });

    user.walletBalance -= amount;
    await user.save();

    res.json({
      success: true,
      message: 'Exam PIN purchased successfully',
      transaction: {
        id: transaction._id,
        requestId,
        amount,
        examType,
        quantity,
        pins: ['PIN1', 'PIN2', 'PIN3'].slice(0, quantity)
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get Transaction History
const getTransactionsHandler = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const skip = (page - 1) * limit;

    const query = { user: req.user._id };
    
    if (req.query.serviceType) {
      query.serviceType = req.query.serviceType;
    }
    
    if (req.query.status) {
      query.status = req.query.status;
    }

    const transactions = await Transaction.find(query)
      .sort('-createdAt')
      .skip(skip)
      .limit(limit);

    const total = await Transaction.countDocuments(query);

    res.json({
      success: true,
      transactions,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  purchaseAirtimeHandler,
  purchaseDataHandler,
  getDataPlansHandler,
  purchaseElectricityHandler,
  purchaseTVSubscriptionHandler,
  purchaseExamPINHandler,
  getTransactionsHandler
};