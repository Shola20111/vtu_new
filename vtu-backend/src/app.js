const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

const authRoutes = require('./routes/authRoutes');
const walletRoutes = require('./routes/walletRoutes');
const vtuRoutes = require('./routes/vtuRoutes');
const adminRoutes = require('./routes/adminRoutes');
const pricingRoutes = require('./routes/pricingRoutes');
const { errorHandler, notFound } = require('./middleware/errorMiddleware');

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const vtuLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 50,
  message: 'Too many VTU requests, please try again later.'
});

app.use('/api/auth', authRoutes);
app.use('/api/wallet', walletRoutes);
app.use('/api/vtu', vtuLimiter, vtuRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/admin', pricingRoutes);
app.use('/api/pricing', pricingRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', service: 'VTU Backend API', version: '1.0.0' });
});

app.use(notFound);
app.use(errorHandler);

module.exports = app;
