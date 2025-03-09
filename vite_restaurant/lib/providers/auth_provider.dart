import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _currentUser?.role == UserRole.admin;

  // Constructor
  AuthProvider() {
    // Initialize with no user
  }

  // Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // Validate credentials (simple check for demo)
      if (username == 'admin' && password == 'admin123') {
        _currentUser = User(
          id: 1,
          username: 'admin',
          name: 'Administrator',
          role: UserRole.admin,
          email: 'admin@restaurant.com',
          token: 'sample-admin-token',
        );
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else if (username == 'staff' && password == 'staff123') {
        _currentUser = User(
          id: 2,
          username: 'staff',
          name: 'Staff Member',
          role: UserRole.staff,
          email: 'staff@restaurant.com',
          token: 'sample-staff-token',
        );
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid username or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Check if user has required role
  bool hasRole(UserRole requiredRole) {
    if (!_isAuthenticated || _currentUser == null) {
      return false;
    }
    
    // Admin has access to everything
    if (_currentUser!.role == UserRole.admin) {
      return true;
    }
    
    // Otherwise, check if user has the specific required role
    return _currentUser!.role == requiredRole;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}