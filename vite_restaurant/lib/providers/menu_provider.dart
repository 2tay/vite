import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';
import '../models/menu_item.dart';

// MenuProvider - Manages menu items and categories

class MenuProvider with ChangeNotifier {
  // Sample data for categories
  List<Category> _categories = [
    Category(
        id: 1, name: 'Appetizers', description: 'Starters and small dishes'),
    Category(id: 2, name: 'Main Courses', description: 'Filling main dishes'),
    Category(id: 3, name: 'Desserts', description: 'Sweet treats'),
    Category(id: 4, name: 'Beverages', description: 'Drinks and refreshments'),
  ];

  // Sample data for menu items
  List<MenuItem> _menuItems = [
    MenuItem(
      id: 1,
      name: 'Bruschetta',
      description: 'Toasted bread with tomatoes, garlic, and basil',
      price: 8.99,
      categoryId: 1,
      imageUrl: 'assets/placeholders/menu/placeholder_food.png',
    ),
    MenuItem(
      id: 2,
      name: 'Chicken Wings',
      description: 'Spicy chicken wings with blue cheese dip',
      price: 12.99,
      categoryId: 1,
      imageUrl: 'assets/placeholders/menu/placeholder_food.png',
    ),
    MenuItem(
      id: 3,
      name: 'Steak with Fries',
      description: 'Grilled ribeye steak with house fries',
      price: 25.99,
      categoryId: 2,
      imageUrl: 'assets/placeholders/menu/placeholder_food.png',
    ),
    MenuItem(
      id: 4,
      name: 'Grilled Salmon',
      description: 'Fresh salmon fillet with lemon butter sauce',
      price: 22.99,
      categoryId: 2,
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
    MenuItem(
      id: 6,
      name: 'Soft Drinks',
      description: 'Assorted soft drinks',
      price: 3.50,
      categoryId: 4,
      imageUrl: 'assets/placeholders/menu/placeholder_drink.png',
    ),
  ];

  // Getters
  List<Category> get categories => _categories;
  List<MenuItem> get menuItems => _menuItems;

  // Get menu items by category
  List<MenuItem> getMenuItemsByCategory(int categoryId) {
    return _menuItems.where((item) => item.categoryId == categoryId).toList();
  }

  // Get a category by ID
  Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get a menu item by ID
  MenuItem? getMenuItemById(int id) {
    try {
      return _menuItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new category
  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  // Update a category
  void updateCategory(Category updatedCategory) {
    final index =
        _categories.indexWhere((category) => category.id == updatedCategory.id);
    if (index != -1) {
      _categories[index] = updatedCategory;
      notifyListeners();
    }
  }

  // Delete a category
  void deleteCategory(int id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  // Add a new menu item
  void addMenuItem(MenuItem menuItem) {
    _menuItems.add(menuItem);
    notifyListeners();
  }

  // Update a menu item
  void updateMenuItem(MenuItem updatedMenuItem) {
    final index =
        _menuItems.indexWhere((item) => item.id == updatedMenuItem.id);
    if (index != -1) {
      _menuItems[index] = updatedMenuItem;
      notifyListeners();
    }
  }

  // Delete a menu item
  void deleteMenuItem(int id) {
    _menuItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Toggle item availability
  void toggleItemAvailability(int id) {
    final index = _menuItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _menuItems[index] = _menuItems[index].copyWith(
        isAvailable: !_menuItems[index].isAvailable,
      );
      notifyListeners();
    }
  }
}
