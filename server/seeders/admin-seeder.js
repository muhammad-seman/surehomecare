const bcrypt = require('bcrypt');
const { v4: uuidv4 } = require('uuid');
const AdminModel = require('../models/admin_model');

async function seedAdminUser() {
  try {
    // Check if admin already exists
    const existingAdmin = await AdminModel.findOne({
      where: { username: 'admin@surehomecare.id' }
    });

    if (existingAdmin) {
      console.log('Admin user already exists');
      return;
    }

    // Hash password
    const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS) || 12;
    const hashedPassword = bcrypt.hashSync('Admin123!@#', saltRounds);

    // Create admin user
    const adminData = {
      id: uuidv4(),
      username: 'admin@surehomecare.id',
      password: hashedPassword,
      token: null
    };

    const admin = await AdminModel.create(adminData);
    
    console.log('Admin user created successfully:');
    console.log('Username:', admin.username);
    console.log('Default Password: Admin123!@#');
    console.log('Please change the password after first login!');
    
  } catch (error) {
    console.error('Error creating admin user:', error);
  }
}

module.exports = { seedAdminUser };