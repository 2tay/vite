import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/menu_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/colors.dart';
import '../widgets/menu_item_card.dart';
import 'edit_menu_item_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _showOnlyAvailable = false;
  bool _isTabControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    // We'll initialize the TabController properly in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get MenuProvider to initialize TabController
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);

    // Only initialize if we haven't done so already and if we have categories
    if (!_isTabControllerInitialized && menuProvider.categories.isNotEmpty) {
      _tabController = TabController(
        length: menuProvider.categories.length,
        vsync: this,
      );
      _isTabControllerInitialized = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Only dispose the controller if it was initialized
    if (_isTabControllerInitialized) {
      _tabController.dispose();
    }
    super.dispose();
  }

  void _filterMenuItems() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _toggleAvailabilityFilter() {
    setState(() {
      _showOnlyAvailable = !_showOnlyAvailable;
    });
  }

  void _showAddItemDialog(BuildContext context, int categoryId) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    final category = menuProvider.getCategoryById(categoryId);

    if (category == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Item to ${category.name}'),
        content: Text(
            'Do you want to add a new menu item to the ${category.name} category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to add item form
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditMenuItemScreen(
                            menuItemId: null, // null for new item
                          )));
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MenuProvider, AuthProvider>(
      builder: (context, menuProvider, authProvider, _) {
        // Handle the case where we don't have categories yet
        if (menuProvider.categories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Initialize or update TabController if needed
        if (!_isTabControllerInitialized) {
          _tabController = TabController(
            length: menuProvider.categories.length,
            vsync: this,
          );
          _isTabControllerInitialized = true;
        } else if (_tabController.length != menuProvider.categories.length) {
          // If the number of categories has changed, recreate the controller
          _tabController.dispose();
          _tabController = TabController(
            length: menuProvider.categories.length,
            vsync: this,
          );
        }

        return Scaffold(
          body: Column(
            children: [
              // Search and filter bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search menu items...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterMenuItems();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (_) => _filterMenuItems(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter toggle button
                    FilterChip(
                      label: const Text('Available Only'),
                      selected: _showOnlyAvailable,
                      onSelected: (_) => _toggleAvailabilityFilter(),
                      backgroundColor: Colors.grey[200],
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              // Category tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: menuProvider.categories.map((category) {
                  return Tab(text: category.name);
                }).toList(),
              ),

              // Menu items by category
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: menuProvider.categories.map((category) {
                    // Filter menu items based on search and availability
                    final items = menuProvider
                        .getMenuItemsByCategory(category.id)
                        .where((item) =>
                            item.name.toLowerCase().contains(_searchQuery) ||
                            item.description
                                .toLowerCase()
                                .contains(_searchQuery))
                        .where(
                            (item) => !_showOnlyAvailable || item.isAvailable)
                        .toList();

                    return items.isEmpty
                        ? _buildEmptyState(category.id)
                        : _buildMenuItemsGrid(items, authProvider.isAdmin);
                  }).toList(),
                ),
              ),
            ],
          ),
          floatingActionButton: authProvider.isAdmin
              ? FloatingActionButton(
                  onPressed: () {
                    final currentCategoryId =
                        menuProvider.categories[_tabController.index].id;
                    _showAddItemDialog(context, currentCategoryId);
                  },
                  child: const Icon(Icons.add),
                  tooltip: 'Add menu item',
                )
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState(int categoryId) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final category = menuProvider.getCategoryById(categoryId);

    String message = 'No items found';
    if (_searchQuery.isNotEmpty) {
      message = 'No items match your search';
    } else if (_showOnlyAvailable) {
      message = 'No available items in this category';
    } else {
      message = 'No items in this category';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          if (authProvider.isAdmin)
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text('Add to ${category?.name ?? "Category"}'),
              onPressed: () => _showAddItemDialog(context, categoryId),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItemsGrid(List<MenuItem> items, bool isAdmin) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: isAdmin
              ? () {
                  // Navigate to edit menu item screen when admin taps on an item
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMenuItemScreen(
                        menuItemId: items[index].id,
                      ),
                    ),
                  );
                }
              : null,
          child: MenuItemCard(
            menuItem: items[index],
            isAdmin: isAdmin,
          ),
        );
      },
    );
  }
}
