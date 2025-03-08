// Models index file - exports all models and sets up associations
const { sequelize } = require('../config/db');
const { logger } = require('../utils/logger');
const fs = require('fs');
const path = require('path');

const db = {};

// Read all model files in the current directory
fs.readdirSync(__dirname)
  .filter(file => {
    return (
      file.indexOf('.') !== 0 &&
      file !== 'index.js' &&
      file.slice(-3) === '.js'
    );
  })
  .forEach(file => {
    const model = require(path.join(__dirname, file))(sequelize);
    db[model.name] = model;
  });

// Set up associations between models
Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

// Sync all models with the database
db.sync = async (force = false) => {
  try {
    await sequelize.sync({ force });
    logger.info(`Database & tables ${force ? 'forcefully ' : ''}synced`);
    return true;
  } catch (error) {
    logger.error(`Error syncing database: ${error.message}`);
    return false;
  }
};

// Initialize with test data if needed
db.initData = async () => {
  try {
    // Check if admin user exists, create if not
    const adminExists = await db.User.findOne({
      where: { username: 'admin' }
    });

    if (!adminExists) {
      await db.User.create({
        username: 'admin',
        password: 'admin123',  // This will be hashed in the User model
        role: 'admin',
        name: 'Administrator',
        email: 'admin@restaurant.com'
      });
      logger.info('Default admin user created');
    }

    return true;
  } catch (error) {
    logger.error(`Error initializing data: ${error.message}`);
    return false;
  }
};

db.sequelize = sequelize;

module.exports = db;