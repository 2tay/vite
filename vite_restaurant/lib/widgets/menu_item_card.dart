import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/menu_provider.dart';
import '../theme/colors.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final bool isAdmin;

  const MenuItemCard({
    Key? key,
    required this.menuItem,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menu item image
              AspectRatio(
                aspectRatio: 1.2,
                child: menuItem.imageUrl != null
                    ? Image.asset(
                        menuItem.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),

              // Item details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Availability indicator
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: menuItem.isAvailable
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Item name
                        Expanded(
                          child: Text(
                            menuItem.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Item description
                    Text(
                      menuItem.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Item price
                    Text(
                      '\$${menuItem.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Admin actions
          if (isAdmin)
            Positioned(
              top: 8,
              right: 8,
              child: _buildAdminActions(context),
            ),

          // Availability overlay
          if (!menuItem.isAvailable)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'UNAVAILABLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 64,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildAdminActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Toggle availability
          IconButton(
            icon: Icon(
              menuItem.isAvailable ? Icons.visibility : Icons.visibility_off,
              color: menuItem.isAvailable ? AppColors.success : AppColors.error,
              size: 20,
            ),
            onPressed: () {
              Provider.of<MenuProvider>(context, listen: false)
                  .toggleItemAvailability(menuItem.id);
            },
            tooltip: menuItem.isAvailable
                ? 'Mark as unavailable'
                : 'Mark as available',
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),

          // Edit menu item
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.info,
              size: 20,
            ),
            onPressed: () {
              // Navigate to edit screen
              _showEditDialog(context);
            },
            tooltip: 'Edit item',
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${menuItem.name}'),
        content: const Text('This would open a form to edit this menu item.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to edit form
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
