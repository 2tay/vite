// Authentication controller
const jwt = require('jsonwebtoken');
const db = require('../models');
const { logger } = require('../utils/logger');
const User = db.User;

// Generate JWT token
const generateToken = (user) => {
  return jwt.sign(
    { 
      id: user.id, 
      username: user.username, 
      role: user.role 
    },
    process.env.JWT_SECRET,
    { 
      expiresIn: '24h' 
    }
  );
};

// Login controller
const login = async (req, res) => {
  try {
    const { username, password } = req.body;

    // Validate request
    if (!username || !password) {
      return res.status(400).json({ 
        success: false, 
        message: 'Username and password are required' 
      });
    }

    // Find user by username
    const user = await User.findOne({ where: { username } });

    // Check if user exists
    if (!user) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid credentials' 
      });
    }

    // Check password
    const isPasswordValid = await user.checkPassword(password);
    if (!isPasswordValid) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid credentials' 
      });
    }

    // Generate token
    const token = generateToken(user);

    // Return success with token and user data
    return res.status(200).json({
      success: true,
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        username: user.username,
        name: user.name,
        role: user.role,
        email: user.email
      }
    });
  } catch (error) {
    logger.error(`Login error: ${error.message}`);
    return res.status(500).json({ 
      success: false, 
      message: 'An error occurred during login' 
    });
  }
};

// Register controller (for creating staff accounts - admin only)
const register = async (req, res) => {
  try {
    const { username, password, name, email, role } = req.body;

    // Validate request
    if (!username || !password || !name) {
      return res.status(400).json({ 
        success: false, 
        message: 'Username, password, and name are required' 
      });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ where: { username } });
    if (existingUser) {
      return res.status(400).json({ 
        success: false, 
        message: 'Username already exists' 
      });
    }

    // Create new user
    const newUser = await User.create({
      username,
      password, // Will be hashed by model hooks
      name,
      email,
      role: role || 'staff' // Default to staff if not specified
    });

    return res.status(201).json({
      success: true,
      message: 'User registered successfully',
      user: {
        id: newUser.id,
        username: newUser.username,
        name: newUser.name,
        role: newUser.role,
        email: newUser.email
      }
    });
  } catch (error) {
    logger.error(`Registration error: ${error.message}`);
    return res.status(500).json({ 
      success: false, 
      message: 'An error occurred during registration' 
    });
  }
};

// Get current user profile
const getProfile = async (req, res) => {
  try {
    // User should be available from auth middleware
    const userId = req.user.id;
    
    const user = await User.findByPk(userId, {
      attributes: ['id', 'username', 'name', 'role', 'email', 'created_at', 'updated_at']
    });

    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'User not found' 
      });
    }

    return res.status(200).json({
      success: true,
      user
    });
  } catch (error) {
    logger.error(`Get profile error: ${error.message}`);
    return res.status(500).json({ 
      success: false, 
      message: 'An error occurred while fetching profile' 
    });
  }
};

// Refresh token
const refreshToken = async (req, res) => {
  try {
    // User should be available from auth middleware
    const user = {
      id: req.user.id,
      username: req.user.username,
      role: req.user.role
    };
    
    // Generate new token
    const token = generateToken(user);

    return res.status(200).json({
      success: true,
      message: 'Token refreshed successfully',
      token
    });
  } catch (error) {
    logger.error(`Refresh token error: ${error.message}`);
    return res.status(500).json({ 
      success: false, 
      message: 'An error occurred while refreshing token' 
    });
  }
};

module.exports = {login, register, getProfile, refreshToken}