const sequelize = require('./config/database');
const { seedAdminUser } = require('./seeders/admin-seeder');

async function setupDatabase() {
  try {
    console.log('Testing database connection...');
    await sequelize.authenticate();
    console.log('Database connection established successfully.');

    console.log('Syncing database models...');
    await sequelize.sync({ alter: true });
    console.log('Database models synchronized successfully.');

    console.log('Seeding admin user...');
    await seedAdminUser();
    console.log('Database setup completed successfully!');

    process.exit(0);
  } catch (error) {
    console.error('Database setup failed:', error);
    process.exit(1);
  }
}

setupDatabase();