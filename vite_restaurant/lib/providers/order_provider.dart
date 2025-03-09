import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/order_item.dart';

// OrderProvider - Handles orders, order items, and order status changes

class OrderProvider with ChangeNotifier {
  // Sample data for orders
  List<Order> _orders = [
    Order(
      id: 1,
      tableId: 3,
      status: OrderStatus.preparing,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      items: [
        OrderItem(
          id: 1,
          orderId: 1,
          menuItemId: 1,
          menuItemName: 'Bruschetta',
          quantity: 2,
          unitPrice: 8.99,
        ),
        OrderItem(
          id: 2,
          orderId: 1,
          menuItemId: 3,
          menuItemName: 'Steak with Fries',
          quantity: 1,
          unitPrice: 25.99,
        ),
      ],
      specialInstructions: 'No garlic on bruschetta please',
    ),
    Order(
      id: 2,
      tableId: 1,
      status: OrderStatus.received,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      items: [
        OrderItem(
          id: 3,
          orderId: 2,
          menuItemId: 2,
          menuItemName: 'Chicken Wings',
          quantity: 1,
          unitPrice: 12.99,
        ),
        OrderItem(
          id: 4,
          orderId: 2,
          menuItemId: 6,
          menuItemName: 'Soft Drinks',
          quantity: 2,
          unitPrice: 3.50,
        ),
      ],
    ),
    Order(
      id: 3,
      tableId: 5,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      items: [
        OrderItem(
          id: 5,
          orderId: 3,
          menuItemId: 4,
          menuItemName: 'Grilled Salmon',
          quantity: 2,
          unitPrice: 22.99,
        ),
        OrderItem(
          id: 6,
          orderId: 3,
          menuItemId: 5,
          menuItemName: 'Chocolate Mousse',
          quantity: 2,
          unitPrice: 9.99,
        ),
      ],
    ),
  ];

  // Getters
  List<Order> get orders => _orders;
  List<Order> get activeOrders => _orders
      .where((order) =>
          order.status == OrderStatus.received ||
          order.status == OrderStatus.preparing ||
          order.status == OrderStatus.ready)
      .toList();

  // Get orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Get orders by table
  List<Order> getOrdersByTable(int tableId) {
    return _orders.where((order) => order.tableId == tableId).toList();
  }

  // Get active order for a table (if exists)
  Order? getActiveOrderForTable(int tableId) {
    try {
      return _orders.firstWhere((order) =>
          order.tableId == tableId &&
          (order.status == OrderStatus.received ||
              order.status == OrderStatus.preparing ||
              order.status == OrderStatus.ready));
    } catch (e) {
      return null;
    }
  }

  // Get order by ID
  Order? getOrderById(int id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new order
  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  // Update order status
  void updateOrderStatus(int orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  // Add item to an existing order
  void addItemToOrder(int orderId, OrderItem newItem) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final updatedItems = List<OrderItem>.from(_orders[index].items)
        ..add(newItem);
      _orders[index] = _orders[index].copyWith(items: updatedItems);
      notifyListeners();
    }
  }

  // Remove item from an order
  void removeItemFromOrder(int orderId, int itemId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final updatedItems = List<OrderItem>.from(_orders[orderIndex].items)
        ..removeWhere((item) => item.id == itemId);
      _orders[orderIndex] = _orders[orderIndex].copyWith(items: updatedItems);
      notifyListeners();
    }
  }

  // Update item quantity in an order
  void updateItemQuantity(int orderId, int itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItemFromOrder(orderId, itemId);
      return;
    }

    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final itemIndex =
          _orders[orderIndex].items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final updatedItem = _orders[orderIndex]
            .items[itemIndex]
            .copyWith(quantity: newQuantity);
        final updatedItems = List<OrderItem>.from(_orders[orderIndex].items);
        updatedItems[itemIndex] = updatedItem;
        _orders[orderIndex] = _orders[orderIndex].copyWith(items: updatedItems);
        notifyListeners();
      }
    }
  }

  // Create a new order
  int createOrder(int tableId, List<OrderItem> items,
      {String? specialInstructions, int? createdBy}) {
    // Generate a new ID (in a real app, this would come from the backend)
    final newId = _orders.isNotEmpty
        ? _orders.map((o) => o.id).reduce((a, b) => a > b ? a : b) + 1
        : 1;

    // Create new order
    final newOrder = Order(
      id: newId,
      tableId: tableId,
      status: OrderStatus.received,
      createdAt: DateTime.now(),
      items: items.map((item) => item.copyWith(orderId: newId)).toList(),
      specialInstructions: specialInstructions,
      createdBy: createdBy,
    );

    _orders.add(newOrder);
    notifyListeners();
    return newId;
  }

  // Cancel an order
  void cancelOrder(int orderId) {
    updateOrderStatus(orderId, OrderStatus.cancelled);
  }
}
