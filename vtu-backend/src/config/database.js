// const mongoose = require('mongoose');

// const connectDB = async () => {
//   try {
//     const conn = await mongoose.connect(process.env.MONGO_URI);
//     console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
//     await createDefaultAdmin();
//   } catch (error) {
//     console.error(`❌ MongoDB Error: ${error.message}`);
//     process.exit(1);
//   }
// };

// const createDefaultAdmin = async () => {
//   try {
//     const User = require('../models/User');
//     const adminExists = await User.findOne({ role: 'admin' });
    
//     if (!adminExists) {
//       const bcrypt = require('bcryptjs');
//       await User.create({
//         fullName: 'Super Admin',
//         email: process.env.ADMIN_EMAIL || 'admin@yourvtu.com',
//         username: process.env.ADMIN_USERNAME || 'superadmin',
//         // password: await bcrypt.hash(process.env.ADMIN_PASSWORD || 'Admin@123', 10),
//         password: process.env.ADMIN_PASSWORD || 'Admin@123',
//         phone: '08000000000',
//         role: 'admin',
//         isVerified: true,
//         walletBalance: 1000000
//       });
//       console.log('✅ Default admin created');
//       console.log('   Email: admin@yourvtu.com');
//       console.log('   Username: superadmin');
//       console.log('   Password: Admin@123');
//     }
//   } catch (error) {
//     console.log('Admin creation note:', error.message);
//   }
// };

// module.exports = connectDB;

const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(
      process.env.MONGO_URI,
    );

    console.log(
      `✅ MongoDB Connected: ${conn.connection.host}`,
    );

    await createOrUpdateAdmin();
  } catch (error) {
    console.error(
      `❌ MongoDB Error: ${error.message}`,
    );

    process.exit(1);
  }
};

const createOrUpdateAdmin = async () => {
  try {
    const User = require('../models/User');

    const adminEmail =
      process.env.ADMIN_EMAIL ||
      'admin@yourvtu.com';

    const adminPassword =
      process.env.ADMIN_PASSWORD ||
      'Admin@123';

    let admin = await User.findOne({
      email: adminEmail,
    });

    if (!admin) {
      admin = await User.create({
        fullName: 'Super Admin',

        email: adminEmail,

        username:
          process.env.ADMIN_USERNAME ||
          'superadmin',

        password: adminPassword,

        phone: '08000000000',

        role: 'admin',

        isVerified: true,

        walletBalance: 1000000,
      });

      console.log(
        '✅ Default admin created',
      );
    } else {
      admin.password = adminPassword;

      admin.role = 'admin';

      admin.isVerified = true;

      await admin.save();

      console.log(
        '✅ Admin password updated',
      );
    }

    console.log(
      '━━━━━━━━━━━━━━━━━━━━━━',
    );

    console.log(
      `Email: ${adminEmail}`,
    );

    console.log(
      `Password: ${adminPassword}`,
    );

    console.log(
      '━━━━━━━━━━━━━━━━━━━━━━',
    );
  } catch (error) {
    console.log(
      'Admin setup error:',
      error.message,
    );
  }
};

module.exports = connectDB;