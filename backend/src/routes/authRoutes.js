// Authentication routes
const express = require('express');
const router = express.Router();
const {
    login, 
    register, 
    getProfile, 
    refreshToken
} = require('../controllers/authController');
const {
    verifyToken,
    isAdmin,
    isStaffOrAdmin
} = require('../middleware/authMiddleware');

// Login route - Public
router.post('/login', login);

// Register route - Admin only
router.post('/register', 
  verifyToken, 
  isAdmin, 
  register
);

// Get current user profile - Authenticated users
router.get('/profile', 
  verifyToken, 
  getProfile
);

// Refresh token - Authenticated users
router.post('/refresh-token', 
  verifyToken, 
  refreshToken
);

module.exports = router;