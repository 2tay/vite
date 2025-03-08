require('dotenv').config(); 

const express = require('express');
const cors = require('cors');
const { logger } = require('./utils/logger');
const { testConnection } = require('./config/db');
const db = require('./models');
const http = require('http');
const socketIo = require('socket.io');

const authRoutes = require('./routes/authRoutes');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);
const PORT = process.env.PORT || 5000;

// Make io available to routes
app.set('io', io);

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files from uploads directory
app.use('/uploads', express.static('uploads'));

app.use('/api/auth', authRoutes);

// Basic route for testing
app.get('/', (req, res) => {
  res.send('Restaurant Management System API is running');
});

// Error handling middleware
app.use((err, req, res, next) => {
  logger.error(`API error: ${err.message}`);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Something went wrong on the server'
  });
});

// Setup Socket.io
io.on('connection', (socket) => {
  logger.info(`Client connected: ${socket.id}`);

  socket.on('disconnect', () => {
    logger.info(`Client disconnected: ${socket.id}`);
  });
});

// Initialize database and start server
const startServer = async () => {
  try {
    // Test database connection
    const isConnected = await testConnection();
    
    if (!isConnected) {
      logger.error('Failed to connect to the database. Server will not start.');
      process.exit(1);
    }
    
    // Sync database models
    await db.sync(false); // Pass true to force sync (drops tables)
    
    // Initialize with test data
    //await db.initData();
    
    // Start the server
    server.listen(PORT, () => {
      logger.info(`Server running on port ${PORT}`);
    });
  } catch (error) {
    logger.error(`Server initialization failed: ${error.message}`);
    process.exit(1);
  }
};

// Start server
startServer();

// Handle unhandled promise rejections
process.on('unhandledRejection', (error) => {
  logger.error(`Unhandled Rejection: ${error.message}`);
});

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
  logger.error(`Uncaught Exception: ${error.message}`);
  process.exit(1);
});

module.exports = app;