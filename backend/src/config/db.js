// Database configuration using Sequelize
const { Sequelize } = require('sequelize');
const { logger } = require('../utils/logger');

// Create Sequelize instance
const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASS,
  {
    host: process.env.DB_HOST,
    dialect: 'mysql',
    logging: (msg) => logger.debug(msg),
    pool: {
      max: 10,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  }
);

// Test database connection
const testConnection = async () => {
  try {
    await sequelize.authenticate();
    logger.info('Database connection established successfully');
    return true;
  } catch (error) {
    logger.error(`Database connection failed: ${error.message}`);
    return false;
  }
};

// Initialize database - sync all models
const initDatabase = async () => {
  try {
    // This will be handled by models/index.js
    logger.info('Database initialization completed');
    return true;
  } catch (error) {
    logger.error(`Database initialization failed: ${error.message}`);
    return false;
  }
};

module.exports = {
  sequelize,
  testConnection,
  initDatabase
};