// Authentication middleware
const jwt = require('jsonwebtoken');
const db = require('../models');
const { logger } = require('../utils/logger');
const User = db.User;

// Verify JWT token middleware
const verifyToken = async (req, res, next) => {
  try {
    // Get token from authorization header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'No token provided'
      });
    }
    
    const token = authHeader.split(' ')[1];
    
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Find user
    const user = await User.findByPk(decoded.id, {
      attributes: ['id', 'username', 'role']
    });
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid token'
      });
    }
    
    // Add user to request object
    req.user = user;
    
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: 'Token expired'
      });
    }
    
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({
        success: false,
        message: 'Invalid token'
      });
    }
    
    logger.error(`Auth middleware error: ${error.message}`);
    return res.status(401).json({
      success: false,
      message: 'Failed to authenticate'
    });
  }
};

// Check if user is admin
const isAdmin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    return res.status(403).json({
      success: false,
      message: 'Access denied. Admin role required'
    });
  }
};

// Check if user is staff or admin
const isStaffOrAdmin = (req, res, next) => {
  if (req.user && (req.user.role === 'staff' || req.user.role === 'admin')) {
    next();
  } else {
    return res.status(403).json({
      success: false,
      message: 'Access denied. Staff or admin role required'
    });
  }
};

module.exports = { verifyToken, isAdmin, isStaffOrAdmin };