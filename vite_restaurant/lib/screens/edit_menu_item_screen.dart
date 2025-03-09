import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../models/category.dart';
import '../providers/menu_provider.dart';
import '../theme/colors.dart';

class EditMenuItemScreen extends StatefulWidget {
  final int? menuItemId; // Null for new items, non-null for editing

  const EditMenuItemScreen({
    Key? key,
    this.menuItemId,
  }) : super(key: key);

  @override
  _EditMenuItemScreenState createState() => _EditMenuItemScreenState();
}

class _EditMenuItemScreenState extends State<EditMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  int? _selectedCategoryId;
  bool _isAvailable = true;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMenuItem();
  }

  void _loadMenuItem() {
    if (widget.menuItemId != null) {
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      final menuItem = menuProvider.getMenuItemById(widget.menuItemId!);

      if (menuItem != null) {
        _nameController.text = menuItem.name;
        _descriptionController.text = menuItem.description;
        _priceController.text = menuItem.price.toString();
        _selectedCategoryId = menuItem.categoryId;
        _isAvailable = menuItem.isAvailable;
        _imageUrl = menuItem.imageUrl;
      }
    } else {
      // Set default category if creating new item
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      if (menuProvider.categories.isNotEmpty) {
        _selectedCategoryId = menuProvider.categories.first.id;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveMenuItem() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final menuProvider = Provider.of<MenuProvider>(context, listen: false);

      // Create MenuItem object
      final menuItem = MenuItem(
        id: widget.menuItemId ??
            0, // Will be assigned by provider for new items
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        categoryId: _selectedCategoryId!,
        imageUrl: _imageUrl,
        isAvailable: _isAvailable,
      );

      // Add or update menu item
      Future.delayed(const Duration(milliseconds: 500), () {
        if (widget.menuItemId == null) {
          menuProvider.addMenuItem(menuItem);
        } else {
          menuProvider.updateMenuItem(menuItem);
        }

        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNewItem = widget.menuItemId == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNewItem ? 'Add Menu Item' : 'Edit Menu Item'),
        actions: [
          if (!isNewItem)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirmation,
              tooltip: 'Delete Item',
            ),
        ],
      ),
      body: Consumer<MenuProvider>(
        builder: (context, menuProvider, _) {
          final categories = menuProvider.categories;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Image selection
                _buildImageSelector(),
                const SizedBox(height: 24),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Price field
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    try {
                      final price = double.parse(value);
                      if (price <= 0) {
                        return 'Price must be greater than zero';
                      }
                    } catch (e) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category selection
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategoryId,
                  items: categories.map((Category category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedCategoryId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Availability toggle
                SwitchListTile(
                  title: const Text('Available'),
                  subtitle: Text(
                    _isAvailable
                        ? 'Item is available for order'
                        : 'Item is not available for order',
                  ),
                  value: _isAvailable,
                  onChanged: (bool value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                  activeColor: AppColors.success,
                ),
                const SizedBox(height: 24),

                // Save button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveMenuItem,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isNewItem ? 'Add Item' : 'Save Changes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSelector() {
    return GestureDetector(
      onTap: _selectImage,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
          image: _imageUrl != null
              ? DecorationImage(
                  image: AssetImage(_imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _imageUrl == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_a_photo,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add Item Photo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  void _selectImage() {
    // This would normally open image picker
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // Add camera functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);

                  // For demo, we'll just set a placeholder image
                  setState(() {
                    _imageUrl = 'assets/placeholders/menu/placeholder_food.png';
                  });
                },
              ),
              if (_imageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove Photo',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _imageUrl = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text(
          'Are you sure you want to delete this menu item? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context); // Close dialog

              final menuProvider =
                  Provider.of<MenuProvider>(context, listen: false);
              menuProvider.deleteMenuItem(widget.menuItemId!);

              Navigator.pop(context); // Return to menu screen
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
