import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class DashboardData {
  final int todayOrdersCount;
  final double todayRevenue;
  final int activeTablesCount;
  final List<MenuItem> popularItems;
  final Map<String, double> weeklyRevenue;

  DashboardData({
    required this.todayOrdersCount,
    required this.todayRevenue,
    required this.activeTablesCount,
    required this.popularItems,
    required this.weeklyRevenue,
  });
}

class DashboardProvider with ChangeNotifier {
  DashboardData? _dashboardData;
  bool _isLoading = false;
  String? _error;
  DateTime _lastUpdated = DateTime.now();

  // Getters
  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get lastUpdated => _lastUpdated;

  // Constructor
  DashboardProvider() {
    // Load initial dashboard data
    refreshDashboard();
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Generate sample dashboard data
      _dashboardData = DashboardData(
        todayOrdersCount: 24,
        todayRevenue: 1250.75,
        activeTablesCount: 5,
        popularItems: [
          MenuItem(
            id: 3,
            name: 'Steak with Fries',
            description: 'Grilled ribeye steak with house fries',
            price: 25.99,
            categoryId: 2,
            imageUrl: 'assets/placeholders/menu/placeholder_food.png',
          ),
          MenuItem(
            id: 1,
            name: 'Bruschetta',
            description: 'Toasted bread with tomatoes, garlic, and basil',
            price: 8.99,
            categoryId: 1,
            imageUrl: 'assets/placeholders/menu/placeholder_food.png',
          ),
          MenuItem(
            id: 5,
            name: 'Chocolate Mousse',
            description: 'Rich chocolate mousse with fresh berries',
            price: 9.99,
            categoryId: 3,
            imageUrl: 'assets/placeholders/menu/placeholder_dessert.png',
          ),
        ],
        weeklyRevenue: {
          'Mon': 950.50,
          'Tue': 875.25,
          'Wed': 1100.00,
          'Thu': 1250.75,
          'Fri': 1800.25,
          'Sat': 2200.00,
          'Sun': 1950.50,
        },
      );

      _lastUpdated = DateTime.now();
    } catch (e) {
      _error = 'Failed to load dashboard data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get today's revenue
  double get todayRevenue => _dashboardData?.todayRevenue ?? 0.0;

  // Get today's orders count
  int get todayOrdersCount => _dashboardData?.todayOrdersCount ?? 0;

  // Get active tables count
  int get activeTablesCount => _dashboardData?.activeTablesCount ?? 0;

  // Get popular items
  List<MenuItem> get popularItems => _dashboardData?.popularItems ?? [];

  // Get weekly revenue
  Map<String, double> get weeklyRevenue => _dashboardData?.weeklyRevenue ?? {};

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
